#!/usr/bin/env nix-shell
#!nix-shell --pure --keep NIX_PATH -i perl -p cacert nix perl

# Usage: manually update tarballs.list then run: ./generate-expr-from-tarballs.pl tarballs.list

use strict;
use warnings;

use File::Basename;
use File::Spec::Functions;
use File::Temp;


my %pkgURLs;
my %pkgHashes;
my %pkgNames;
my %pkgVersions;
my %pkgRequires;
my %pkgNativeRequires;

my %pcProvides;
my %pcMap;

my %extraAttrs;


my @missingPCs = ("fontconfig", "libdrm", "libXaw", "zlib", "perl", "python3", "mkfontscale", "bdftopcf", "libxslt", "openssl", "gperf", "m4", "libinput", "libevdev", "mtdev", "xorgproto", "cairo", "gettext", "meson", "ninja", "wrapWithXFileSearchPathHook" );
$pcMap{$_} = $_ foreach @missingPCs;
$pcMap{"freetype2"} = "freetype";
$pcMap{"libpng12"} = "libpng";
$pcMap{"libpng"} = "libpng";
$pcMap{"dbus-1"} = "dbus";
$pcMap{"uuid"} = "libuuid";
$pcMap{"libudev"} = "udev";
$pcMap{"gl"} = "libGL";
$pcMap{"GL"} = "libGL";
$pcMap{"gbm"} = "libgbm";
$pcMap{"hwdata"} = "hwdata";
$pcMap{"dmx"} = "libdmx";
$pcMap{"fontenc"} = "libfontenc";
$pcMap{"fontutil"} = "fontutil";
$pcMap{"ice"} = "libICE";
$pcMap{"libfs"} = "libFS";
$pcMap{"pciaccess"} = "libpciaccess";
$pcMap{"pthread-stubs"} = "libpthreadstubs";
$pcMap{"sm"} = "libSM";
$pcMap{"x11"} = "libX11";
$pcMap{"x11-xcb"} = "libX11";
$pcMap{"xau"} = "libXau";
$pcMap{"xaw6"} = "libXaw";
$pcMap{"xaw7"} = "libXaw";
$pcMap{"xbitmaps"} = "xbitmaps";
$pcMap{"xcb-atom"} = "xcbutil";
$pcMap{"xcb-aux"} = "xcbutil";
$pcMap{"xcb-errors"} = "xcbutilerrors";
$pcMap{"xcb-event"} = "xcbutil";
$pcMap{"xcb-ewmh"} = "xcbutilwm";
$pcMap{"xcb-icccm"} = "xcbutilwm";
$pcMap{"xcb-image"} = "xcbutilimage";
$pcMap{"xcb-keysyms"} = "xcbutilkeysyms";
$pcMap{"xcb-cursor"} = "xcbutilcursor";
$pcMap{"xcb-proto"} = "xcbproto";
$pcMap{"xcb-renderutil"} = "xcbutilrenderutil";
$pcMap{"xcb-util"} = "xcbutil";
$pcMap{"xcomposite"} = "libXcomposite";
$pcMap{"xcursor"} = "libXcursor";
$pcMap{"xdamage"} = "libXdamage";
$pcMap{"xdmcp"} = "libXdmcp";
$pcMap{"xext"} = "libXext";
$pcMap{"xfixes"} = "libXfixes";
$pcMap{"xfont"} = "libXfont";
$pcMap{"xfont2"} = "libXfont2";
$pcMap{"xft"} = "libXft";
$pcMap{"xi"} = "libXi";
$pcMap{"xinerama"} = "libXinerama";
$pcMap{"xkbfile"} = "libxkbfile";
$pcMap{"xmu"} = "libXmu";
$pcMap{"xmuu"} = "libXmu";
$pcMap{"xp"} = "libXp";
$pcMap{"xpm"} = "libXpm";
$pcMap{"xpresent"} = "libXpresent";
$pcMap{"xrandr"} = "libXrandr";
$pcMap{"xrender"} = "libXrender";
$pcMap{"xres"} = "libXres";
$pcMap{"xscrnsaver"} = "libXScrnSaver";
$pcMap{"xshmfence"} = "libxshmfence";
$pcMap{"xt"} = "libXt";
$pcMap{"xtrans"} = "xtrans";
$pcMap{"xtst"} = "libXtst";
$pcMap{"xv"} = "libXv";
$pcMap{"xvmc"} = "libXvMC";
$pcMap{"xvmc-wrapper"} = "libXvMC";
$pcMap{"xxf86dga"} = "libXxf86dga";
$pcMap{"xxf86misc"} = "libXxf86misc";
$pcMap{"xxf86vm"} = "libXxf86vm";
$pcMap{"\$PIXMAN"} = "pixman";
$pcMap{"\$RENDERPROTO"} = "xorgproto";
$pcMap{"\$DRI3PROTO"} = "xorgproto";
$pcMap{"\$DRI2PROTO"} = "xorgproto";
$pcMap{"\${XKBMODULE}"} = "libxkbfile";
foreach my $mod ("xcb", "xcb-composite", "xcb-damage", "xcb-dpms", "xcb-dri2", "xcb-dri3",
    "xcb-glx", "xcb-present", "xcb-randr", "xcb-record", "xcb-render", "xcb-res", "xcb-screensaver",
    "xcb-shape", "xcb-shm", "xcb-sync", "xcb-xf86dri", "xcb-xfixes", "xcb-xinerama", "xcb-xinput",
    "xcb-xkb", "xcb-xtest", "xcb-xv", "xcb-xvmc") {
    $pcMap{$mod} = "libxcb";
}
foreach my $mod ("applewmproto", "bigreqsproto", "compositeproto", "damageproto", "dmxproto",
    "dpmsproto", "dri2proto", "dri3proto", "evieproto", "fixesproto", "fontcacheproto",
    "fontsproto", "glproto", "inputproto", "kbproto", "lg3dproto", "presentproto",
    "printproto", "randrproto", "recordproto", "renderproto", "resourceproto", "scrnsaverproto",
    "trapproto", "videoproto", "windowswmproto", "xcalibrateproto", "xcmiscproto", "xextproto",
    "xf86bigfontproto", "xf86dgaproto", "xf86driproto", "xf86miscproto", "xf86rushproto",
    "xf86vidmodeproto", "xineramaproto", "xproto", "xproxymngproto", "xwaylandproto") {
    $pcMap{$mod} = "xorgproto";
}


