#!/usr/bin/env perl

=head1 NAME

F<tlpdb2json.pl> - convert a TeX Live Package Database to JSON

=head1 SYNOPSIS

 unxz --stdout texlive-daily-20210408-texlive.tlpdb.xz \
   | perl tlpdb2json.pl > texlive-daily-20210408.tlpdb.json

=head1 DESCRIPTION

This script converts the package database to a JSON file. The output
conforms to the TLPDBSINGLE entry of
L<https://www.tug.org/texlive/devsrc/Master/tlpkg/doc/json-formats.txt>
except for the changes below.

The script raises an error whenever the database contains something
unexpected, such as new keys or new postactions. This is to help catch
changes to the database format in the future.

=over

=item C<tlpkgs>

Instead of a list of packages, C<tlpkgs> is an attribute set of the form
C<< name -> tlpkg >>. The attribute C<name> is removed from the package.
I presume this plays better with lazy evaluation.

=item C<category>

Omitted when equal to C<Package>.

=item C<cataloguedata.version>

Normalized to a valid version number.

=item C<(bin|doc|run|src)files>

Omitted.

=item C<relocated>

Omitted if C<(doc|run|src)files> are all empty.

=item C<(|doc|src)containerchecksum>

Converted to SRI. C<containerchecksum> is omitted if C<runfiles> is
empty, as in that case the container only has a F<tlpkg/tlobj> file,
whose content is already in the database.

=item C<postactions>

Only the C<script> actions are saved into the array
C<postactions.scripts>. See L<TeXLive::TLUtils/do_post_action> for
their semantics.

=item C<executes>

These are fully parsed and saved into the arrays C<executes.formats>,
C<execute.hyphens>, C<executes.maps> as follows.

=over

=item C<add{|Kanji|Mixed}Map fontmap> -> C<< fontmap -> type >>

See L<TeXLive::TLPOBJ/updmap_cfg_lines>.

=item C<AddFormat args>

=item C<AddHyphen args>

See L<TeXLive::TLUtils/parse_AddFormat_line>,
L<TeXLive::TLUtils/parse_AddHyphen_line> for the default values of
missing keys; L<TeXLive::TLUtils/fmtutil_cnf_lines>,
L<TeXLive::TLUtils/language_dat_lines>,
L<TeXLive::TLUtils/updmap_cfg_lines> for how to generate the lines in
F<fmtutil.cnf>, F<language.{dat,def,dat.lua}>, F<updmap.cfg>.

C<fmttriggers> are always dependencies, so we drop them, as Nix already
rebuilds the formats whenever a dependency is updated. An error is
raised if this assumption does not hold.

The comma-separated lists that should be used by Nix (such as
C<synonyms>) are split into lists.

C<mode=disabled> is converted the boolean C<enabled:false>.

=back

=item Other keys

All the other keys, including metadata such as description and homepage,
are currently ignored because either they are irrelevant, or they cannot
be used with the current packaging approach.

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

# as per json-formats.txt, catalogue-* keys go into cataloguedata
# useful for for meta.{homepage,changelog}
my $catalogueKeys = qr/^catalogue-(contact-(?:announce|home)|ctan)$/x;

# TODO: review catalogue-alias
my $omittedKeys = qr/^(?:catalogue
                       |shortdesc
                       |$catalogueKeys  # TODO: enable metadata
                       |catalogue-(?:alias|also
                                   |(?:contact-(?:bugs|development|repository|support))
                                   |topics)
                       |(?:doc|src)?containersize)$/x;

