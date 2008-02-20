#! /usr/bin/perl -w

# Typical command to generate the list of tarballs:

# export i="http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/"; curl $i | perl -e 'while (<>) { if (/href="([^"]*.bz2)"/) { print "$ENV{'i'}$1\n"; }; }' > tarballs
# manually added xcb tarballs from http://xcb.freedesktop.org/dist/
# then run: perl ./generate-expr-from-tarballs.pl < tarballs


use strict;

my $tmpDir = "/tmp/xorg-unpack";


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
$pcMap{"libXaw"} = "libXaw";
$pcMap{"zlib"} = "zlib";
$pcMap{"perl"} = "perl";
$pcMap{"mesa"} = "mesa";
$pcMap{"mesaHeaders"} = "mesaHeaders";
$pcMap{"mkfontscale"} = "mkfontscale";
$pcMap{"mkfontdir"} = "mkfontdir";
$pcMap{"bdftopcf"} = "bdftopcf";
$pcMap{"libxslt"} = "libxslt";
$pcMap{"dbus-1"} = "dbus";
$pcMap{"hal"} = "hal";

$pcMap{"\$PIXMAN"} = "pixman";
$pcMap{"\$RENDERPROTO"} = "renderproto";


$extraAttrs{"xorgserver"} = " mesaSrc = mesa.src; x11BuildHook = ./xorgserver.sh; patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch ./xorgserver-xkb-leds.patch ]; ";

$extraAttrs{"imake"} = " inherit xorgcffiles; x11BuildHook = ./imake.sh; patches = [./imake.patch]; ";

$extraAttrs{"setxkbmap"} = " postInstall = \"ensureDir \$out/share; ln -sfn \${xkeyboard_config}/etc/X11 \$out/share/X11\";";

$extraAttrs{"fontmiscmisc"} = " postInstall = \"ln -s \${fontalias}/lib/X11/fonts/misc/fonts.alias \$out/lib/X11/fonts/misc/fonts.alias\"; ";

$extraAttrs{"mkfontdir"} = " preBuild = \"substituteInPlace mkfontdir.cpp --replace BINDIR \${mkfontscale}/bin\"; ";

$extraAttrs{"xf86inputevdev"} = "
    preBuild = \"
    sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c
    \";";

$extraAttrs{"libXpm"} = "
    patchPhase = \"sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in\";";

my $downloadCache = "./download-cache";
$ENV{'NIX_DOWNLOAD_CACHE'} = $downloadCache;
mkdir $downloadCache, 0755;


