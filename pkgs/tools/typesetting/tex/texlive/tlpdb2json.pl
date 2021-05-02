#!/usr/bin/env perl

=head1 NAME

F<tlpdb2json.pl> - convert a TeX Live Package Database to a JSON Nix
expression

=head1 SYNOPSIS

 unxz --stdout texlive-daily-20210408-texlive.tlpdb.xz \
   | perl tlpdb2json.pl > texlive-daily-20210408.tlpdb.json

=head1 DESCRIPTION

This script converts each package to the attribute set used to create a
derivation and saves some metadata about the database as follows

 {
  "_meta":{
   "frozen":false,
   "release":"2021",
   "revision":"58792"
  },
  "collections":{
   "collection-basic":{
   [ ... ]
  },
  "packages":{
   "12many":{
    "doc":{
     "hash":"sha512-[ ... ]
   [ ... ]
  "schemes":{
   [ ... ]

Many keys are passed through as they are.  A few keys are converted to a
native type (e.g. C<relocated> is converted to a boolean. The keys that
are converted to arrays are pluralised (e.g. C<depend> becomes
C<depends>). Many keys need special handling, documented below.

The script raises an error whenever the database contains something
unexpected, such as new keys or new postactions. This is to help catch
changes to the database format in the future.

Metadata such as description and homepage are currently ignored as they
cannot be used with the current packaging approach.

=over

=item C<category>

The packages of category Scheme and Collection are separated into the
attribute set C<schemes> and C<collections> to distinguish them from
C<pkgs>. Note that only schemes and collections can depend on
collections, and nothing can depend on schemes. The category is omitted
when equal to 'Package'.

=item C<postaction>

The C<file> argument of C<postaction script> is added to a list. See
L<TeXLive::TLUtils/do_post_action> for its semantics.

=item C<execute add{|Kanji|Mixed}Map fontmap> -> C<maps>

Font map entries are parsed as C<< fontmap -> type >> hash. See
L<TeXLive::TLPOBJ/updmap_cfg_lines>.

=item C<execute AddFormat args> -> C<formats = [ ... %args ... ]>

=item C<execute AddHyphen args> -> C<hyphens = [ ... %args ... ]>

See L<TeXLive::TLUtils/parse_AddFormat_line>,
L<TeXLive::TLUtils/parse_AddHyphen_line> for the default values of
missing keys; L<TeXLive::TLUtils/fmtutil_cnf_lines>,
L<TeXLive::TLUtils/language_dat_lines>,
L<TeXLive::TLUtils/updmap_cfg_lines> for how to generate the lines in
F<fmtutil.cnf>, F<language.{dat,def,dat.lua}>, F<updmap.cfg>.

C<fmttriggers> are always dependencies, so we drop them, as Nix already
rebuilds the formats whenever a dependency is updated. An error is
raised if this assumption does not hold.

C<mode=disabled> is converted to C<enabled = false>.

=item C<{bin,doc,run,src}files>

Currently disabled: if the containers have man and info pages, or some
distribution files (the tlpkg/ folder), corresponding boolean attributes
C<{bin,doc,run,source}.{man,info}> are set to true. The list of files is
omitted from the final JSON Nix expression.

If the C<runfiles> list is empty, then the only file in the container
is F<tlpkg/tlobj>. Its content is already in the TLPDB, so we omit the
hash for this container.

The container C<src> is translated to C<source> for backward
compatibility.

=item C<00texlive.config>

The relevant database metadata in the C<00texlive.config> pseudopackage
is saved into C<meta>.

=back

=cut

use strict;
use warnings;

use JSON::PP;
use MIME::Base64;
use Text::ParseWords;

# === VALID PACKAGE NAMES AND VERSION NUMBERS
my $pkgName = qr/[-_.[:alnum:]]+/;
my $versionNumber = qr/[-.+~, :\(\)[:alnum:]]+/;

# === PACKAGES TO OMIT
# The list is as explicit as feasible. New packages with a . in the
# name will cause an error.

# pre-built binaries: package.architecture
# binary dependency: package.ARCH
my $binaryPkg = qr/^.*\.(?:win32|universal-darwin|aarch64|amd64|armhf|i386|x86_64|ARCH).*$/x;

my $omittedPkg = qr/^(00texlive\.(image|installation|installer) # installer
                      |texlive\.infra            # tlmgr and perl modules
                      # TODO: reenable later |texlive-msg-translations  # translations for the above
                      |$binaryPkg)$/x;       # architecture specific binaries

# === KEYS
# New keys will cause an error.

# keys for meta attrs that can be passed through as is
my $metaKeys = qr/^(?:shortdesc
                     |catalogue-(?:contact-(?:announce|home)|ctan)
                                  # for meta.{homepage,changelog}
                   )$/x;

# TODO: review catalogue-alias
my $omittedKeys = qr/^(?:catalogue
                       |$metaKeys  # TODO: enable metadata
                       |catalogue-(?:alias|also
                                   |(?:contact-(bugs|development|repository|support))
                                   |topics)
                       |(?:doc|src)?containersize)$/x;

# passed through as is
my $verbatimKeys = qr/^(?:category
                        |revision
                       )$/x;

# === ARGUMENTS FOR AddFormat, AddHyphen
# New arguments will cause an error.

# see L<TeXLive::TLUtils/parse_AddFormat_line>
my $acceptedFormatArgs = ['name', 'mode', 'engine', 'options',
                          'patterns', 'fmttriggers'];
# see L<TeXLive::TLUtils/parse_AddHyphen_line>
my $acceptedHyphenArgs = ['name', 'file', 'file_exceptions',
                          'file_patterns', 'lefthyphenmin',
                          'righthyphenmin', 'synonyms', 'databases',
                          'luaspecial', 'comment'];

# === POSTACTIONS
# see L<TeXLive::TLUtils/do_postaction>
my $omittedPostactions = qr/file(?:assoc|type)|progid|shortcut/;

# === UTILS

# convert from hexadecimal sha512 to sri
sub hash_to_sri {
  my $hex = $_[0];
  return 'sha512-' . MIME::Base64::encode_base64((pack "H*", $hex), '');
}

# die if $1 is not a subset of $2 (both must be array references)
# print error message $3
sub must_be_subset {
  my ($a, $b, $err) = @_;
  my %h; @h{@$a} = (); delete @h{@$b};
  if (%h) {
    $err .= "\nUnexpected";
    for my $k (keys %h) { $err .= " $k"; }
    die ($err . ".\n"); }
}

# parse execute and postaction lines (except addMap)
sub parse_execute {
  my ($key, $value) = @_;
  my ($action, $args) = $value =~ /^([^\s]+)\s+(.*)$/ or die "Cannot parse $key '$value'.";

  # parse list of key=value arguments into a hash, where the values may
  # be quoted strings
  my %data;
  my @words = quotewords('\s+', 0, $args);
  for my $word (@words) {
    my ($k, $v) = split('=', $word, 2);
    $data{$k} = $v;
  }

  # postaction script file=:
  if ($key eq 'postaction' and $action eq 'script') {
    my $file;
    delete $data{'file'};
    die "Unexpected arguments in $key $action.\n" if %data;
    return ('postactions', $file);
  }

  elsif ($key eq 'execute' and $action =~ /^Add(Format|Hyphen)$/) {

    # check that the arguments are within the expected ones
    if ($1 eq 'Format') {
      must_be_subset([keys %data], $acceptedFormatArgs, "Unexpected arguments in $key $action.");
    } elsif ($1 eq 'Hyphen') {
      must_be_subset([keys %data], $acceptedHyphenArgs, "Unexpected arguments in $key $action.");
    }

    # split comma separated lists that will be used by Nix
    # (note: $acceptedFormatArgs and $acceptedHyphenArgs are disjoint)
    for my $list ('databases', 'synonyms', 'fmttriggers') {
      if (exists $data{$list}) {
        $data{$list} = \@{[ split(',', $data{$list}) ]};
      }
    }

    if (exists $data{'mode'}) {
      die "Unexpected mode '$data{'mode'}' in $key $action." if not $data{'mode'} eq 'disabled';
      $data{'enabled'} = JSON::PP::false;
    }

    return (lc($1) . 's', \%data);
  } else {
    die "Unrecognized $key '$action'.";
  }
}

# === PARSER

# the database
my %db;

# to check that the database does not end mid-package
my $in_package = 0;

while (<>) {
  my ($pname) = /^name\s+($pkgName)$/ or die "Unexpected line '$_'.";
  my (%p, $run_checksum, $tlType, $relocated);

  $in_package = 1;

  if ($pname =~ $omittedPkg) {
    while (<> !~ /^$/) { }
    $in_package = 0;
    next;
  }

  while (<>) {
    if (/^$/) {
      # end of package
      $in_package = 0;
      last;
    }

    my ($key, $value) = m/^([^\s]*)\s+(.+)$/ or die "Unexpected line '$_'.";

    # omitted lines
    next if ($key =~ $omittedKeys)
            || ($key eq 'category' and $value eq 'Package')
            || ($key eq 'postaction' and $value =~ /^$omittedPostactions/);

    if ($key eq 'relocated') {
      die "Unexpected relocated '$value'." unless $value eq '1';
      # output only if there are files
      $relocated = 1;
    }

    elsif ($key eq 'longdesc') {
      # TODO: enable metadata
      # $p{'longdesc'} .= $value . "\n";
    }

    elsif ($key eq 'depend') {
      push(@{ $p{'depends'} }, $value) unless $value =~ $omittedPkg;
    }

    elsif ($key =~ /^(|doc|src)containerchecksum$/) {
      if ($1 eq '') {
        # output only if there are runfiles
        $run_checksum = hash_to_sri($value);
      } else {
        $p{$1 eq 'src' ? 'source' : $1}{'hash'} = hash_to_sri($value);
      }
    }

    elsif ($key =~ /^(run|doc|src|bin)files$/) {
      $tlType = $1 eq 'src' ? 'source' : $1;
      if (defined $relocated) {
        $p{'relocated'} = JSON::PP::true;
      }
      if ($1 eq 'run') {
        # found runfiles, output the run checksum
        $p{'run'}{'hash'} = $run_checksum;
      }
      # arch= and size= are irrelevant for Nix
      for my $kv (split(' ', $value)) {
        die "Unexpected '$kv' in '$key'." unless $kv =~ /^(arch=|size=)/;
      }
    }

    elsif ($key eq '') {
      # TODO: enable man, info, tlpkg detection
      # if ($value =~ m,^(?:RELOC|texmf-dist)/doc/(man|info)/,) {
      #   # there are man pages, info pages...
      #   $p{$tlType}{$1} = JSON::PP::true;
      # } elsif ($value =~ m,^tlpkg/,) {
      #   # ...and tlpkg files
      #   $p{$tlType}{'tlpkg'} = JSON::PP::true;
      # }
      # # TODO: review key=value arguments after file names
    }

    elsif ($key eq 'catalogue-license') {
      # TODO: enable metadata
      # @{ $p{'catalogue-licenses'} } = split(' ', $value);
    }

    elsif ($key eq 'catalogue-version') {
      # normalize to valid Nix version number
      $value =~ tr!~ !\-_!; $value =~ s/[:\(\),]//g;
      die "Invalid version number '$value' after normalization." unless $value =~ $versionNumber;
      $p{'catalogue-version'} = $value;
    }

    # add(type)Map fontmap -> maps.fontmap = type
    elsif ($key eq 'execute' and
           $value =~ /^add((?:|Kanji|Mixed)Map)\s+(.*)$/) {
      $p{'maps'}{$2} = $1;
    }

    elsif ($key =~ /^(execute|postaction)$/) {
      my ($type, $data) = parse_execute($key, $value);
      push(@{ $p{$type} }, $data);

      # check assumption that *all triggers are dependencies*,
      # which means that Nix does not need to implement triggers
      # raise an error should this ever change
      if ($type eq 'formats' and exists $data->{'fmttriggers'}) {
        my @deps = ($pname);
        push(@deps, @{ $p{'depends'} });
        must_be_subset(\@{ $data->{'fmttriggers'} }, \@deps, "Some triggers are not dependencies for '$pname'!");
        delete $data->{'fmttriggers'};
      }
    }

    elsif ($key =~ $verbatimKeys) {
      # die "Unexpected key '$key'.\n" unless $key =~ $verbatimKeys;
      $p{$key} = $value;
    } else {
      die "Unexpected '$key'.";
    }
  }

  if (exists $p{'category'} and $p{'category'} =~ /^(Scheme|Collection)$/) {
    delete $p{'category'};
    $db{lc($1) . 's'}{$pname} = \%p;
  } else {
    $db{'packages'}{$pname} = \%p;
  }
}

die "Last line is not empty." if $in_package;

# double check that metapackages have no actual content
for my $cat ('schemes', 'collections') {
  for my $key (keys %{ $db{$cat} }) {
    if (exists $db{$cat}{$key}{'bin'}
        or exists $db{$cat}{$key}{'doc'}
        or exists $db{$cat}{$key}{'run'}
        or exists $db{$cat}{$key}{'src'}) {
      die "Unexpected content in '$key'."; }
  }
}

# === DATABASE METADATA
for my $meta (@{ $db{'packages'}{'00texlive.config'}{'depends'} }) {
  my ($key, $value) = $meta =~ m,^([^/]+)/([^/]+)$,
    or die "Cannot parse '$meta' in 00texlive.config.";

  next if $key =~ /^(container_(format|split_(doc_|src_)files)|minrelease)/;

  if ($key =~ /^(release|revision)$/) {
    # version info
    $db{'_meta'}{$key} = $value;
  } elsif ($key eq 'frozen') {
    # final or snapshot?
    die "Unexpected frozen = '$value'." unless $value =~ /^0|1$/;
    $db{'_meta'}{'frozen'} = $value ? JSON::PP::true : JSON::PP::false;
  }
}

# remove metadata package
delete $db{'packages'}{'00texlive.config'};

# === OUTPUT
# split output on several lines (indent) and sort the keys (canonical)
my $json = JSON::PP->new->indent->indent_length(1)->canonical;

print $json->encode(\%db);
