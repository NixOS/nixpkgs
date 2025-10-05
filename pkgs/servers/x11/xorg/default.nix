# THIS IS A GENERATED FILE.  DO NOT EDIT!
{
  lib,
  bdftopcf,
  font-adobe-100dpi,
  font-adobe-75dpi,
  font-adobe-utopia-100dpi,
  font-adobe-utopia-75dpi,
  font-adobe-utopia-type1,
  font-alias,
  font-bh-ttf,
  font-bh-type1,
  font-encodings,
  font-mutt-misc,
  font-util,
  gccmakedep,
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
  libx11,
  libxau,
  libxaw,
  libxcb,
  libxcb-errors,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxcvt,
  libxcursor,
  libxdmcp,
  libxext,
  libxfixes,
  libxmu,
  libxpm,
  libxrandr,
  libxrender,
  libxt,
  libxv,
  libxvmc,
  libxxf86dga,
  libxxf86misc,
  libxxf86vm,
  lndir,
  luit,
  makedepend,
  mkfontscale,
  pixman,
  sessreg,
  transset,
  util-macros,
  xbitmaps,
  xcb-proto,
  xcmsdb,
  xcursorgen,
  xcursor-themes,
  xdriinfo,
  xev,
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
  xmodmap,
  xorg-cf-files,
  xorg-docs,
  xorgproto,
  xorg-sgml-doctools,
  xprop,
  xrandr,
  xrefresh,
  xtrans,
  xvinfo,
  xwininfo,
  xwud,
}:

