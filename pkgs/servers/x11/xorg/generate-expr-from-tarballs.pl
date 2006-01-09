#! /usr/bin/perl -w

# Typical command to generate the list of tarballs:
# curl http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/ | perl -e 'while (<>) { if (/href="([^"]*.bz2)"/) { print "$1\n"; }; }' > list

use strict;

my $baseURL = "http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything";
    
my $tmpDir = "/tmp/xorg-unpack";

my $version = "X11R7"; # will be removed from package names
my $version2 = "X11R7.0"; # will be removed from package names


my %pkgURLs;
my %pkgHashes;
my %pkgNames;
my %pkgRequires;

my %pcMap;

my %extraAttrs;


$pcMap{"freetype2"} = "freetype";
$pcMap{"fontconfig"} = "fontconfig";
$pcMap{"libpng12"} = "libpng";
$pcMap{"libdrm"} = "libdrm";
$pcMap{"libdrm"} = "libdrm";
$pcMap{"libXaw"} = "libXaw";


$extraAttrs{"imake"} = " inherit xorgcffiles; x11BuildHook = ./imake.sh; ";


if (-e "cache") {
    open CACHE, "<cache";
    while (<CACHE>) {
        /^(\S+)\s+(\S+)$/ or die;
        $pkgHashes{$1} = $2;
    }
    close CACHE;
}


while (<>) {
    chomp;
    my $tarball = "$baseURL/$_";
    print "DOING TARBALL $tarball\n\n";

    $tarball =~ /\/((?:(?:[A-Za-z0-9]|(?:-[^0-9])|(?:-[0-9]*[a-z]))+))[^\/]*$/;
    die unless defined $1;
    my $pkg = $1;
    $pkg =~ s/-//g;
    print "$pkg\n";
    $pkg =~ s/$version//g if $version ne "";
    $pkgURLs{$pkg} = $tarball;

    my ($hash, $path) = `PRINT_PATH=1 QUIET=1 nix-prefetch-url '$tarball' $pkgHashes{$pkg}`;
    chomp $hash;
    chomp $path;
    if (!defined $pkgHashes{$pkg}) {
        open CACHE, ">>cache";
        print CACHE "$pkg $hash\n";
        close CACHE;
    }
    $pkgHashes{$pkg} = $hash;

    $tarball =~ /\/([^\/]*)\.tar\.bz2$/;
    my $pkgName = $1;
    $pkgName =~ s/-$version2//g if $version2 ne "";
    $pkgNames{$pkg} = $pkgName;

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
    open FOO, "cd '$tmpDir'/* && cat configure.ac |";
    while (<FOO>) {
        if (/XAW_CHECK_XPRINT_SUPPORT/) {
            if (!defined $requires{"libXaw"}) {
                push @requires, "libXaw";
                $requires{"libXaw"} = 1;
            }
        }
        if (/PKG_CHECK_MODULES\([^,]*,\s*\[?([^\),\]]*)/ ||
            /MODULES=\"(.*)\"/ ||
            /REQUIRED_LIBS=\"(.*)\"/ ||
            /REQUIRES=\"(.*)\"/)
        {
            print "MATCH: $_\n";
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

open OUT, ">default.nix";

print OUT "";
print OUT <<EOF;
# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, expat, libdrm, libpng, zlib, perl, mesa
}:

rec {

EOF


foreach my $pkg (sort (keys %pkgURLs)) {
    print "$pkg\n";

    my $inputs = "";
    foreach my $req (@{$pkgRequires{$pkg}}) {
        if (defined $pcMap{$req}) {
            $inputs .= "$pcMap{$req} ";
        } else {
            print "  NOT FOUND: $req\n";
        }
    }

    my $extraAttrs = $extraAttrs{"$pkg"};
    $extraAttrs = "" unless defined $extraAttrs;
    
    print OUT <<EOF
  $pkg = stdenv.mkDerivation {
    name = "$pkgNames{$pkg}";
    builder = ./builder.sh;
    src = fetchurl {
      url = $pkgURLs{$pkg};
      md5 = "$pkgHashes{$pkg}";
    };
    buildInputs = [pkgconfig $inputs];$extraAttrs
  };
    
EOF
}

print OUT "}\n";

close OUT;
