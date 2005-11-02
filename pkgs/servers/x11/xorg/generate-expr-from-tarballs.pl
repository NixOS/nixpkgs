#! /usr/bin/perl -w

# Typical command to generate the list of tarballs:
# curl http://nix.cs.uu.nl/dist/tarballs/xorg/ | perl -e 'while (<>) { if (/href="([^"]*.bz2)"/) { print "$1\n"; }; }' > list

use strict;

my $baseURL = "http://nix.cs.uu.nl/dist/tarballs/xorg";
    
my $tmpDir = "/tmp/xorg-unpack";


my %pkgURLs;
my %pkgHashes;
my %pkgNames;
my %pkgRequires;

my %pcMap;


$pcMap{"freetype2"} = "freetype";
$pcMap{"fontconfig"} = "fontconfig";
$pcMap{"libpng12"} = "libpng";
$pcMap{"libdrm"} = "libdrm";


while (<>) {
    chomp;
    my $tarball = "$baseURL/$_";
    print "DOING TARBALL $tarball\n\n";

    $tarball =~ /\/((?:(?:[A-Za-z0-9]|(?:-[^0-9])|(?:-[0-9]*[a-z]))+))[^\/]*$/;
    die unless defined $1;
    my $pkg = $1;
    $pkg =~ s/-//g;
    $pkgURLs{$pkg} = $tarball;
#    print "$pkg\n";

    my ($hash, $path) = `PRINT_PATH=1 QUIET=1 nix-prefetch-url '$tarball'`;
    chomp $hash;
    chomp $path;
    $pkgHashes{$pkg} = $hash;

    $tarball =~ /\/([^\/]*)\.tar\.bz2$/;
    $pkgNames{$pkg} = $1;

    print "\nunpacking $path\n";
    system "rm -rf '$tmpDir'";
    mkdir $tmpDir, 0700;
    system "cd '$tmpDir' && tar xvfj '$path'";
    die "cannot unpack `$path'" if $? != 0;
    print "\n";

    my $provides = `cd '$tmpDir'/* && ls *.pc.in`;
    my @provides2 = split '\n', $provides;
    print "PROVIDES @provides2\n\n";
    foreach my $pc (@provides2) {
        $pc =~ s/.pc.in//;
        die "collission with $pcMap{$pc}" if defined $pcMap{$pc};
        $pcMap{$pc} = $pkg;
    }

    my @requires = ();
    my %requires = ();
    open FOO, "cd '$tmpDir'/* && grep PKG_CHECK_MODULES configure.ac |";
    while (<FOO>) {
        if (/PKG_CHECK_MODULES\([^,]*,\s*\[?([^\),\]]*)/) {
            foreach my $req (split / /, $1) {
                next if $req eq ">=";
                next if $req =~ /^\$/;
                next if $req =~ /^[0-9]/;
                $req =~ s/\[//g;
                $req =~ s/\]//g;
                if (!defined $requires{$req}) {
                    push @requires, $req;
                    $requires{$req} = 1;
                }
            }
        }
    }
    print "REQUIRES @requires\n";
    $pkgRequires{$pkg} = \@requires;

    print "done\n";
}


print "\nWRITE OUT\n";

open OUT, ">out";

print OUT "";
print OUT <<EOF;
# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, expat, libdrm, libpng
}:

rec {

EOF


foreach my $pkg (keys %pkgURLs) {
    print "$pkg\n";

    my $inputs = "";
    foreach my $req (@{$pkgRequires{$pkg}}) {
        if (defined $pcMap{$req}) {
            $inputs .= "$pcMap{$req} ";
        } else {
            print "  NOT FOUND: $req\n";
        }
    }

    print OUT <<EOF
  $pkg = stdenv.mkDerivation {
    name = "$pkgNames{$pkg}";
    src = fetchurl {
      url = $pkgURLs{$pkg};
      md5 = "$pkgHashes{$pkg}";
    };
    buildInputs = [pkgconfig $inputs];
  };
    
EOF
}

print OUT "}\n";

close OUT;