self: with self; {

  inherit
    bdftopcf
    gccmakedep
    ico
    imake
    libdmx
    libfontenc
    libpciaccess
    libxcb
    libxcvt
    lndir
    luit
    makedepend
    mkfontscale
    pixman
    sessreg
    transset
    xbitmaps
    xcmsdb
    xcursorgen
    xdriinfo
    xev
    xfsinfo
    xgamma
    xgc
    xhost
    xkbutils
    xkill
    xlsatoms
    xlsclients
    xlsfonts
    xmodmap
    xorgproto
    xprop
    xrandr
    xrefresh
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
  fontbhttf = font-bh-ttf;
  fontbhtype1 = font-bh-type1;
  fontmuttmisc = font-mutt-misc;
  fontutil = font-util;
  libAppleWM = libapplewm;
  libFS = libfs;
  libICE = libice;
  libpthreadstubs = libpthread-stubs;
  libSM = libsm;
  libX11 = libx11;
  libXau = libxau;
  libXaw = libxaw;
  libXcursor = libxcursor;
  libXdmcp = libxdmcp;
  libXext = libxext;
  libXfixes = libxfixes;
  libXmu = libxmu;
  libXpm = libxpm;
  libXrandr = libxrandr;
  libXrender = libxrender;
  libXt = libxt;
  libXv = libxv;
  libXvMC = libxvmc;
  libXxf86dga = libxxf86dga;
  libXxf86misc = libxxf86misc;
  libXxf86vm = libxxf86vm;
  utilmacros = util-macros;
  xcbproto = xcb-proto;
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

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  appres = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      xorgproto,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "appres";
      version = "1.0.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/appres-1.0.7.tar.xz";
        sha256 = "17w17gqnfmpfmqgbjci1j4lnsd468k5yscxl3n6pmn4z4f4v250i";
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
  bitmap = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      xbitmaps,
      libXmu,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "bitmap";
      version = "1.1.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/bitmap-1.1.1.tar.xz";
        sha256 = "1ri66kxa9m6s3xw25mz85k34qhjyksa4kbs4jfrri0g47yv2xm33";
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
        xbitmaps
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
  editres = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libxkbfile,
      libX11,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "editres";
      version = "1.0.9";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/editres-1.0.9.tar.xz";
        sha256 = "1imk7mgdc3q9lf058xisajij374x8r31ynvqmwbs9khfdxx3zz6d";
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
        libxkbfile
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
  fontarabicmisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-arabic-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-arabic-misc-1.0.4.tar.xz";
        sha256 = "0rrlcqbyx9y7hnhbkjir8rs6jkfqyalj1zvhr8niv2n7a8dydzs6";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh100dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bh-100dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bh-100dpi-1.0.4.tar.xz";
        sha256 = "07mb9781c9yxzp3ifw317v4fbnmg9qyqv0244zfspylihkz5x3zx";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh75dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bh-75dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bh-75dpi-1.0.4.tar.xz";
        sha256 = "1nkwkqdl946xc4xknhi1pnxdww6rxrv013c7nk5x6ganfg0dh9k0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter100dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bh-lucidatypewriter-100dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-100dpi-1.0.4.tar.xz";
        sha256 = "1wp87pijbydkpcmawsyas7vwhad2xg1mkkwigga2jjh9lknhkv3n";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter75dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bh-lucidatypewriter-75dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-75dpi-1.0.4.tar.xz";
        sha256 = "1xg86mb9qigf5v0wx0q2shn8qaabsapamj627xllzw31mhwjqkl6";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream100dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bitstream-100dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bitstream-100dpi-1.0.4.tar.xz";
        sha256 = "19y1j1v65890x8yn6a47jqljfax3ihfrd25xbzgypxz4xy1cc71d";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream75dpi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bitstream-75dpi";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bitstream-75dpi-1.0.4.tar.xz";
        sha256 = "09pq7dvyyxj6kvps1dm3qr15pjwh9iq9118fryqc5a94fkc39sxa";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamspeedo = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bitstream-speedo";
      version = "1.0.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bitstream-speedo-1.0.2.tar.gz";
        sha256 = "0wmy58cd3k7w2j4v20icnfs8z3b61qj3vqdx958z18w00h9mzsmf";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamtype1 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-bitstream-type1";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-bitstream-type1-1.0.4.tar.xz";
        sha256 = "0a669193ivi2lxk3v692kq1pqavaswlpi9hbi8ib8bfp9j5j6byy";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcronyxcyrillic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-cronyx-cyrillic";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-cronyx-cyrillic-1.0.4.tar.xz";
        sha256 = "12dpsvif85z1m6jvq9g91lmzj0rll5rh3871mbvdpzyb1p7821yw";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcursormisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-cursor-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-cursor-misc-1.0.4.tar.xz";
        sha256 = "10prshcmmm5ccczyq7yaadz92k23ls9rjl10hjh8rjqka1cwkn95";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdaewoomisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-daewoo-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-daewoo-misc-1.0.4.tar.xz";
        sha256 = "0cagg963v94paq1l9l7g5kyv7df8q31b4zcbhv5rh07kr0yqng7n";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdecmisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-dec-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-dec-misc-1.0.4.tar.xz";
        sha256 = "1xqs2qg21h5xg519810hw4bvykjdpf0xgk0xwp0bxy4g3lh6inc2";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontibmtype1 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-ibm-type1";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-ibm-type1-1.0.4.tar.xz";
        sha256 = "0zyfc0mxkzlrbpdn16rj25abf2hcqb592zkks550rm26paamwff4";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontisasmisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-isas-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-isas-misc-1.0.4.tar.xz";
        sha256 = "1z1qqi64hbp297f6ryiswa4ikfn7mcwnb8nadyglni6swsxrbra7";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontjismisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-jis-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-jis-misc-1.0.4.tar.xz";
        sha256 = "1l7spyq93rhydsdnsh46alcfbn2irz664vd209lamxviqkvfzlbq";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmicromisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-micro-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-micro-misc-1.0.4.tar.xz";
        sha256 = "0hzryqyml0bzzw91vqdmzdlb7dm18jmyz0mxy6plks3sppbbkq1f";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmisccyrillic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-misc-cyrillic";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-misc-cyrillic-1.0.4.tar.xz";
        sha256 = "14z9x174fidjn65clkd2y1l6pxspmvphizap9a8h2h06adzil0kn";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscethiopic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-misc-ethiopic";
      version = "1.0.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-misc-ethiopic-1.0.5.tar.xz";
        sha256 = "04mnd620s9wkdid9wnf181yh5vf0n7l096nc3z4zdvm1w7kafja7";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmeltho = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-misc-meltho";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-misc-meltho-1.0.4.tar.xz";
        sha256 = "06ajsqjd20zsk9a44bl5i1mv1r9snil6l2947hk8z2bqf30mxgk3";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-misc-misc";
      version = "1.1.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-misc-misc-1.1.3.tar.xz";
        sha256 = "1vcgc6lbc53fqaz8alhxcb6f231hhvj9hn2nkzg1mclbymhy7avr";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontschumachermisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-schumacher-misc";
      version = "1.1.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-schumacher-misc-1.1.3.tar.xz";
        sha256 = "0w40lr214n39al449fnm4k1bpyj3fjrhz2yxqd6a6m8yvc69z14b";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        fontutil
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontscreencyrillic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-screen-cyrillic";
      version = "1.0.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-screen-cyrillic-1.0.5.tar.xz";
        sha256 = "1h75zn1rp7bdv6av4cnrajpaq6fkd7dx1lc7aijpw32qrnw8nxcg";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsonymisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-sony-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-sony-misc-1.0.4.tar.xz";
        sha256 = "0swlhjmmagrfkip4i9yq7cr56hains1j41mjs05nxc6c7y19zc76";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsunmisc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-sun-misc";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-sun-misc-1.0.4.tar.xz";
        sha256 = "17yvhk1hlajm3q57r09q8830zz7cnckrg8hgzajgyyljdl8xv16x";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fonttosfnt = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libfontenc,
      freetype,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "fonttosfnt";
      version = "1.2.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/fonttosfnt-1.2.4.tar.xz";
        sha256 = "0wk3fs038sh2sl1sqayzfjvygmcdp903qa1pd3aankxrgzv3b5i4";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libfontenc
        freetype
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
  fontwinitzkicyrillic = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      bdftopcf,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-winitzki-cyrillic";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-winitzki-cyrillic-1.0.4.tar.xz";
        sha256 = "1a4pz8f7hz6nn9xirz2k1j81ykl3lwrpi1ydmzipciy15l984v9v";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        bdftopcf
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontxfree86type1 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontutil,
      mkfontscale,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "font-xfree86-type1";
      version = "1.0.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/font/font-xfree86-type1-1.0.5.tar.xz";
        sha256 = "0ds8xbgxy9h0bqn2p38vylfzn8cqkp7n51kwmw1c18ayi9w2qg59";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        mkfontscale
      ];
      buildInputs = [ fontutil ];
      configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
      postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  iceauth = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libICE,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "iceauth";
      version = "1.0.10";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/iceauth-1.0.10.tar.xz";
        sha256 = "0ad0kbr5bfdk9na3jmjpg26gd6hwv4lxja2nkdwxrybal9yzpvix";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libICE
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
  libWindowsWM = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libWindowsWM";
      version = "1.0.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libWindowsWM-1.0.1.tar.bz2";
        sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
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
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "windowswm" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXScrnSaver = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXScrnSaver";
      version = "1.2.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXScrnSaver-1.2.4.tar.xz";
        sha256 = "1zi0r6mqa1g0hhsp02cdsjcxmsbipiv0v65c1h4pl84fydcjikbm";
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
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xscrnsaver" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

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
  libXcomposite = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXfixes,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXcomposite";
      version = "0.4.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXcomposite-0.4.6.tar.xz";
        sha256 = "11rcvk380l5540gfqy9p8mbzw3l1p5g8l214p870f28smvqbqh7y";
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
        libXfixes
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xcomposite" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXdamage = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXfixes,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXdamage";
      version = "1.1.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXdamage-1.1.6.tar.xz";
        sha256 = "04axzdx75w0wcb4na7lfpa0ai0fddw60dmg7cigs7z32a8gkqwsj";
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
        libXfixes
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xdamage" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libfontenc,
      xorgproto,
      freetype,
      xtrans,
      zlib,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXfont";
      version = "1.5.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXfont-1.5.4.tar.bz2";
        sha256 = "0hiji1bvpl78aj3a3141hkk353aich71wv8l5l2z51scfy878zqs";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libfontenc
        xorgproto
        freetype
        xtrans
        zlib
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xfont" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont2 = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libfontenc,
      xorgproto,
      freetype,
      xtrans,
      zlib,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXfont2";
      version = "2.0.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXfont2-2.0.7.tar.xz";
        sha256 = "1ywfwpirvi7fmd3my3cb6szzd9c4p7xy7s1kjjv6k1x4xgyq4ywb";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libfontenc
        xorgproto
        freetype
        xtrans
        zlib
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xfont2" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXft = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      fontconfig,
      freetype,
      libX11,
      xorgproto,
      libXrender,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXft";
      version = "2.3.9";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXft-2.3.9.tar.xz";
        sha256 = "1xbn77zqjzx2zdzqcsbf8pvivlqplnciifxk6lk97mjyjiw5p8k0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        fontconfig
        freetype
        libX11
        xorgproto
        libXrender
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xft" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXi = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      libXfixes,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXi";
      version = "1.8.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXi-1.8.2.tar.xz";
        sha256 = "0161qsac0dgvkkcihpm2062p1lk2l5mj4i7smd713qnnadg5bq6h";
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
        libXfixes
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xi" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXinerama = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXext,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXinerama";
      version = "1.1.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXinerama-1.1.5.tar.xz";
        sha256 = "0p08q8q1wg0sixhizl2l1i935bk6x3ckj3bdd6qqr0n1zkqd352h";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXext
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xinerama" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXp = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXau,
      libXext,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXp";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXp-1.0.4.tar.xz";
        sha256 = "197iklxwyd4naryc6mzv0g5qi1dy1apxk9w9k3yshd1ax2wf668z";
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
        libXau
        libXext
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xp" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXpresent = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      libXfixes,
      libXrandr,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXpresent";
      version = "1.0.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXpresent-1.0.1.tar.xz";
        sha256 = "06r34v7z3jb0x7l5ghlc1g82gjjp5ilq5p6j11galv86bagdyr5r";
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
        libXfixes
        libXrandr
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xpresent" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXres = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXres";
      version = "1.2.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXres-1.2.2.tar.xz";
        sha256 = "0pvlzahqd8fcyq10wi7ipbxvgrg93hn0vqsymhw7b6sb93rlcx4s";
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
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xres" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXtst = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      libXext,
      libXi,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libXtst";
      version = "1.2.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libXtst-1.2.5.tar.xz";
        sha256 = "0hljblisw72fk60y7zf9214ydn7lk32kj43cf12af2bhp4jlq3dm";
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
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xtst" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxkbfile = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      libX11,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libxkbfile";
      version = "1.1.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libxkbfile-1.1.3.tar.xz";
        sha256 = "1v2bhw1q1cj3wjfs0igq393iz10whcavbyxlm3k9xfvsk7m3xdm9";
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
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xkbfile" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxshmfence = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "libxshmfence";
      version = "1.3.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/libxshmfence-1.3.3.tar.xz";
        sha256 = "046y7zn8agp8kdr1lg11yyvpx90i9sjf77h25jhgx5msd84xz96l";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ xorgproto ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xshmfence" ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  listres = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "listres";
      version = "1.0.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/listres-1.0.6.tar.xz";
        sha256 = "1jj3xqm4bkzzdikb189ga6q79267jklpf5byhzr599lvsvpm672d";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
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
  oclock = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libxkbfile,
      libX11,
      libXext,
      libXmu,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "oclock";
      version = "1.0.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/oclock-1.0.6.tar.xz";
        sha256 = "1gi41nmf5glvzasri0glka19h6gkpbiy0bwbvdxwl7i15mg5xs1y";
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
        libxkbfile
        libX11
        libXext
        libXmu
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
  setxkbmap = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libxkbfile,
      libXrandr,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "setxkbmap";
      version = "1.3.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/setxkbmap-1.3.4.tar.xz";
        sha256 = "1pps0x66512y3f7v6xgnb6gjbllsgi4q5zxmjcdiv60fsia8b3dy";
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
  smproxy = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libICE,
      libSM,
      libXmu,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "smproxy";
      version = "1.0.8";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/smproxy-1.0.8.tar.xz";
        sha256 = "1j7n5wxbrbzvrrlmg4r7iak1n9r09543nbfpg38y477cwbm89rgy";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libICE
        libSM
        libXmu
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
  twm = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libICE,
      libSM,
      libX11,
      libXext,
      libXmu,
      xorgproto,
      libXrandr,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "twm";
      version = "1.0.13.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/twm-1.0.13.1.tar.xz";
        sha256 = "1igj7lr8xw5ap5wld5a18vav8jn8pa4ajbz5hk495d58b9sk89d5";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libICE
        libSM
        libX11
        libXext
        libXmu
        xorgproto
        libXrandr
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
  viewres = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "viewres";
      version = "1.0.8";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/viewres-1.0.8.tar.xz";
        sha256 = "1lkc5gx7g8zjgjixinq50vlvnv03z2mvj4incdkb341k20miq8jb";
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
  x11perf = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXext,
      libXft,
      libXmu,
      xorgproto,
      libXrender,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "x11perf";
      version = "1.6.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/x11perf-1.6.1.tar.bz2";
        sha256 = "0d3wh6z6znwhfdiv0zaggfj0xgish98xa10yy76b9517zj7hnzhw";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXext
        libXft
        libXmu
        xorgproto
        libXrender
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xauth = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXau,
      libXext,
      libXmu,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xauth";
      version = "1.1.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xauth-1.1.4.tar.xz";
        sha256 = "1466a5hj0rm7sm0cr253hmy9f3yjy20aar451zfb9msa8r0q2cg9";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXau
        libXext
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
  xbacklight = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libxcb,
      xcbutil,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xbacklight";
      version = "1.2.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xbacklight-1.2.4.tar.xz";
        sha256 = "1vp890ic26y4k2l0haw94z4nim3j7gp3g9w5flw2zj0qdw70phyl";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libxcb
        xcbutil
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcalc = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xcalc";
      version = "1.1.2";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xcalc-1.1.2.tar.xz";
        sha256 = "1m0wzhjvc88kmx12ykdml5rqlz9h2iki9mkfdngji53y8nhxyy45";
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
  xcbutilcursor = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      gperf,
      libxcb,
      xcbutilimage,
      xcbutilrenderutil,
      xorgproto,
      m4,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xcb-util-cursor";
      version = "0.1.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/lib/xcb-util-cursor-0.1.5.tar.xz";
        sha256 = "0mrwcrm6djbd5zdvqb5v4wr87bzawnaacyqwwhfghw09ssq9kbqc";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [
        pkg-config
        m4
      ];
      buildInputs = [
        gperf
        libxcb
        xcbutilimage
        xcbutilrenderutil
        xorgproto
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xcb-cursor" ];
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
  xcompmgr = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXcomposite,
      libXdamage,
      libXext,
      libXfixes,
      xorgproto,
      libXrender,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xcompmgr";
      version = "1.1.10";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xcompmgr-1.1.10.tar.xz";
        sha256 = "13xrn0ii8widz0pw31fbdy7x8paf729yqhkmxbm3497jqh4zf93q";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libXcomposite
        libXdamage
        libXext
        libXfixes
        xorgproto
        libXrender
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xconsole = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xconsole";
      version = "1.1.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xconsole-1.1.0.tar.xz";
        sha256 = "128i77kn5pfrcrw31p90cb97g8a5y5173admr3gpdnndr9w5jxqc";
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
  xeyes = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libxcb,
      libXext,
      libXi,
      libXmu,
      xorgproto,
      libXrender,
      libXt,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xeyes";
      version = "1.3.0";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xeyes-1.3.0.tar.xz";
        sha256 = "08rhfp5xlmdbyxkvxhgjxdn6vwzrbrjyd7jkk8b7wi1kpw0ccl09";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libxcb
        libXext
        libXi
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
  xfontsel = callPackage (
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
      pname = "xfontsel";
      version = "1.1.1";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xfontsel-1.1.1.tar.xz";
        sha256 = "1j827aiv7lsr2y7jgmv6pb5wmr2l3r3nd2pys0z2a0bpi9jqcjvs";
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
      version = "1.4.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xkbcomp-1.4.7.tar.xz";
        sha256 = "0xqzz209m9i43jbyrf2lh4xdbyhzzzn9mis2f2c32kplwla82a0a";
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
  xmag = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXaw,
      libXmu,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xmag";
      version = "1.0.8";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xmag-1.0.8.tar.xz";
        sha256 = "0clm0vm35lkcir5w3bkypax9j57vyzkl9l89qqxbanvr7mc3qv9j";
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
  xmessage = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXaw,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xmessage";
      version = "1.0.7";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xmessage-1.0.7.tar.xz";
        sha256 = "0mh3lclzh82l4wkwg1d9gflnm1irjydihg30gqfxcwmpl2vwqgvh";
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
        libXaw
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
  xmore = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libXaw,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xmore";
      version = "1.0.4";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xmore-1.0.4.tar.xz";
        sha256 = "16havfffngvx5kc9lam8rhsdfabsj1rsv4g49z346knyq7dn1dby";
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
        libXaw
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
  xorgserver = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      xorgproto,
      openssl,
      libX11,
      libXau,
      libxcb,
      xcbutil,
      xcbutilwm,
      xcbutilimage,
      xcbutilkeysyms,
      xcbutilrenderutil,
      libXdmcp,
      libXfixes,
      libxkbfile,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xorg-server";
      version = "21.1.18";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/xserver/xorg-server-21.1.18.tar.xz";
        sha256 = "0lk3268gzpll547zvaa64rdhs4z89d7w567lbd55swl71n9x2y68";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        xorgproto
        openssl
        libX11
        libXau
        libxcb
        xcbutil
        xcbutilwm
        xcbutilimage
        xcbutilkeysyms
        xcbutilrenderutil
        libXdmcp
        libXfixes
        libxkbfile
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ "xorg-server" ];
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
  xset = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      libXext,
      libXmu,
      xorgproto,
      libXxf86misc,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xset";
      version = "1.2.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xset-1.2.5.tar.xz";
        sha256 = "0bsyyx3k32k9vpb8x3ks7hlfr03nm0i14fv3cg6n4f2vcdajsscz";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        libXext
        libXmu
        xorgproto
        libXxf86misc
      ];
      passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      meta = {
        pkgConfigModules = [ ];
        platforms = lib.platforms.unix;
      };
    })
  ) { };

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xsetroot = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libX11,
      xbitmaps,
      libXcursor,
      libXmu,
      xorgproto,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xsetroot";
      version = "1.1.3";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xsetroot-1.1.3.tar.xz";
        sha256 = "1l9qcv4mldj70slnmfg56nv7yh9j9ca1x795bl26whmlkrdb90b0";
      };
      hardeningDisable = [
        "bindnow"
        "relro"
      ];
      strictDeps = true;
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libX11
        xbitmaps
        libXcursor
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
  xsm = callPackage (
    {
      stdenv,
      pkg-config,
      fetchurl,
      libICE,
      libSM,
      libX11,
      libXaw,
      xorgproto,
      libXt,
      wrapWithXFileSearchPathHook,
      testers,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "xsm";
      version = "1.0.6";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xsm-1.0.6.tar.xz";
        sha256 = "1kk398lbwyag8dljfmjfn4psdwmh66yhvab85xckf306qrscfk5p";
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
        libICE
        libSM
        libX11
        libXaw
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
  xstdcmap = callPackage (
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
      pname = "xstdcmap";
      version = "1.0.5";
      builder = ./builder.sh;
      src = fetchurl {
        url = "mirror://xorg/individual/app/xstdcmap-1.0.5.tar.xz";
        sha256 = "1061b95j08mlwpadyilmpbzfgmm08z69k8nrkbn9k11rg7ilfn1n";
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
