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
except for the changes below and some omitted entries.

The script raises an error whenever the database contains something
unexpected, such as new keys or new postactions. This is to help catch
changes to the database format in the future.

=over

=item C<category>

Omitted when equal to C<Package>.

=item C<cataloguedata.version>

Normalized to a valid version number.

=item C<relocated>

Omitted if C<(doc|run|src)files> are all empty.

=item C<containerchecksum>

C<containerchecksum> is omitted if C<runfiles> is empty, as in that case
the container only has a F<tlpkg/tlobj> file, whose content is already
in the database.

=item C<postactions>

Only the C<script> actions are saved into C<postactions>. See
L<TeXLive::TLUtils/do_post_action> for their semantics.

=item C<executes>

All values are passed through.

For their semantics, see L<TeXLive::TLUtils/parse_AddFormat_line>,
L<TeXLive::TLUtils/parse_AddHyphen_line> for the default values of
missing keys; L<TeXLive::TLUtils/fmtutil_cnf_lines>,
L<TeXLive::TLUtils/language_dat_lines>,
L<TeXLive::TLUtils/updmap_cfg_lines> for how to generate the lines in
F<fmtutil.cnf>, F<language.{dat,def,dat.lua}>, F<updmap.cfg>.

=back

=cut

use strict;
use warnings;

use JSON::PP;

# === VALID PACKAGE NAMES AND VERSION NUMBERS
my $pkgName = qr/[-_.[:alnum:]]+/;
my $versionNumber = qr/[0-9][-_.[:alnum:]]*/;

# === PACKAGES TO OMIT
# The list is as explicit as feasible. New packages with a . in the
# name will cause an error.

# pre-built binaries: package.architecture
# binary dependency: package.ARCH
my $binaryPkg = qr/^.*\.(?:win32|universal-darwin|aarch64|amd64|armhf|i386|x86_64|ARCH).*$/x;

my $omittedPkg = qr/^(00texlive\.(image|installation|installer) # installer
                      |texlive\.infra                           # tlmgr and perl modules
                      # TODO |texlive-msg-translations          # translations for the above
                      |$binaryPkg)$/x;                          # architecture specific binaries

# === KEYS
# New keys will cause an error.

my $omittedKeys = qr/^(?:                                       # file entries
                       |(?:bin|doc|src)files                    # start of file entries
                       |catalogue                               # various metadata
                       |catalogue-(?:|alias|also
                                   |contact-(?:announce|bugs|home|development|repository|support)
                                   |ctan|license|topics)
                       |(?:long|short)desc
                       |(?:doc|src)?containersize)$/x;          # container sizes

# passed through as is
my $verbatimKeys = qr/^(?:category                              # category (Scheme, Collection...)
                        |(?:|doc|src)containerchecksum          # checksums
                       )$/x;

# === POSTACTIONS
# see L<TeXLive::TLUtils/do_postaction>
my $omittedPostactions = qr/file(?:assoc|type)|progid|shortcut/;

# === PARSER

# the database
my %db;

# to check that the database does not end mid-package
my $in_package = 0;

while (<>) {
  my ($pname) = /^name\s+($pkgName)$/ or die "Unexpected line '$_'.";
  my %p = ( 'name' => $pname );

  $in_package = 1;

  if ($pname =~ $omittedPkg) {
    while (<>) {
      if (/^$/) {
        $in_package = 0;
        last;
      }
    }
    next;
  }

  while (<>) {
    if (/^$/) {
      # end of package
      $in_package = 0;
      last;
    }

    my ($key, $value) = m/^([^\s]*)\s+(.+)$/ or die "Unexpected line '$_'.";

    # omitted keys
    next if ($key =~ $omittedKeys)
            || ($key eq 'category' and $value eq 'Package')
            || ($key eq 'postaction' and $value =~ /^$omittedPostactions\s/);

    if ($key eq 'relocated') {
      die "Unexpected relocated '$value'." unless $value eq '1';
      $p{'relocated'} = JSON::PP::true;
    } elsif ($key eq 'revision') {
      die "Revision '$value' is not a number." unless $value =~ /^[0-9]+$/;
      $p{'revision'} = 0 + $value;
    } elsif ($key eq 'depend') {
      push(@{ $p{'depends'} }, $value) unless $value =~ $omittedPkg;
    } elsif ($key eq 'runfiles') {
      $p{'runfiles'} = JSON::PP::true;
      # arch= and size= are irrelevant for Nix
      for my $kv (split(' ', ' ' . $value)) {
        die "Unexpected '$kv' in '$key'." unless $kv =~ /^(arch=|size=)/;
      }
    } elsif ($key eq 'catalogue-version') {
      # normalize to valid Nix version number
      $value =~ tr!~ !\-_!; $value =~ s/[:\(\),]//g;
      die "Invalid version number '$value' after normalization." unless $value =~ $versionNumber;
      $p{'cataloguedata'}{'version'} = $value;
    } elsif ($key =~ /^(execute|postaction)$/) {
      push(@{ $p{$1 . 's'} }, $value);
    } elsif ($key =~ $verbatimKeys) {
      $p{$key} = $value;
    } else {
      die "Unexpected '$key'.";
    }
  }

  # remove checksum if no runfiles
  if (!exists $p{'runfiles'}) {
    delete $p{'containerchecksum'};
  } else {
    delete $p{'runfiles'};
  }

  # remove relocated if no files
  if (!exists $p{'containerchecksum'} and !exists $p{'doccontainerchecksum'} and !exists $p{'srccontainerchecksum'}) {
    delete $p{'relocated'};
  }

  # parse database metadata
  if ($pname eq '00texlive.config') {
    for my $meta (@{ $p{'depends'} }) {
      my ($key, $value) = $meta =~ m,^([^/]+)/([^/]+)$,
        or die "Cannot parse '$meta' in 00texlive.config.";

      next if $key =~ /^(container_(format|split_(doc_|src_)files)|minrelease)/;

      if ($key eq 'release') {
        $db{'configs'}{$key} = $value;
      } elsif ($key eq 'revision') {
        die "Revision '$value' is not a number." unless $value =~ /^[0-9]+$/;
        $db{'configs'}{$key} = 0 + $value;
      } elsif ($key eq 'frozen') {
        die "Unexpected frozen = '$value'." unless $value =~ /^0|1$/;
        $db{'configs'}{'frozen'} = $value ? JSON::PP::true : JSON::PP::false;
      }
    }
  } else {
    push(@{ $db{'tlpkgs'} }, \%p);
  }
}

die "Last line is not empty." if $in_package;

# === OUTPUT
# split output on several lines (indent) and sort the keys (canonical)
my $json = JSON::PP->new->indent->indent_length(1)->canonical;

print $json->encode(\%db);
