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
  xorg-server,
  xorg-sgml-doctools,
  xprop,
  xrandr,
  xrefresh,
  xset,
  xsetroot,
  xsm,
  xstdcmap,
  xtrans,
  xvfb,
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
    xvfb
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
  xorgserver = xorg-server;
  xorgsgmldoctools = xorg-sgml-doctools;

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXTrap = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXTrap";
      version = "1.0.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXTrap-1.0.1.tar.bz2";
        sha256 = "0bi5wxj6avim61yidh9fd3j4n8czxias5m8vss9vhxjnk1aksdwg";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libX11
        libXext
        libXt
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xtrap" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xclock = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      libXft,
      libxkbfile,
      libXmu,
      xorgproto,
      libXrender,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xclock";
      version = "1.1.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xclock-1.1.1.tar.xz";
        sha256 = "0b3l1zwz2b1cn46f8pd480b835j9anadf929vqpll107iyzylz6z";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        wrapWithXFileSearchPathHook
      ];
      buildInputs = [
        libX11
        libXaw
        libXft
        libxkbfile
        libXmu
        xorgproto
        libXrender
        libXt
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdm = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXau,
      libXaw,
      libXdmcp,
      libXext,
      libXft,
      libXinerama,
      libXmu,
      libXpm,
      xorgproto,
      libXrender,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xdm";
      version = "1.1.17";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xdm-1.1.17.tar.xz";
        sha256 = "0spbxjxxrnfxf8gqncd7bry3z7dvr74ba987cx9iq0qsj7qax54l";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        wrapWithXFileSearchPathHook
      ];
      buildInputs = [
        libX11
        libXau
        libXaw
        libXdmcp
        libXext
        libXft
        libXinerama
        libXmu
        libXpm
        xorgproto
        libXrender
        libXt
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdpyinfo = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libdmx,
      libX11,
      libxcb,
      libXcomposite,
      libXext,
      libXi,
      libXinerama,
      xorgproto,
      libXrender,
      libXtst,
      libXxf86dga,
      libXxf86misc,
      libXxf86vm,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xdpyinfo";
      version = "1.3.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xdpyinfo-1.3.4.tar.xz";
        sha256 = "0aw2yhx4ys22231yihkzhnw9jsyzksl4yyf3sx0689npvf0sbbd8";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libdmx
        libX11
        libxcb
        libXcomposite
        libXext
        libXi
        libXinerama
        xorgproto
        libXrender
        libXtst
        libXxf86dga
        libXxf86misc
        libXxf86vm
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputevdev = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libevdev,
      udev,
      mtdev,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-evdev";
      version = "2.11.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-evdev-2.11.0.tar.xz";
        sha256 = "058k0xdf4hkn8lz5gx4c08mgbzvv58haz7a32axndhscjgg2403k";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libevdev
        udev
        mtdev
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-evdev" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputjoystick = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-joystick";
      version = "1.6.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-joystick-1.6.4.tar.xz";
        sha256 = "1lnc6cvrg81chb2hj3jphgx7crr4ab8wn60mn8f9nsdwza2w8plh";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-joystick" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputkeyboard = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-keyboard";
      version = "2.1.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-keyboard-2.1.0.tar.xz";
        sha256 = "0mvwxrnkq0lzhjr894p420zxffdn34nc2scinmp7qd1hikr51kkp";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputlibinput = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libinput,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-libinput";
      version = "1.5.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-libinput-1.5.0.tar.xz";
        sha256 = "1rl06l0gdqmc4v08mya93m74ana76b7s3fzkmq8ylm3535gw6915";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libinput
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-libinput" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputmouse = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-mouse";
      version = "1.9.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-mouse-1.9.5.tar.xz";
        sha256 = "0s4rzp7aqpbqm4474hg4bz7i7vg3ir93ck2q12if4lj3nklqmpjg";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-mouse" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputsynaptics = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libevdev,
      libX11,
      libXi,
      xorgserver,
      libXtst,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-synaptics";
      version = "1.10.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-synaptics-1.10.0.tar.xz";
        sha256 = "1hmm3g6ab4bs4hm6kmv508fdc8kr2blzb1vsz1lhipcf0vdnmhp0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libevdev
        libX11
        libXi
        xorgserver
        libXtst
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-synaptics" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvmmouse = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      udev,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-vmmouse";
      version = "13.2.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-vmmouse-13.2.0.tar.xz";
        sha256 = "1f1rlgp1rpsan8k4ax3pzhl1hgmfn135r31m80pjxw5q19c7gw2n";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        udev
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvoid = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgserver,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-input-void";
      version = "1.4.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-input-void-1.4.2.tar.xz";
        sha256 = "11bqy2djgb82c1g8ylpfwp3wjw4x83afi8mqyn5fvqp03kidh4d2";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgserver
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoamdgpu = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libgbm,
      libGL,
      libdrm,
      udev,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-amdgpu";
      version = "23.0.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-amdgpu-23.0.0.tar.xz";
        sha256 = "0qf0kjh6pww5abxmqa4c9sfa2qq1hq4p8qcgqpfd1kpkcvmg012g";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libgbm
        libGL
        libdrm
        udev
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoapm = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-apm";
      version = "1.3.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-apm-1.3.0.tar.bz2";
        sha256 = "0znwqfc8abkiha98an8hxsngnz96z6cd976bc4bsvz1km6wqk0c0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoark = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-ark";
      version = "0.7.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-ark-0.7.6.tar.xz";
        sha256 = "0p88blr3zgy47jc4aqivc6ypj4zq9pad1cl70wwz9xig29w9xk2s";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoast = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-ast";
      version = "1.2.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-ast-1.2.0.tar.xz";
        sha256 = "14sx6dm0nmbf1fs8cazmak0aqjpjpv9wv7v09w86ff04m7f4gal6";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoati = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libgbm,
      libGL,
      libdrm,
      udev,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-ati";
      version = "22.0.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-ati-22.0.0.tar.xz";
        sha256 = "0vdznwx78alhbb05paw2xd65hcsila2kqflwwnbpq8pnsdbbpj68";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libgbm
        libGL
        libdrm
        udev
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videochips = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-chips";
      version = "1.5.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-chips-1.5.0.tar.xz";
        sha256 = "1cyljd3h2hjv42ldqimf4lllqhb8cma6p3n979kr8nn81rjdkhw4";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videocirrus = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-cirrus";
      version = "1.6.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-cirrus-1.6.0.tar.xz";
        sha256 = "00b468w01hqjczfqz42v2vqhb14db4wazcqi1w29lgfyhc0gmwqf";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videodummy = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-dummy";
      version = "0.4.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-dummy-0.4.1.tar.xz";
        sha256 = "1byzsdcnlnzvkcqrzaajzc3nzm7y7ydrk9bjr4x9lx8gznkj069m";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videofbdev = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-fbdev";
      version = "0.5.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-fbdev-0.5.1.tar.xz";
        sha256 = "11zk8whari4m99ad3w30xwcjkgya4xbcpmg8710q14phkbxw0aww";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videogeode = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-geode";
      version = "2.18.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-geode-2.18.1.tar.xz";
        sha256 = "0a8c6g3ndzf76rrrm3dwzmndcdy4y2qfai4324sdkmi8k9szicjr";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglide = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-glide";
      version = "1.2.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-glide-1.2.2.tar.bz2";
        sha256 = "1vaav6kx4n00q4fawgqnjmbdkppl0dir2dkrj4ad372mxrvl9c4y";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglint = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libpciaccess,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-glint";
      version = "1.2.9";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-glint-1.2.9.tar.bz2";
        sha256 = "1lkpspvrvrp9s539bhfdjfh4andaqyk63l6zjn8m3km95smk6a45";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libpciaccess
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi128 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-i128";
      version = "1.4.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-i128-1.4.1.tar.xz";
        sha256 = "0imwmkam09wpp3z3iaw9i4hysxicrrax7i3p0l2glgp3zw9var3h";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi740 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-i740";
      version = "1.4.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-i740-1.4.0.tar.bz2";
        sha256 = "0l3s1m95bdsg4gki943qipq8agswbb84dzcflpxa3vlckwhh3r26";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videointel = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      cairo,
      xorgproto,
      libdrm,
      libpng,
      udev,
      libpciaccess,
      libX11,
      xcbutil,
      libxcb,
      libXcursor,
      libXdamage,
      libXext,
      libXfixes,
      xorgserver,
      libXrandr,
      libXrender,
      libxshmfence,
      libXtst,
      libXvMC,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-intel";
      version = "2.99.917";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-intel-2.99.917.tar.bz2";
        sha256 = "1jb7jspmzidfixbc0gghyjmnmpqv85i7pi13l4h2hn2ml3p83dq0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        cairo
        xorgproto
        libdrm
        libpng
        udev
        libpciaccess
        libX11
        xcbutil
        libxcb
        libXcursor
        libXdamage
        libXext
        libXfixes
        xorgserver
        libXrandr
        libXrender
        libxshmfence
        libXtst
        libXvMC
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videomga = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-mga";
      version = "2.1.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-mga-2.1.0.tar.xz";
        sha256 = "0wxbcgg5i4yq22pbc50567877z8irxhqzgl3sk6vf5zs9szmvy3v";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoneomagic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-neomagic";
      version = "1.3.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-neomagic-1.3.1.tar.xz";
        sha256 = "153lzhq0vahg3875wi8hl9rf4sgizs41zmfg6hpfjw99qdzaq7xn";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonewport = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-newport";
      version = "0.2.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-newport-0.2.4.tar.bz2";
        sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonouveau = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      udev,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-nouveau";
      version = "3ee7cbca8f9144a3bb5be7f71ce70558f548d268";
      builder = ./builder.sh;
      src = fetchurl {
        url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau/-/archive/3ee7cbca8f9144a3bb5be7f71ce70558f548d268/xf86-video-nouveau-3ee7cbca8f9144a3bb5be7f71ce70558f548d268.tar.bz2";
        sha256 = "0rhs3z274jdzd82pcsl25xn8hmw6i4cxs2kwfnphpfhxbbkiq7wl";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        udev
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonv = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-nv";
      version = "2.1.23";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-nv-2.1.23.tar.xz";
        sha256 = "1jlap6xjn4pfwg9ab8fxm5mwf4dqfywp70bgc0071m7k66jbv3f6";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoomap = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-omap";
      version = "0.4.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-omap-0.4.5.tar.bz2";
        sha256 = "0nmbrx6913dc724y8wj2p6vqfbj5zdjfmsl037v627jj0whx9rwk";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoopenchrome = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      udev,
      libpciaccess,
      libX11,
      libXext,
      xorgserver,
      libXvMC,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-openchrome";
      version = "0.6.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-openchrome-0.6.0.tar.bz2";
        sha256 = "0x9gq3hw6k661k82ikd1y2kkk4dmgv310xr5q59dwn4k6z37aafs";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        udev
        libpciaccess
        libX11
        libXext
        xorgserver
        libXvMC
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoqxl = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      udev,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-qxl";
      version = "0.1.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-qxl-0.1.6.tar.xz";
        sha256 = "0pwncx60r1xxk8kpp9a46ga5h7k7hjqf14726v0gra27vdc9blra";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        udev
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videor128 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-r128";
      version = "6.13.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-r128-6.13.0.tar.xz";
        sha256 = "0igpfgls5nx4sz8a7yppr42qi37prqmxsy08zqbxbv81q9dfs2zj";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videos3virge = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-s3virge";
      version = "1.11.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-s3virge-1.11.1.tar.xz";
        sha256 = "1qzfcq3rlpfdb6qxz8hrp9py1q11vyzl4iqxip1vpgfnfn83vl6f";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosavage = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-savage";
      version = "2.4.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-savage-2.4.1.tar.xz";
        sha256 = "1bqhgldb6yahpgav7g7cyc4kl5pm3mgkq8w2qncj36311hb92hb7";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosiliconmotion = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-siliconmotion";
      version = "1.7.10";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.10.tar.xz";
        sha256 = "1h4g2mqxshaxii416ldw0aqy6cxnsbnzayfin51xm2526dw9q18n";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosis = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-sis";
      version = "0.12.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-sis-0.12.0.tar.gz";
        sha256 = "00j7i2r81496w27rf4nq9gc66n6nizp3fi7nnywrxs81j1j3pk4v";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosisusb = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-sisusb";
      version = "0.9.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-sisusb-0.9.7.tar.bz2";
        sha256 = "090lfs3hjz3cjd016v5dybmcsigj6ffvjdhdsqv13k90p4b08h7l";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosuncg6 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-suncg6";
      version = "1.1.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-suncg6-1.1.3.tar.xz";
        sha256 = "16c3g5m0f5y9nx2x6w9jdzbs9yr6xhq31j37dcffxbsskmfxq57w";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunffb = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-sunffb";
      version = "1.2.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-sunffb-1.2.3.tar.xz";
        sha256 = "0pf4ddh09ww7sxpzs5gr9pxh3gdwkg3f54067cp802nkw1n8vypi";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunleo = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-sunleo";
      version = "1.2.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-sunleo-1.2.3.tar.xz";
        sha256 = "1px670aiqyzddl1nz3xx1lmri39irajrqw6dskirs2a64jgp3dpc";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotdfx = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-tdfx";
      version = "1.5.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-tdfx-1.5.0.tar.bz2";
        sha256 = "0qc5wzwf1n65si9rc37bh224pzahh7gp67vfimbxs0b9yvhq0i9g";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotga = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-tga";
      version = "1.2.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2";
        sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotrident = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-trident";
      version = "1.4.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-trident-1.4.0.tar.xz";
        sha256 = "16qqn1brz50mwcy42zi1wsw9af56qadsaaiwm9hn1p6plyf22xkz";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videov4l = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-v4l";
      version = "0.3.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-v4l-0.3.0.tar.bz2";
        sha256 = "084x4p4avy72mgm2vnnvkicw3419i6pp3wxik8zqh7gmq4xv5z75";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovboxvideo = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-vboxvideo";
      version = "1.0.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-vboxvideo-1.0.1.tar.xz";
        sha256 = "12kzgf516mbdygpni0jzm3dv60vz6vf704f3hgc6pi9bgpy6bz4f";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovesa = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-vesa";
      version = "2.6.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-vesa-2.6.0.tar.xz";
        sha256 = "1ccvaigb1f1kz8nxxjmkfn598nabd92p16rx1g35kxm8n5qjf20h";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovmware = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libdrm,
      udev,
      libpciaccess,
      libX11,
      libXext,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-vmware";
      version = "13.4.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-vmware-13.4.0.tar.xz";
        sha256 = "06mq7spifsrpbwq9b8kn2cn61xq6mpkq6lvh4qi6xk2yxpjixlxf";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libdrm
        udev
        libpciaccess
        libX11
        libXext
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovoodoo = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libpciaccess,
      xorgserver,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-voodoo";
      version = "1.2.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-voodoo-1.2.6.tar.xz";
        sha256 = "00pn5826aazsdipf7ny03s1lypzid31fmswl8y2hrgf07bq76ab2";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libpciaccess
        xorgserver
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videowsfb = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgserver,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xf86-video-wsfb";
      version = "0.4.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/driver/xf86-video-wsfb-0.4.0.tar.bz2";
        sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgserver
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfd = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libxkbfile,
      fontconfig,
      libXaw,
      libXft,
      libXmu,
      xorgproto,
      libXrender,
      libXt,
      gettext,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xfd";
      version = "1.1.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xfd-1.1.4.tar.xz";
        sha256 = "1zbnj0z28dx2rm2h7pjwcz7z1jnl28gz0v9xn3hs2igxcvxhyiym";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        gettext
        wrapWithXFileSearchPathHook
      ];
      buildInputs = [
        libxkbfile
        fontconfig
        libXaw
        libXft
        libXmu
        xorgproto
        libXrender
        libXt
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfs = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXfont2,
      xorgproto,
      xtrans,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xfs";
      version = "1.2.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xfs-1.2.2.tar.xz";
        sha256 = "1k4f15nrgmqkvsn48hnl1j4giwxpmcpdrnq0bq7b6hg265ix82xp";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libXfont2
        xorgproto
        xtrans
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinit = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xinit";
      version = "1.4.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xinit-1.4.4.tar.xz";
        sha256 = "1ygymifhg500sx1ybk8x4d1zn4g4ywvlnyvqwcf9hzsc2rx7r920";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinput = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      libXi,
      libXinerama,
      libXrandr,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xinput";
      version = "1.6.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xinput-1.6.4.tar.xz";
        sha256 = "1j2pf28c54apr56v1fmvprp657n6x4sdrv8f24rx3138cl6x015d";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        libX11
        libXext
        libXi
        libXinerama
        libXrandr
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbcomp = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libxkbfile,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xkbcomp";
      version = "1.5.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xkbcomp-1.5.0.tar.xz";
        sha256 = "0q3092w42w9wyfr5zf3ymkmzlqr24z6kz6ypkinxnxh7c0k1zhra";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libxkbfile
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xkbcomp" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbevd = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libxkbfile,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xkbevd";
      version = "1.1.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xkbevd-1.1.6.tar.xz";
        sha256 = "0gh73dsf4ic683k9zn2nj9bpff6dmv3gzcb3zx186mpq9kw03d6r";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libxkbfile
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbprint = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libxkbfile,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xkbprint";
      version = "1.0.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xkbprint-1.0.7.tar.xz";
        sha256 = "1k2rm8lvc2klcdz2s3mymb9a2ahgwqwkgg67v3phv7ij6304jkqw";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libxkbfile
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xload = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      gettext,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xload";
      version = "1.2.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xload-1.2.0.tar.xz";
        sha256 = "104snn0rpnc91bmgj797cj6sgmkrp43n9mg20wbmr8p14kbfc3rc";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        gettext
        wrapWithXFileSearchPathHook
      ];
      buildInputs = [
        libX11
        libXaw
        libXmu
        xorgproto
        libXt
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xpr = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXmu,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xpr";
      version = "1.2.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xpr-1.2.0.tar.xz";
        sha256 = "1hyf6mc2l7lzkf21d5j4z6glg9y455hlsg8lv2lz028k6gw0554b";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXmu
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrdb = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXmu,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xrdb";
      version = "1.2.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xrdb-1.2.2.tar.xz";
        sha256 = "1x1ka0zbcw66a06jvsy92bvnsj9vxbvnq1hbn1az4f0v4fmzrx9i";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXmu
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xtrap = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXt,
      libXTrap,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xtrap";
      version = "1.0.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xtrap-1.0.3.tar.bz2";
        sha256 = "0sqm4j1zflk1s94iq4waa70hna1xcys88v9a70w0vdw66czhvj2j";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXt
        libXTrap
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwd = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libxkbfile,
      libX11,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xwd";
      version = "1.0.9";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xwd-1.0.9.tar.xz";
        sha256 = "0gxx3y9zlh13jgwkayxljm6i58ng8jc1xzqv2g8s7d3yjj21n4nw";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libxkbfile
        libX11
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

}