my $downloadCache = "./download-cache";
mkdir $downloadCache, 0755;


while (<>) {
    chomp;
    my $tarball = "$_";
    print "\nDOING TARBALL $tarball\n";

    my $pkg;
    if ($tarball =~ s/:([a-zA-Z0-9_]+)$//) {
      $pkg = $1;
    } else {
      $tarball =~ /\/((?:(?:[A-Za-z0-9]|(?:-[^0-9])|(?:-[0-9]*[a-z]))+))[^\/]*$/;
      die unless defined $1;
      $pkg = $1;
      $pkg =~ s/(-|[a-f0-9]{40})//g; # Remove hyphen-minus and SHA-1
      #next unless $pkg eq "xcbutil";
    }

    $tarball =~ /\/([^\/]*)\.(tar\.(bz2|gz|xz)|tgz)$/;
    my $pkgName = $1;

    print "  $pkg $pkgName\n";

    if (defined $pkgNames{$pkg}) {
        print "  SKIPPING\n";
        next;
    }

    # Split by first occurrence of hyphen followed by only numbers, ends line, another hyphen follows, or SHA-1
    my ($name, $version) = split(/-(?=[.0-9]+(?:$|-)|[a-f0-9]{40})/, $pkgName, 2);

    $pkgURLs{$pkg} = $tarball;
    $pkgNames{$pkg} = $name;
    $pkgVersions{$pkg} = $version;

    my $cachePath = catdir($downloadCache, basename($tarball));
    my $hash;
    my $path;
    if (-e $cachePath) {
        $path = readlink($cachePath);
        $hash = `nix-hash --type sha256 --base32 --flat $cachePath`;
    }
    else {
        ($hash, $path) = `PRINT_PATH=1 QUIET=1 nix-prefetch-url '$tarball'`;
        `nix-store --realise --add-root $cachePath --indirect $path`;
    }
    chomp $hash;
    chomp $path;
    $pkgHashes{$pkg} = $hash;

    print "\nunpacking $path\n";
    my $tmpDir = File::Temp->newdir();
    system "cd '$tmpDir' && tar xf '$path'";
    die "cannot unpack `$path'" if $? != 0;
    print "\n";

    my $pkgDir = `echo $tmpDir/*`;
    chomp $pkgDir;

    my $provides = `find $pkgDir -name "*.pc.in"`;
    my @provides2 = split '\n', $provides;
    my @requires = ();
    my @nativeRequires = ();

    foreach my $pcFile (@provides2) {
        my $pc = $pcFile;
        $pc =~ s/.*\///;
        $pc =~ s/.pc.in//;
        push @{$pcProvides{$pkg}}, $pc;
        print "PROVIDES $pc\n";
        die "collision with $pcMap{$pc}" if defined $pcMap{$pc};
        $pcMap{$pc} = $pkg;

        open FOO, "<$pcFile" or die;
        while (<FOO>) {
            if (/Requires:(.*)/) {
                my @reqs = split ' ', $1;
                foreach my $req (@reqs) {
                    next unless $req =~ /^[a-z]+$/;
                    print "REQUIRE (from $pc): $req\n";
                    push @requires, $req;
                }
            }
        }
        close FOO;

    }

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
        push @nativeRequires, "bdftopcf";
    }

    if ($file =~ /AC_PATH_PROG\(MKFONTSCALE/ || $file =~ /XORG_FONT_REQUIRED_PROG\(MKFONTSCALE/) {
        push @nativeRequires, "mkfontscale";
    }

    if ($file =~ /AC_PATH_PROG\(MKFONTDIR/) {
        push @nativeRequires, "mkfontscale";
    }

    if ($file =~ /AM_PATH_PYTHON/) {
        push @nativeRequires, "python3";
    }

    if ($file =~ /AC_PATH_PROG\(FCCACHE/) {
        # Don't run fc-cache.
        die if defined $extraAttrs{$pkg};
        push @{$extraAttrs{$pkg}}, "preInstall = \"installFlags=(FCCACHE=true)\";";
    }

    my $isFont;

    if ($file =~ /XORG_FONT_BDF_UTILS/) {
        push @nativeRequires, "bdftopcf", "mkfontscale";
        $isFont = 1;
    }

    if ($file =~ /XORG_FONT_SCALED_UTILS/) {
        push @nativeRequires, "mkfontscale";
        $isFont = 1;
    }

    if ($file =~ /XORG_FONT_UCS2ANY/) {
        push @nativeRequires, "fontutil", "mkfontscale";
        $isFont = 1;
    }

    if ($isFont) {
        push @requires, "fontutil";
        push @{$extraAttrs{$pkg}}, "configureFlags = [ \"--with-fontrootdir=\$(out)/lib/X11/fonts\" ];";
        push @{$extraAttrs{$pkg}}, "postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`\$PKG_CONFIG' '';";
    }

    if (@@ = glob("$tmpDir/*/app-defaults/")) {
        push @nativeRequires, "wrapWithXFileSearchPathHook";
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
    process \@requires, $1 while $file =~ /AC_SEARCH_LIBS\([^,]*,([^\)\,]*)/g;
    process \@requires, $1 while $file =~ /MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRED_LIBS=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRED_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /REQUIRES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /X11_REQUIRES=\'(.*)\'/g;
    process \@requires, $1 while $file =~ /XDMCP_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /XORG_MODULES=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /NEEDED=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /ivo_requires=\"(.*)\"/g;
    process \@requires, $1 while $file =~ /XORG_DRIVER_CHECK_EXT\([^,]*,([^\)]*)\)/g;

    push @nativeRequires, "gettext" if $file =~ /USE_GETTEXT/;
    push @requires, "libxslt" if $pkg =~ /libxcb/;
    push @nativeRequires, "meson", "ninja" if $pkg =~ /libxcvt/;
    push @nativeRequires, "m4" if $pkg =~ /xcbutil/;
    push @requires, "gperf", "xorgproto" if $pkg =~ /xcbutil/;

    print "REQUIRES $pkg => @requires\n";
    print "NATIVE_REQUIRES $pkg => @nativeRequires\n";
    $pkgRequires{$pkg} = \@requires;
    $pkgNativeRequires{$pkg} = \@nativeRequires;

    print "done\n";
}


print "\nWRITE OUT\n";

open OUT, ">default.nix";

print OUT "";
print OUT <<EOF;
# THIS IS A GENERATED FILE.  DO NOT EDIT!
{
  lib,
  appres,
  bdftopcf,
  bitmap,
  editres,
  font-adobe-100dpi,
  font-adobe-75dpi,
  font-adobe-utopia-100dpi,
  font-adobe-utopia-75dpi,
  font-adobe-utopia-type1,
  font-alias,
  font-arabic-misc,
  font-bh-100dpi,
  font-bh-75dpi,
  font-bh-lucidatypewriter-100dpi,
  font-bh-lucidatypewriter-75dpi,
  font-bh-ttf,
  font-bh-type1,
  font-bitstream-100dpi,
  font-bitstream-75dpi,
  font-bitstream-type1,
  font-cronyx-cyrillic,
  font-cursor-misc,
  font-daewoo-misc,
  font-dec-misc,
  font-encodings,
  font-ibm-type1,
  font-isas-misc,
  font-jis-misc,
  font-micro-misc,
  font-misc-cyrillic,
  font-misc-ethiopic,
  font-misc-meltho,
  font-misc-misc,
  font-mutt-misc,
  font-schumacher-misc,
  font-screen-cyrillic,
  font-sony-misc,
  font-sun-misc,
  fonttosfnt,
  font-util,
  font-winitzki-cyrillic,
  font-xfree86-type1,
  gccmakedep,
  iceauth,
  ico,
  imake,
  libapplewm,
  libdmx,
  libfontenc,
  libfs,
  libice,
  libpciaccess,
  libpthread-stubs,
  libsm,
  libwindowswm,
  libx11,
  libxau,
  libxaw,
  libxcb,
  libxcb-cursor,
  libxcb-errors,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxcomposite,
  libxcursor,
  libxcvt,
  libxdamage,
  libxdmcp,
  libxext,
  libxfixes,
  libxfont_1,
  libxfont_2,
  libxft,
  libxi,
  libxinerama,
  libxkbfile,
  libxmu,
  libxp,
  libxpm,
  libxpresent,
  libxrandr,
  libxrender,
  libxres,
  libxscrnsaver,
  libxshmfence,
  libxt,
  libxtst,
  libxv,
  libxvmc,
  libxxf86dga,
  libxxf86misc,
  libxxf86vm,
  listres,
  lndir,
  luit,
  makedepend,
  mkfontscale,
  oclock,
  pixman,
  sessreg,
  setxkbmap,
  smproxy,
  tab-window-manager,
  transset,
  util-macros,
  viewres,
  x11perf,
  xauth,
  xbacklight,
  xbitmaps,
  xcalc,
  xcb-proto,
  xcmsdb,
  xcompmgr,
  xconsole,
  xcursorgen,
  xcursor-themes,
  xdriinfo,
  xev,
  xeyes,
  xfontsel,
  xfsinfo,
  xgamma,
  xgc,
  xhost,
  xkbutils,
  xkeyboard-config,
  xkill,
  xlsatoms,
  xlsclients,
  xlsfonts,
  xmag,
  xmessage,
  xmodmap,
  xmore,
  xorg-cf-files,
  xorg-docs,
  xorgproto,
  xorg-sgml-doctools,
  xprop,
  xrandr,
  xrefresh,
  xset,
  xsetroot,
  xsm,
  xstdcmap,
  xtrans,
  xvinfo,
  xwininfo,
  xwud,
}:

self: with self; {

  inherit
    appres
    bdftopcf
    bitmap
    editres
    fonttosfnt
    gccmakedep
    iceauth
    ico
    imake
    libdmx
    libfontenc
    libpciaccess
    libxcb
    libxcvt
    libxkbfile
    libxshmfence
    listres
    lndir
    luit
    makedepend
    mkfontscale
    oclock
    pixman
    sessreg
    setxkbmap
    smproxy
    transset
    viewres
    x11perf
    xauth
    xbacklight
    xbitmaps
    xcalc
    xcmsdb
    xcompmgr
    xconsole
    xcursorgen
    xdriinfo
    xev
    xeyes
    xfontsel
    xfsinfo
    xgamma
    xgc
    xhost
    xkbutils
    xkill
    xlsatoms
    xlsclients
    xlsfonts
    xmag
    xmessage
    xmodmap
    xmore
    xorgproto
    xprop
    xrandr
    xrefresh
    xset
    xsetroot
    xsm
    xstdcmap
    xtrans
    xvinfo
    xwininfo
    xwud
    ;
  encodings = font-encodings;
  fontadobe100dpi = font-adobe-100dpi;
  fontadobe75dpi = font-adobe-75dpi;
  fontadobeutopia100dpi = font-adobe-utopia-100dpi;
  fontadobeutopia75dpi = font-adobe-utopia-75dpi;
  fontadobeutopiatype1 = font-adobe-utopia-type1;
  fontalias = font-alias;
  fontarabicmisc = font-arabic-misc;
  fontbh100dpi = font-bh-100dpi;
  fontbh75dpi = font-bh-75dpi;
  fontbhlucidatypewriter100dpi = font-bh-lucidatypewriter-100dpi;
  fontbhlucidatypewriter75dpi = font-bh-lucidatypewriter-75dpi;
  fontbhttf = font-bh-ttf;
  fontbhtype1 = font-bh-type1;
  fontbitstream100dpi = font-bitstream-100dpi;
  fontbitstream75dpi = font-bitstream-75dpi;
  fontbitstreamtype1 = font-bitstream-type1;
  fontcronyxcyrillic = font-cronyx-cyrillic;
  fontcursormisc = font-cursor-misc;
  fontdaewoomisc = font-daewoo-misc;
  fontdecmisc = font-dec-misc;
  fontibmtype1 = font-ibm-type1;
  fontisasmisc = font-isas-misc;
  fontjismisc = font-jis-misc;
  fontmicromisc = font-micro-misc;
  fontmisccyrillic = font-misc-cyrillic;
  fontmiscethiopic = font-misc-ethiopic;
  fontmiscmeltho = font-misc-meltho;
  fontmiscmisc = font-misc-misc;
  fontmuttmisc = font-mutt-misc;
  fontschumachermisc = font-schumacher-misc;
  fontscreencyrillic = font-screen-cyrillic;
  fontsonymisc = font-sony-misc;
  fontsunmisc = font-sun-misc;
  fontutil = font-util;
  fontwinitzkicyrillic = font-winitzki-cyrillic;
  fontxfree86type1 = font-xfree86-type1;
  libAppleWM = libapplewm;
  libFS = libfs;
  libICE = libice;
  libpthreadstubs = libpthread-stubs;
  libSM = libsm;
  libWindowsWM = libwindowswm;
  libX11 = libx11;
  libXau = libxau;
  libXaw = libxaw;
  libXcomposite = libxcomposite;
  libXcursor = libxcursor;
  libXdamage = libxdamage;
  libXdmcp = libxdmcp;
  libXext = libxext;
  libXfixes = libxfixes;
  libXfont2 = libxfont_2;
  libXfont = libxfont_1;
  libXft = libxft;
  libXi = libxi;
  libXinerama = libxinerama;
  libXmu = libxmu;
  libXp = libxp;
  libXpm = libxpm;
  libXpresent = libxpresent;
  libXrandr = libxrandr;
  libXrender = libxrender;
  libXres = libxres;
  libXScrnSaver = libxscrnsaver;
  libXt = libxt;
  libXtst = libxtst;
  libXv = libxv;
  libXvMC = libxvmc;
  libXxf86dga = libxxf86dga;
  libXxf86misc = libxxf86misc;
  libXxf86vm = libxxf86vm;
  twm = tab-window-manager;
  utilmacros = util-macros;
  xcbproto = xcb-proto;
  xcbutilcursor = libxcb-cursor;
  xcbutilerrors = libxcb-errors;
  xcbutilimage = libxcb-image;
  xcbutilkeysyms = libxcb-keysyms;
  xcbutil = libxcb-util;
  xcbutilrenderutil = libxcb-render-util;
  xcbutilwm = libxcb-wm;
  xkeyboardconfig = xkeyboard-config;
  xcursorthemes = xcursor-themes;
  xorgcffiles = xorg-cf-files;
  xorgdocs = xorg-docs;
  xorgsgmldoctools = xorg-sgml-doctools;

EOF


foreach my $pkg (sort (keys %pkgURLs)) {
    print "$pkg\n";

    my %nativeRequires = ();
    my @nativeBuildInputs;
    foreach my $req (sort @{$pkgNativeRequires{$pkg}}) {
        if (defined $pcMap{$req}) {
            # Some packages have .pc that depends on itself.
            next if $pcMap{$req} eq $pkg;
            if (!defined $nativeRequires{$pcMap{$req}}) {
                push @nativeBuildInputs, $pcMap{$req};
                $nativeRequires{$pcMap{$req}} = 1;
            }
        } else {
            print "  NOT FOUND: $req\n";
        }
    }
    my %requires = ();
    my @buildInputs;
    foreach my $req (sort @{$pkgRequires{$pkg}}) {
        if (defined $pcMap{$req}) {
            # Some packages have .pc that depends on itself.
            next if $pcMap{$req} eq $pkg;
            if (!defined $requires{$pcMap{$req}}) {
                push @buildInputs, $pcMap{$req};
                $requires{$pcMap{$req}} = 1;
            }
        } else {
            print "  NOT FOUND: $req\n";
        }
    }

    my $nativeBuildInputsStr = join "", map { $_ . " " } @nativeBuildInputs;
    my $buildInputsStr = join "", map { $_ . " " } @buildInputs;

    sub uniq {
        my %seen;
        my @res = ();
        foreach my $s (@_) {
            if (!defined $seen{$s}) {
                $seen{$s} = 1;
                push @res, $s;
            }
        }
        return @res;
    }

    my @arguments = @buildInputs;
    push @arguments, @nativeBuildInputs;
    unshift @arguments, "stdenv", "pkg-config", "fetchurl";
    my $argumentsStr = join ", ", uniq @arguments;

    my $extraAttrsStr = "";
    if (defined $extraAttrs{$pkg}) {
      $extraAttrsStr = join "", map { "\n    " . $_ } @{$extraAttrs{$pkg}};
    }

    my $pcProvidesStr = "";
    if (defined $pcProvides{$pkg}) {
      $pcProvidesStr = join "", map { "\"" . $_ . "\" " } (sort @{$pcProvides{$pkg}});
    }

    print OUT <<EOF
  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  $pkg = callPackage ({ $argumentsStr, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "$pkgNames{$pkg}";
    version = "$pkgVersions{$pkg}";
    builder = ./builder.sh;
    src = fetchurl {
      url = "$pkgURLs{$pkg}";
      sha256 = "$pkgHashes{$pkg}";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config $nativeBuildInputsStr];
    buildInputs = [ $buildInputsStr];$extraAttrsStr
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ $pcProvidesStr];
      platforms = lib.platforms.unix;
    };
  })) {};

EOF
}

print OUT "}\n";

close OUT;