# passed through as is
my $verbatimKeys = qr/^(?:category
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
my $acceptedScriptArgs = ['file'];

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

  if ($key eq 'postaction' and $action eq 'script') {
    must_be_subset([keys %data], $acceptedScriptArgs, "Unexpected arguments in $key $action.");
    return ('scripts', \%data);
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
      $p{'relocated'} = JSON::PP::true;
    }

    elsif ($key eq 'revision') {
      die "Revision '$value' is not a number." unless $value =~ /^[0-9]+$/;
      $p{'revision'} = 0 + $value;
    }

    elsif ($key eq 'longdesc') {
      # TODO: enable metadata
      # $p{'longdesc'} .= $value . "\n";
    }

    elsif ($key eq 'depend') {
      push(@{ $p{'depends'} }, $value) unless $value =~ $omittedPkg;
    }

    elsif ($key =~ /^(?:|doc|src)containerchecksum$/) {
      $p{$key} = hash_to_sri($value);
    }

    elsif ($key =~ /^(run|doc|src|bin)files$/) {
      if ($1 eq 'run') {
        $p{'runfiles'} = JSON::PP::true;
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
      # @{ $p{'catalogue'}{'license'} } = split(' ', $value);
    }

    elsif ($key eq 'catalogue-version') {
      # normalize to valid Nix version number
      $value =~ tr!~ !\-_!; $value =~ s/[:\(\),]//g;
      die "Invalid version number '$value' after normalization." unless $value =~ $versionNumber;
      $p{'cataloguedata'}{'version'} = $value;
    }

    # add(type)Map fontmap -> maps.fontmap = type
    elsif ($key eq 'execute' and
           $value =~ /^add((?:|Kanji|Mixed)Map)\s+(.*)$/) {
      $p{'executes'}{'maps'}{$2} = $1;
    }

    elsif ($key =~ /^(execute|postaction)$/) {
      my ($type, $data) = parse_execute($key, $value);
      push(@{ $p{$1 . 's'}{$type} }, $data);

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

  # remove checksum if no runfiles
  if (!exists $p{'runfiles'}) {
    delete $p{'containerchecksum'};
  }

  # remove relocated if no files
  if (!exists $p{'containerchecksum'} and !exists $p{'doccontainerchecksum'} and !exists $p{'srccontainerchecksum'}) {
    delete $p{'relocated'};
  }

  # double check that metapackages contain no files
  if (exists $p{'category'} and $p{'category'} =~ /^(Scheme|Collection)$/) {
    if (exists $p{'binfiles'}
        or exists $p{'docfiles'}
        or exists $p{'runfiles'}
        or exists $p{'srcfiles'}) {
      die "Unexpected content in '$pname'.";
    }
  }

  # remove *files = true markers
  for my $key ('bin', 'doc', 'run', 'src') {
    delete $p{$key . 'files'};
  }

  # TODO: split at least schemes away from actual packages
  #if (exists $p{'category'} and $p{'category'} =~ /^(Scheme|Collection)$/) {
  #  delete $p{'category'};
  #  $db{lc($1) . 's'}{$pname} = \%p;
  #} else {
  $db{'tlpkgs'}{$pname} = \%p;
  #}
}

die "Last line is not empty." if $in_package;

# === DATABASE METADATA
for my $meta (@{ $db{'tlpkgs'}{'00texlive.config'}{'depends'} }) {
  my ($key, $value) = $meta =~ m,^([^/]+)/([^/]+)$,
    or die "Cannot parse '$meta' in 00texlive.config.";

  next if $key =~ /^(container_(format|split_(doc_|src_)files)|minrelease)/;

  if ($key eq 'release') {
    $db{'configs'}{$key} = $value;
  } elsif ($key eq 'revision') {
    die "Revision '$value' is not a number." unless $value =~ /^[0-9]+$/;
    $db{'configs'}{$key} = 0 + $value;
  } elsif ($key eq 'frozen') {
    # final or snapshot?
    die "Unexpected frozen = '$value'." unless $value =~ /^0|1$/;
    $db{'configs'}{'frozen'} = $value ? JSON::PP::true : JSON::PP::false;
  }
}

# remove metadata package
delete $db{'tlpkgs'}{'00texlive.config'};

# === OUTPUT
# split output on several lines (indent) and sort the keys (canonical)
my $json = JSON::PP->new->indent->indent_length(1)->canonical;

print $json->encode(\%db);