while (<>) {
    chomp;
    my $tarball = "$_";
    print "\nDOING TARBALL $tarball\n";

    $tarball =~ /\/((?:(?:[A-Za-z0-9]|(?:-[^0-9])|(?:-[0-9]*[a-z]))+))[^\/]*$/;
    die unless defined $1;
    my $pkg = $1;
    $pkg =~ s/-//g;
    #next unless $pkg eq "xorgserver";
    #print "$pkg\n";

    $tarball =~ /\/([^\/]*)\.tar\.bz2$/;
    my $pkgName = $1;

    print "  $pkg $pkgName\n";

    if (defined $pkgNames{$pkg}) {
	print "  SKIPPING\n";
	next;
    }

    $pkgURLs{$pkg} = $tarball;
    $pkgNames{$pkg} = $pkgName;

    my ($hash, $path) = `PRINT_PATH=1 QUIET=1 nix-prefetch-url '$tarball'`;
    chomp $hash;
    chomp $path;
    $pkgHashes{$pkg} = $hash;

    print "\nunpacking $path\n";
    system "rm -rf '$tmpDir'";
    mkdir $tmpDir, 0700;
    system "cd '$tmpDir' && tar xfj '$path'";
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
    my $file;
    {
        local $/;
        open FOO, "cd '$tmpDir'/* && grep -v '^ *#' configure.ac |";
        $file = <FOO>;
        close FOO;
    }

    if ($file =~ /XAW_CHECK_XPRINT_SUPPORT/) {
        push @requires, "libXaw";
    }

    if ($file =~ /zlib is required/ || $file =~ /AC_CHECK_LIB\(z\,/) {
        push @requires, "zlib";
    }
    
    if ($file =~ /Perl is required/) {
        push @requires, "perl";
    }

    if ($file =~ /AC_PATH_PROG\(BDFTOPCF/) {
        push @requires, "bdftopcf";
    }

    if ($file =~ /AC_PATH_PROG\(MKFONTSCALE/) {
        push @requires, "mkfontscale";
    }

    if ($file =~ /AC_PATH_PROG\(MKFONTDIR/) {
        push @requires, "mkfontdir";
    }

    if ($file =~ /AC_PATH_PROG\(FCCACHE/) {
	# Don't run fc-cache.
	die if defined $extraAttrs{$pkg};
	$extraAttrs{$pkg} = " preInstall = \"installFlags=(FCCACHE=true)\"; ";
    }

    sub process {
        my $requires = shift;
	my $s = shift;
	$s =~ s/\[/\ /g;
	$s =~ s/\]/\ /g;
	$s =~ s/\,/\ /g;
        foreach my $req (split / /, $s) {
            next if $req eq ">=";
            #next if $req =~ /^\$/;
            next if $req =~ /^[0-9]/;
            next if $req =~ /^\s*$/;
            next if $req eq '$REQUIRED_MODULES';
            next if $req eq '$REQUIRED_LIBS';
            next if $req eq '$XDMCP_MODULES';
            next if $req eq '$XORG_MODULES';
            print "REQUIRE: $req\n";
            push @{$requires}, $req;
        }
    }

    #process \@requires, $1 while $file =~ /PKG_CHECK_MODULES\([^,]*,\s*[\[]?([^\)\[]*)/g;
    process \@requires, $1 while $file =~ /PKG_CHECK_MODULES\([^,]*,([^\)\,]*)/g;
    process \@requires, $1 while $file =~ /MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRED_LIBS=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRED_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /XDMCP_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /XORG_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /NEEDED=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /XORG_DRIVER_CHECK_EXT\([^,]*,([^\)]*)\)/g;

    push @requires, "glproto", "mesaHeaders" if $pkg =~ /xf86videoi810/;
    push @requires, "glproto", "mesaHeaders" if $pkg =~ /xf86videosis/;
    push @requires, "glproto", "mesaHeaders" if $pkg =~ /xf86videointel/;
    push @requires, "zlib" if $pkg =~ /xorgserver/;
    push @requires, "xf86bigfontproto" if $pkg =~ /xorgserver/;
    push @requires, "libxslt" if $pkg =~ /libxcb/;
    
    print "REQUIRES @requires => $pkg\n";
    $pkgRequires{$pkg} = \@requires;

    print "done\n";
}


print "\nWRITE OUT\n";

open OUT, ">default2.nix";

print OUT "";
print OUT <<EOF;
# This is a generated file.  Do not edit!
args: with args;

rec {

EOF


foreach my $pkg (sort (keys %pkgURLs)) {
    print "$pkg\n";

    my %requires = ();
    my $inputs = "";
    foreach my $req (sort @{$pkgRequires{$pkg}}) {
        if (defined $pcMap{$req}) {
            if (!defined $requires{$pcMap{$req}}) {
                $inputs .= "$pcMap{$req} ";
                $requires{$pcMap{$req}} = 1;
            }
        } else {
            print "  NOT FOUND: $req\n";
        }
    }

    my $extraAttrs = $extraAttrs{"$pkg"};
    $extraAttrs = "" unless defined $extraAttrs;
    
    print OUT <<EOF
  $pkg = (stdenv.mkDerivation {
    name = "$pkgNames{$pkg}";
    builder = ./builder.sh;
    src = fetchurl {
      url = $pkgURLs{$pkg};
      sha256 = "$pkgHashes{$pkg}";
    };
    buildInputs = [pkgconfig $inputs];$extraAttrs
  }) // {inherit $inputs;};
    
EOF
}

print OUT "}\n";

close OUT;
