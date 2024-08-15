# THIS IS A GENERATED FILE.  DO NOT EDIT!
{ lib, pixman }:

self: with self; {

  inherit pixman;

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  appres = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "appres";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/appres-1.0.7.tar.xz";
      sha256 = "17w17gqnfmpfmqgbjci1j4lnsd468k5yscxl3n6pmn4z4f4v250i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  bdftopcf = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "bdftopcf";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/bdftopcf-1.1.1.tar.xz";
      sha256 = "026rzs92h9jsc7r0kvvyvwhm22q0805gp38rs14x6ghg7kam7j8i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  bitmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xbitmaps, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "bitmap";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/bitmap-1.1.1.tar.xz";
      sha256 = "1ri66kxa9m6s3xw25mz85k34qhjyksa4kbs4jfrri0g47yv2xm33";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw xbitmaps libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  editres = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, libXaw, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "editres";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/editres-1.0.9.tar.xz";
      sha256 = "1imk7mgdc3q9lf058xisajij374x8r31ynvqmwbs9khfdxx3zz6d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libxkbfile libX11 libXaw libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  encodings = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "encodings";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/encodings-1.1.0.tar.xz";
      sha256 = "0xg99nmpvik6vaz4h03xay7rx0r3bf5a8azkjlpa3ksn2xi3rwcz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobe100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-adobe-100dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-100dpi-1.0.4.tar.xz";
      sha256 = "1kwwbaiqnfm3pcysy9gw0g9xhpgmhjcd6clp7zajhqq5br2gyymn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobe75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-adobe-75dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-75dpi-1.0.4.tar.xz";
      sha256 = "04drk4wi176524lxjwfrnkr3dwz1hysabqfajpj6klfypqnsd08j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopia100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-adobe-utopia-100dpi";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-100dpi-1.0.5.tar.xz";
      sha256 = "0jq27gs5xpwkghggply5pr215lmamrnpr6x5iia76schg8lyr17v";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopia75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-adobe-utopia-75dpi";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-75dpi-1.0.5.tar.xz";
      sha256 = "0q3pg4imdbwwiq2g8a1rypjrgmb33n0r5j9qqnh4ywnh69cj89m7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopiatype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-adobe-utopia-type1";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-type1-1.0.5.tar.xz";
      sha256 = "15snyyy3rk75fikz1hs80nybxai1aynybl0gw32hffv98yy81cjc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontalias = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-alias";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-alias-1.0.5.tar.xz";
      sha256 = "0vkb5mybc0fjfq29lgf5w1b536bwifzkyj8ad9iy7q3kpcby52cz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontarabicmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-arabic-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-arabic-misc-1.0.4.tar.xz";
      sha256 = "0rrlcqbyx9y7hnhbkjir8rs6jkfqyalj1zvhr8niv2n7a8dydzs6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-100dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-100dpi-1.0.4.tar.xz";
      sha256 = "07mb9781c9yxzp3ifw317v4fbnmg9qyqv0244zfspylihkz5x3zx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-75dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-75dpi-1.0.4.tar.xz";
      sha256 = "1nkwkqdl946xc4xknhi1pnxdww6rxrv013c7nk5x6ganfg0dh9k0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-lucidatypewriter-100dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-100dpi-1.0.4.tar.xz";
      sha256 = "1wp87pijbydkpcmawsyas7vwhad2xg1mkkwigga2jjh9lknhkv3n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-lucidatypewriter-75dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-75dpi-1.0.4.tar.xz";
      sha256 = "1xg86mb9qigf5v0wx0q2shn8qaabsapamj627xllzw31mhwjqkl6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhttf = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-ttf";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-ttf-1.0.4.tar.xz";
      sha256 = "0misxkpjc2bir20m01z355sfk3lbpjnshphjzl32p364006zk9c5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bh-type1";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-type1-1.0.4.tar.xz";
      sha256 = "19kjdm0cx766yj9vwkyv7gyg1q4bjag5g500s7nnppmb0vnc7phr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bitstream-100dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-100dpi-1.0.4.tar.xz";
      sha256 = "19y1j1v65890x8yn6a47jqljfax3ihfrd25xbzgypxz4xy1cc71d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bitstream-75dpi";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-75dpi-1.0.4.tar.xz";
      sha256 = "09pq7dvyyxj6kvps1dm3qr15pjwh9iq9118fryqc5a94fkc39sxa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamspeedo = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bitstream-speedo";
    version = "1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-speedo-1.0.2.tar.gz";
      sha256 = "0wmy58cd3k7w2j4v20icnfs8z3b61qj3vqdx958z18w00h9mzsmf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-bitstream-type1";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-type1-1.0.4.tar.xz";
      sha256 = "0a669193ivi2lxk3v692kq1pqavaswlpi9hbi8ib8bfp9j5j6byy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcronyxcyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-cronyx-cyrillic";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-cronyx-cyrillic-1.0.4.tar.xz";
      sha256 = "12dpsvif85z1m6jvq9g91lmzj0rll5rh3871mbvdpzyb1p7821yw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcursormisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-cursor-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-cursor-misc-1.0.4.tar.xz";
      sha256 = "10prshcmmm5ccczyq7yaadz92k23ls9rjl10hjh8rjqka1cwkn95";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdaewoomisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-daewoo-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-daewoo-misc-1.0.4.tar.xz";
      sha256 = "0cagg963v94paq1l9l7g5kyv7df8q31b4zcbhv5rh07kr0yqng7n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdecmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-dec-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-dec-misc-1.0.4.tar.xz";
      sha256 = "1xqs2qg21h5xg519810hw4bvykjdpf0xgk0xwp0bxy4g3lh6inc2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontibmtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-ibm-type1";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-ibm-type1-1.0.4.tar.xz";
      sha256 = "0zyfc0mxkzlrbpdn16rj25abf2hcqb592zkks550rm26paamwff4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontisasmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-isas-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-isas-misc-1.0.4.tar.xz";
      sha256 = "1z1qqi64hbp297f6ryiswa4ikfn7mcwnb8nadyglni6swsxrbra7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontjismisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-jis-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-jis-misc-1.0.4.tar.xz";
      sha256 = "1l7spyq93rhydsdnsh46alcfbn2irz664vd209lamxviqkvfzlbq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmicromisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-micro-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-micro-misc-1.0.4.tar.xz";
      sha256 = "0hzryqyml0bzzw91vqdmzdlb7dm18jmyz0mxy6plks3sppbbkq1f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmisccyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-misc-cyrillic";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-cyrillic-1.0.4.tar.xz";
      sha256 = "14z9x174fidjn65clkd2y1l6pxspmvphizap9a8h2h06adzil0kn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscethiopic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-misc-ethiopic";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-ethiopic-1.0.5.tar.xz";
      sha256 = "04mnd620s9wkdid9wnf181yh5vf0n7l096nc3z4zdvm1w7kafja7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmeltho = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-misc-meltho";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-meltho-1.0.4.tar.xz";
      sha256 = "06ajsqjd20zsk9a44bl5i1mv1r9snil6l2947hk8z2bqf30mxgk3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-misc-misc";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-misc-1.1.3.tar.xz";
      sha256 = "1vcgc6lbc53fqaz8alhxcb6f231hhvj9hn2nkzg1mclbymhy7avr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmuttmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-mutt-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-mutt-misc-1.0.4.tar.xz";
      sha256 = "095vd33kqd157j6xi4sjxwdsjpwpgqliifa8nkybq8rcw7s5j8xi";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontschumachermisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-schumacher-misc";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-schumacher-misc-1.1.3.tar.xz";
      sha256 = "0w40lr214n39al449fnm4k1bpyj3fjrhz2yxqd6a6m8yvc69z14b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontscreencyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-screen-cyrillic";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-screen-cyrillic-1.0.5.tar.xz";
      sha256 = "1h75zn1rp7bdv6av4cnrajpaq6fkd7dx1lc7aijpw32qrnw8nxcg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsonymisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-sony-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-sony-misc-1.0.4.tar.xz";
      sha256 = "0swlhjmmagrfkip4i9yq7cr56hains1j41mjs05nxc6c7y19zc76";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsunmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-sun-misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-sun-misc-1.0.4.tar.xz";
      sha256 = "17yvhk1hlajm3q57r09q8830zz7cnckrg8hgzajgyyljdl8xv16x";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fonttosfnt = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "fonttosfnt";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/fonttosfnt-1.2.3.tar.xz";
      sha256 = "1bv1glfz4jqvkwx8hmv2vqilvxxl6jww3rvbzv6zbl6b83r96yma";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontutil = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-util";
    version = "1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-util-1.4.1.tar.xz";
      sha256 = "15fcd3rzlgm51fwgfapg6vzyd1kkd28rj149xq7iajqr7h9697sw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "fontutil" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontwinitzkicyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-winitzki-cyrillic";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-winitzki-cyrillic-1.0.4.tar.xz";
      sha256 = "1a4pz8f7hz6nn9xirz2k1j81ykl3lwrpi1ydmzipciy15l984v9v";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontxfree86type1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "font-xfree86-type1";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-xfree86-type1-1.0.5.tar.xz";
      sha256 = "0ds8xbgxy9h0bqn2p38vylfzn8cqkp7n51kwmw1c18ayi9w2qg59";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ fontutil ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    postPatch = ''substituteInPlace configure --replace 'MAPFILES_PATH=`pkg-config' 'MAPFILES_PATH=`$PKG_CONFIG' '';
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  gccmakedep = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "gccmakedep";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/gccmakedep-1.0.4.tar.xz";
      sha256 = "1di5rxv930nhf5ls07fx04l0lqsakxycplmrx4kc6qzvd63zk22h";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  iceauth = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "iceauth";
    version = "1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/iceauth-1.0.10.tar.xz";
      sha256 = "0ad0kbr5bfdk9na3jmjpg26gd6hwv4lxja2nkdwxrybal9yzpvix";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  ico = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "ico";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/ico-1.0.6.tar.xz";
      sha256 = "01a4kykayckxzi4jzggaz3wh9qjcr6f4iykhvq7jhlz767a6kwrq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  imake = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "imake";
    version = "1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/imake-1.0.10.tar.xz";
      sha256 = "1xgcsamfij22ggc4p8anvvihwyf4adg6gjdd6v7m9cypm37cppkm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libAppleWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libAppleWM";
    version = "1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libAppleWM-1.4.1.tar.bz2";
      sha256 = "0r8x28n45q89x91mz8mv0zkkcxi8wazkac886fyvflhiv2y8ap2y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "applewm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libFS = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libFS";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libFS-1.0.9.tar.xz";
      sha256 = "12i0zh1v5zlba617nam8sjhfqi68qqnl7z5hsz3wqhijid1pjwsr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "libfs" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libICE = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libICE";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libICE-1.1.1.tar.xz";
      sha256 = "0lg4sddalwmmzsnxv3fgdm2hzqp66j8b3syc0ancfhi9yzx7mrq3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "ice" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libSM = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libuuid, xorgproto, xtrans, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libSM";
    version = "1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libSM-1.2.4.tar.xz";
      sha256 = "113vx53k6pyxf84v5kqb7qhcldx1fi78lym77lcb2xhj9lgfbjzx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libuuid xorgproto xtrans ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "sm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libWindowsWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libWindowsWM";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libWindowsWM-1.0.1.tar.bz2";
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "windowswm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libX11 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpthreadstubs, libxcb, xtrans, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libX11";
    version = "1.8.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libX11-1.8.10.tar.xz";
      sha256 = "0lywvwsz92j7isglvw2227g3na4ghyspvsvblpf43ns7jfnksfrb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpthreadstubs libxcb xtrans ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "x11" "x11-xcb" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXScrnSaver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXScrnSaver";
    version = "1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXScrnSaver-1.2.4.tar.xz";
      sha256 = "1zi0r6mqa1g0hhsp02cdsjcxmsbipiv0v65c1h4pl84fydcjikbm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xscrnsaver" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXTrap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXTrap";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXTrap-1.0.1.tar.bz2";
      sha256 = "0bi5wxj6avim61yidh9fd3j4n8czxias5m8vss9vhxjnk1aksdwg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xtrap" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXau";
    version = "1.0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXau-1.0.11.tar.xz";
      sha256 = "1sxv56rql3vsb14za0hgr07mipgvvcw48910srmky32pyn135ypk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xau" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXaw = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXmu, libXpm, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXaw";
    version = "1.0.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXaw-1.0.16.tar.xz";
      sha256 = "13wwqfwaahm6dh35w0nkvw32x3li2s0glsks34ggh267ahmmf7bk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXmu libXpm libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xaw6" "xaw7" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXcomposite = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXcomposite";
    version = "0.4.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcomposite-0.4.6.tar.xz";
      sha256 = "11rcvk380l5540gfqy9p8mbzw3l1p5g8l214p870f28smvqbqh7y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcomposite" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXcursor = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXcursor";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcursor-1.2.2.tar.xz";
      sha256 = "1vl87819mnhlbnccchysv9nmax4abil5x3cr61x52vn55jyp3l2k";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcursor" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXdamage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXdamage";
    version = "1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdamage-1.1.6.tar.xz";
      sha256 = "04axzdx75w0wcb4na7lfpa0ai0fddw60dmg7cigs7z32a8gkqwsj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xdamage" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXdmcp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXdmcp";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdmcp-1.1.5.tar.xz";
      sha256 = "1312l8x3asib77wgf123w3nbabnky61mb6pnmmqapbf350l259fq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xdmcp" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXext = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXext";
    version = "1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXext-1.3.6.tar.xz";
      sha256 = "0lwpx0b7lid47pff6dagp5h63bi0b3gsy05lqpyhbr4l76i9zdgd";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xext" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfixes = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXfixes";
    version = "6.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfixes-6.0.1.tar.xz";
      sha256 = "0n1dq2mi60i0c06i7j6lq64cq335ir2l89yj0amj3529s8ygk5dn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xfixes" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXfont";
    version = "1.5.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfont-1.5.4.tar.bz2";
      sha256 = "0hiji1bvpl78aj3a3141hkk353aich71wv8l5l2z51scfy878zqs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc xorgproto freetype xtrans zlib ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xfont" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont2 = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXfont2";
    version = "2.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfont2-2.0.6.tar.xz";
      sha256 = "1x5f4w6f94dq9hfcd11xzzjqbz30yn2hdrnmv1b3zyxhgq0j1jkl";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc xorgproto freetype xtrans zlib ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xfont2" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXft = callPackage ({ stdenv, pkg-config, fetchurl, fontconfig, freetype, libX11, xorgproto, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXft";
    version = "2.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXft-2.3.8.tar.xz";
      sha256 = "0jfxqsqhjl2b2ll6b7x21mj02hxp5znkhjvbxw5a9h6lq95kr32y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ fontconfig freetype libX11 xorgproto libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xft" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXfixes, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXi";
    version = "1.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXi-1.8.1.tar.xz";
      sha256 = "19snjrsdib2y2iq8c1zbrp78qy1b6sdmyvif422gg27j2klc1gw9";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXfixes ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xi" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXinerama = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXinerama";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXinerama-1.1.5.tar.xz";
      sha256 = "0p08q8q1wg0sixhizl2l1i935bk6x3ckj3bdd6qqr0n1zkqd352h";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xinerama" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXmu = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXmu";
    version = "1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXmu-1.2.1.tar.xz";
      sha256 = "1cp82iz7yki63iykvb3alwy4nwy01k2axi5rqpyfafca4j9pgcpw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xmu" "xmuu" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXau, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXp";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXp-1.0.4.tar.xz";
      sha256 = "197iklxwyd4naryc6mzv0g5qi1dy1apxk9w9k3yshd1ax2wf668z";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXau libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xp" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXpm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt, gettext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXpm";
    version = "3.5.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpm-3.5.17.tar.xz";
      sha256 = "0hvf49qy55gwldpwpw7ihcmn5i2iinpjh2rbha63hzcy060izcv4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xpm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXpresent = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXfixes, libXrandr, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXpresent";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpresent-1.0.1.tar.xz";
      sha256 = "06r34v7z3jb0x7l5ghlc1g82gjjp5ilq5p6j11galv86bagdyr5r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXfixes libXrandr ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xpresent" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXrandr = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXrandr";
    version = "1.5.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrandr-1.5.4.tar.xz";
      sha256 = "1lxlqd9ffjr1myfpyk91594n1h07ck6121m6ba8qajjz6xjv1m8s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xrandr" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXrender = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXrender";
    version = "0.9.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrender-0.9.11.tar.xz";
      sha256 = "096whakny5h16nlwz80z0l2nxigpsarl35mm5xqgzlc37ad7alxw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xrender" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXres = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXres";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXres-1.2.2.tar.xz";
      sha256 = "0pvlzahqd8fcyq10wi7ipbxvgrg93hn0vqsymhw7b6sb93rlcx4s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xres" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXt = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto, libSM, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXt";
    version = "1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXt-1.3.0.tar.xz";
      sha256 = "14dz66rp66ar2a5q0fbsnlcqkbd34801pzdxj3f0hzc2vcy0p0jj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto libSM libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xt" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXtst = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXtst";
    version = "1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXtst-1.2.4.tar.xz";
      sha256 = "1j1kr90b7vmpqniqd0pd786kn5924q799c5m2kpgzd2lj85z7xc4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXi ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xtst" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXv";
    version = "1.0.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXv-1.0.12.tar.xz";
      sha256 = "0j1qqrhbhdi3kqz0am5i1lhs31ql9pbc14z41w0a5xw9yq4zmxxa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xv" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXvMC = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXv, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXvMC";
    version = "1.0.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXvMC-1.0.14.tar.xz";
      sha256 = "1nayf8qck0b1xb88dirdbvj7clr18wq1dxs73zwbpzdsnsv9xgp4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXv ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xvmc" "xvmc-wrapper" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86dga = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXxf86dga";
    version = "1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86dga-1.1.6.tar.xz";
      sha256 = "03wqsxbgyrdbrhw8fk3fxc9nk8jnwz5537ym2yif73w0g5sl4i5y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xxf86dga" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86misc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXxf86misc";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86misc-1.0.4.tar.bz2";
      sha256 = "107k593sx27vjz3v7gbb223add9i7w0bjc90gbb3jqpin3i07758";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xxf86misc" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86vm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libXxf86vm";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86vm-1.1.5.tar.xz";
      sha256 = "1rw8z01vgfc4wvf0q75sgnj6n04dkrw1w7z455qydrz0nd4fyzr4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xxf86vm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libdmx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libdmx";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libdmx-1.1.5.tar.xz";
      sha256 = "0kzprd1ak3m3042m5hra50nsagswciis9p21ckilyaqbidmf591m";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "dmx" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libfontenc = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, zlib, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libfontenc";
    version = "1.1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libfontenc-1.1.8.tar.xz";
      sha256 = "1ihlznj4m49jn1887cr86qqhrrlghvbfj7bbh230svi30pac60kv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto zlib ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "fontenc" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libpciaccess = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libpciaccess";
    version = "0.18.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libpciaccess-0.18.1.tar.xz";
      sha256 = "0xpslrjnfrc1a7y8f8qwnd3wq24ndpj2q77ds12mbnwand239x2a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "pciaccess" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libpthreadstubs = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libpthread-stubs";
    version = "0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/libpthread-stubs-0.5.tar.xz";
      sha256 = "1g224hyy694jch54357zc895z46r90xs193hg4m7rfnfxinmdnjr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "pthread-stubs" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxcb = callPackage ({ stdenv, pkg-config, fetchurl, libxslt, libpthreadstubs, libXau, xcbproto, libXdmcp, python3, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libxcb";
    version = "1.17.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxcb-1.17.0.tar.xz";
      sha256 = "0mbdkajqhg0j0zjc9a2z1qyv9mca797ihvifc9qyl3vijscvz7jr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libxslt libpthreadstubs libXau xcbproto libXdmcp ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb" "xcb-composite" "xcb-damage" "xcb-dbe" "xcb-dpms" "xcb-dri2" "xcb-dri3" "xcb-ge" "xcb-glx" "xcb-present" "xcb-randr" "xcb-record" "xcb-render" "xcb-res" "xcb-screensaver" "xcb-shape" "xcb-shm" "xcb-sync" "xcb-xevie" "xcb-xf86dri" "xcb-xfixes" "xcb-xinerama" "xcb-xinput" "xcb-xkb" "xcb-xprint" "xcb-xselinux" "xcb-xtest" "xcb-xv" "xcb-xvmc" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxcvt = callPackage ({ stdenv, pkg-config, fetchurl, meson, ninja, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libxcvt";
    version = "0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxcvt-0.1.2.tar.xz";
      sha256 = "0f6vf47lay9y288n8yg9ckjgz5ypn2hnp03ipp7javkr8h2njq85";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config meson ninja ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxkbfile = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libxkbfile";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxkbfile-1.1.3.tar.xz";
      sha256 = "1v2bhw1q1cj3wjfs0igq393iz10whcavbyxlm3k9xfvsk7m3xdm9";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xkbfile" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxshmfence = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "libxshmfence";
    version = "1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxshmfence-1.3.2.tar.xz";
      sha256 = "0vv0c7rjf6nd1afbal4c4ralallarak1v3ss3gcjdca0pibz43c7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xshmfence" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  listres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, xorgproto, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "listres";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/listres-1.0.6.tar.xz";
      sha256 = "1jj3xqm4bkzzdikb189ga6q79267jklpf5byhzr599lvsvpm672d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  lndir = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "lndir";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/lndir-1.0.5.tar.xz";
      sha256 = "1nsd23kz6iqxfcis3432zq01i54n98b94m2gcsay1k3mamx5fr9v";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  luit = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "luit";
    version = "20240102";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://invisible-mirror.net/archives/luit/luit-20240102.tgz";
      sha256 = "10n0xf8m3j6xhj5dgc0km40n9vy38hwnvjfq4pr0xiffrllflym0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  makedepend = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "makedepend";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/makedepend-1.0.9.tar.xz";
      sha256 = "1m1dg32z22fw9shg0wsxw7dvdcnfm16gq9qxpkfxixpzb6vdxl4j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  mkfontscale = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto, zlib, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "mkfontscale";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/mkfontscale-1.2.3.tar.xz";
      sha256 = "0pp7dyfrrkrqxslk9q8660k0h4swaqlixsnnph2fxb7i8k1ws899";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto zlib ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  oclock = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, libXext, libXmu, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "oclock";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/oclock-1.0.5.tar.xz";
      sha256 = "0p4nqfrhy1srqqzbamp7afa54clbydbhprd1nxbd12g8anb9f2cg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libxkbfile libX11 libXext libXmu libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  sessreg = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "sessreg";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/sessreg-1.1.3.tar.xz";
      sha256 = "1hmc9wsfgl2wmy0kccwa4brxbv02w5wiz5hrz72dsz87x1fwsah2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  setxkbmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, libXrandr, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "setxkbmap";
    version = "1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/setxkbmap-1.3.4.tar.xz";
      sha256 = "1pps0x66512y3f7v6xgnb6gjbllsgi4q5zxmjcdiv60fsia8b3dy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile libXrandr ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  smproxy = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libXmu, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "smproxy";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/smproxy-1.0.7.tar.xz";
      sha256 = "01gkz4n2pfxiklzzx3ghnm9shx3626jcriwvrs3pvawxrhvr5aaa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libSM libXmu libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  transset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "transset";
    version = "1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/transset-1.0.3.tar.xz";
      sha256 = "1zp6ldxb3h2zsr4nmkb8aj8ia8v3qvjj3w85by5xh3fxvlq8zqqz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  twm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXext, libXmu, xorgproto, libXrandr, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "twm";
    version = "1.0.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/twm-1.0.12.tar.xz";
      sha256 = "1r5gfv1gvcjn39v7n6znpnvifwhlw2zf8gfrxq8vph84vva03wma";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libSM libX11 libXext libXmu xorgproto libXrandr libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  utilmacros = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "util-macros";
    version = "1.20.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/util-macros-1.20.1.tar.xz";
      sha256 = "1xffkcqv96vpk5pckisanrvg4w7i9ciqhs6yv7sc12p7vii8yc0b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-macros" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  viewres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "viewres";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/viewres-1.0.7.tar.xz";
      sha256 = "0a66mz27gcsxd1qq1ij0w8dv4wjvszgbf5ygw5dga40sbc464nmi";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw libXmu libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  x11perf = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXft, libXmu, xorgproto, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "x11perf";
    version = "1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/x11perf-1.6.1.tar.bz2";
      sha256 = "0d3wh6z6znwhfdiv0zaggfj0xgish98xa10yy76b9517zj7hnzhw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXft libXmu xorgproto libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xauth = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXext, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xauth";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xauth-1.1.3.tar.xz";
      sha256 = "0cwxzq7lv932rcfad3baanr541qcjjdhyrhxy0bzjcp3pac581z7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXau libXext libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xbacklight = callPackage ({ stdenv, pkg-config, fetchurl, libxcb, xcbutil, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xbacklight";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xbacklight-1.2.3.tar.bz2";
      sha256 = "1plssg0s3pbslg6rfzxp9sx8ryvn8l32zyvc8zp9zsbsfwjg69rs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb xcbutil ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xbitmaps = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xbitmaps";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xbitmaps-1.1.3.tar.xz";
      sha256 = "0yhgrllia3lbqx9b21w31w4sppx1a9ggrk62hrys2ckqi1aasv5d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xbitmaps" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcalc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcalc";
    version = "1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcalc-1.1.2.tar.xz";
      sha256 = "1m0wzhjvc88kmx12ykdml5rqlz9h2iki9mkfdngji53y8nhxyy45";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbproto = callPackage ({ stdenv, pkg-config, fetchurl, python3, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-proto";
    version = "1.17.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xcb-proto-1.17.0.tar.xz";
      sha256 = "130lc8jx43s83496nc8jn47zixjcp4abgsz69pvrjiqg279aq6rc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-proto" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-0.4.1.tar.xz";
      sha256 = "04p54r0zjc44fpw1hdy4rhygv37sx2vr2lllxjihykz5v2xkpgjs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-atom" "xcb-aux" "xcb-event" "xcb-util" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilcursor = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutilimage, xcbutilrenderutil, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-cursor";
    version = "0.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/xcb-util-cursor-0.1.5.tar.xz";
      sha256 = "0mrwcrm6djbd5zdvqb5v4wr87bzawnaacyqwwhfghw09ssq9kbqc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutilimage xcbutilrenderutil xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-cursor" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilerrors = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbproto, xorgproto, m4, python3, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-errors";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-errors-1.0.1.tar.xz";
      sha256 = "0mzkh3xj1n690dw8hrdhyjykd71ib0ls9n5cgf9asna2k1xwha2n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 python3 ];
    buildInputs = [ gperf libxcb xcbproto xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-errors" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilimage = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutil, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-image";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-image-0.4.1.tar.xz";
      sha256 = "0g8dwknrlz96k176qxh8ar84x9kpppci9b978zyp24nvvbjqxbfc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutil xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-image" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilkeysyms = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-keysyms";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-keysyms-0.4.1.tar.xz";
      sha256 = "0f66snk179hmp8ppgv1zp9y7pl1vzn52znpikm1fsaj1ji90l9kw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-keysyms" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilrenderutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-renderutil";
    version = "0.3.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-renderutil-0.3.10.tar.xz";
      sha256 = "1fh4dnlwlqyccrhmmwlv082a7mxc7ss7vmzmp7xxp39dwbqd859y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-renderutil" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilwm = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcb-util-wm";
    version = "0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xcb/xcb-util-wm-0.4.2.tar.xz";
      sha256 = "02wai17mxfbvlnj4l4bjbvah97rccdivzvd7mrznhr32s0hlxhv2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xcb-ewmh" "xcb-icccm" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xclock = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXft, libxkbfile, libXmu, xorgproto, libXrender, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xclock";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xclock-1.1.1.tar.xz";
      sha256 = "0b3l1zwz2b1cn46f8pd480b835j9anadf929vqpll107iyzylz6z";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXft libxkbfile libXmu xorgproto libXrender libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcmsdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcmsdb";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcmsdb-1.0.6.tar.xz";
      sha256 = "0magrza0i5qwpf0zlpqjychp3bzxgdw3p5v616xl4nbxag2fwxrw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcompmgr = callPackage ({ stdenv, pkg-config, fetchurl, libXcomposite, libXdamage, libXext, libXfixes, xorgproto, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcompmgr";
    version = "1.1.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcompmgr-1.1.9.tar.xz";
      sha256 = "1w564walyqi3bqnnl8l2d949v64smipdw2q8lnrixl3jhrlvcxa8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXcomposite libXdamage libXext libXfixes xorgproto libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xconsole = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xconsole";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xconsole-1.1.0.tar.xz";
      sha256 = "128i77kn5pfrcrw31p90cb97g8a5y5173admr3gpdnndr9w5jxqc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcursorgen = callPackage ({ stdenv, pkg-config, fetchurl, libpng, libX11, libXcursor, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcursorgen";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcursorgen-1.0.8.tar.xz";
      sha256 = "16yc82k4vp7icmf9247z4v38r65pdf032mrpzxj5wa2fggi3rcrj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libpng libX11 libXcursor xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcursorthemes = callPackage ({ stdenv, pkg-config, fetchurl, libXcursor, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xcursor-themes";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xcursor-themes-1.0.7.tar.xz";
      sha256 = "1j3qfga5llp8g702n7mivvdvfjk7agsgnbglbfh99n13i3sfiflm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXcursor ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXaw, libXdmcp, libXext, libXft, libXinerama, libXmu, libXpm, xorgproto, libXrender, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xdm";
    version = "1.1.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdm-1.1.16.tar.xz";
      sha256 = "1737hz8g3wpgdfj6y11q1xwma40wvgz85ckp6wv0hmz9h6c21wmw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm xorgproto libXrender libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdpyinfo = callPackage ({ stdenv, pkg-config, fetchurl, libdmx, libX11, libxcb, libXcomposite, libXext, libXi, libXinerama, xorgproto, libXrender, libXtst, libXxf86dga, libXxf86misc, libXxf86vm, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xdpyinfo";
    version = "1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdpyinfo-1.3.4.tar.xz";
      sha256 = "0aw2yhx4ys22231yihkzhnw9jsyzksl4yyf3sx0689npvf0sbbd8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xorgproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdriinfo = callPackage ({ stdenv, pkg-config, fetchurl, libGL, xorgproto, libX11, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xdriinfo";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdriinfo-1.0.7.tar.xz";
      sha256 = "0d7p9fj3znq0av9pjgi2kphqaz5w7b9hxlz63zbxs69bknp8p0yx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libGL xorgproto libX11 ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xev = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xev";
    version = "1.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xev-1.2.6.tar.xz";
      sha256 = "1mq7332kgisd9yq0w0rv11vhwhgpkmpg7pfdlyn776dc13hcbqb1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXrandr ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xeyes = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxcb, libXext, libXi, libXmu, xorgproto, libXrender, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xeyes";
    version = "1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xeyes-1.3.0.tar.xz";
      sha256 = "08rhfp5xlmdbyxkvxhgjxdn6vwzrbrjyd7jkk8b7wi1kpw0ccl09";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxcb libXext libXi libXmu xorgproto libXrender libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputevdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, udev, mtdev, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-evdev";
    version = "2.10.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-evdev-2.10.6.tar.bz2";
      sha256 = "1h1y0fwnawlp4yc5llr1l7hwfcxxpln2fxhy6arcf6w6h4z0f9l7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libevdev udev mtdev xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-evdev" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputjoystick = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-joystick";
    version = "1.6.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-joystick-1.6.4.tar.xz";
      sha256 = "1lnc6cvrg81chb2hj3jphgx7crr4ab8wn60mn8f9nsdwza2w8plh";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-joystick" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputkeyboard = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-keyboard";
    version = "2.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-keyboard-2.0.0.tar.xz";
      sha256 = "1fgya6a0pzsb8ynp2qhx3bqg6nfc4y2sw9wmk7zd8pqplbqzsrij";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputlibinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libinput, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-libinput";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-libinput-1.4.0.tar.xz";
      sha256 = "1673ydfrvfqd4inz3vx1qyxa0mhr0f4bi0r7mrcmpisxi76i8g9s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libinput xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-libinput" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-mouse";
    version = "1.9.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-mouse-1.9.5.tar.xz";
      sha256 = "0s4rzp7aqpbqm4474hg4bz7i7vg3ir93ck2q12if4lj3nklqmpjg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-mouse" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputsynaptics = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, libX11, libXi, xorgserver, libXtst, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-synaptics";
    version = "1.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-synaptics-1.9.2.tar.xz";
      sha256 = "0f1cjs9haxhjybfh2lh579s15i2q0q19whynpda3giizj6mlmymq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libevdev libX11 libXi xorgserver libXtst ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-synaptics" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvmmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, udev, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-vmmouse";
    version = "13.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-vmmouse-13.2.0.tar.xz";
      sha256 = "1f1rlgp1rpsan8k4ax3pzhl1hgmfn135r31m80pjxw5q19c7gw2n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto udev xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvoid = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-input-void";
    version = "1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-void-1.4.2.tar.xz";
      sha256 = "11bqy2djgb82c1g8ylpfwp3wjw4x83afi8mqyn5fvqp03kidh4d2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgserver xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoamdgpu = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-amdgpu";
    version = "23.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-amdgpu-23.0.0.tar.xz";
      sha256 = "0qf0kjh6pww5abxmqa4c9sfa2qq1hq4p8qcgqpfd1kpkcvmg012g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto mesa libGL libdrm udev xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoapm = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-apm";
    version = "1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-apm-1.3.0.tar.bz2";
      sha256 = "0znwqfc8abkiha98an8hxsngnz96z6cd976bc4bsvz1km6wqk0c0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoark = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-ark";
    version = "0.7.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ark-0.7.6.tar.xz";
      sha256 = "0p88blr3zgy47jc4aqivc6ypj4zq9pad1cl70wwz9xig29w9xk2s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoast = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-ast";
    version = "1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ast-1.1.6.tar.xz";
      sha256 = "1bqdjcxi8fj48821322djdqnrla2i48wqckdf364zagrqyllyxbm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoati = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-ati";
    version = "22.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ati-22.0.0.tar.xz";
      sha256 = "0vdznwx78alhbb05paw2xd65hcsila2kqflwwnbpq8pnsdbbpj68";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto mesa libGL libdrm udev libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videochips = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-chips";
    version = "1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-chips-1.5.0.tar.xz";
      sha256 = "1cyljd3h2hjv42ldqimf4lllqhb8cma6p3n979kr8nn81rjdkhw4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videocirrus = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-cirrus";
    version = "1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-cirrus-1.6.0.tar.xz";
      sha256 = "00b468w01hqjczfqz42v2vqhb14db4wazcqi1w29lgfyhc0gmwqf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videodummy = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-dummy";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-dummy-0.4.1.tar.xz";
      sha256 = "1byzsdcnlnzvkcqrzaajzc3nzm7y7ydrk9bjr4x9lx8gznkj069m";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videofbdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-fbdev";
    version = "0.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2";
      sha256 = "16a66zr0l1lmssa07i3rzy07djxnb45c17ks8c71h8l06xgxihyw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videogeode = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-geode";
    version = "2.11.21";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-geode-2.11.21.tar.xz";
      sha256 = "07lzbyxss0m5i4j58z43zri2baawci9q1ykv1g828wqi2hzsqml2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglide = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-glide";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-glide-1.2.2.tar.bz2";
      sha256 = "1vaav6kx4n00q4fawgqnjmbdkppl0dir2dkrj4ad372mxrvl9c4y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglint = callPackage ({ stdenv, pkg-config, fetchurl, libpciaccess, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-glint";
    version = "1.2.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-glint-1.2.9.tar.bz2";
      sha256 = "1lkpspvrvrp9s539bhfdjfh4andaqyk63l6zjn8m3km95smk6a45";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libpciaccess xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-i128";
    version = "1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-i128-1.4.1.tar.xz";
      sha256 = "0imwmkam09wpp3z3iaw9i4hysxicrrax7i3p0l2glgp3zw9var3h";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi740 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-i740";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-i740-1.4.0.tar.bz2";
      sha256 = "0l3s1m95bdsg4gki943qipq8agswbb84dzcflpxa3vlckwhh3r26";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videointel = callPackage ({ stdenv, pkg-config, fetchurl, cairo, xorgproto, libdrm, libpng, udev, libpciaccess, libX11, xcbutil, libxcb, libXcursor, libXdamage, libXext, libXfixes, xorgserver, libXrandr, libXrender, libxshmfence, libXtst, libXvMC, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-intel";
    version = "2.99.917";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-intel-2.99.917.tar.bz2";
      sha256 = "1jb7jspmzidfixbc0gghyjmnmpqv85i7pi13l4h2hn2ml3p83dq0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ cairo xorgproto libdrm libpng udev libpciaccess libX11 xcbutil libxcb libXcursor libXdamage libXext libXfixes xorgserver libXrandr libXrender libxshmfence libXtst libXvMC ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videomga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-mga";
    version = "2.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-mga-2.0.1.tar.xz";
      sha256 = "1aq3aqh2yg09gy864kkshfx5pjl5w05jdz97bx5bnrbrhdq3p8r7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoneomagic = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-neomagic";
    version = "1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-neomagic-1.3.1.tar.xz";
      sha256 = "153lzhq0vahg3875wi8hl9rf4sgizs41zmfg6hpfjw99qdzaq7xn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonewport = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-newport";
    version = "0.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-newport-0.2.4.tar.bz2";
      sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonouveau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-nouveau";
    version = "3ee7cbca8f9144a3bb5be7f71ce70558f548d268";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau/-/archive/3ee7cbca8f9144a3bb5be7f71ce70558f548d268/xf86-video-nouveau-3ee7cbca8f9144a3bb5be7f71ce70558f548d268.tar.bz2";
      sha256 = "0rhs3z274jdzd82pcsl25xn8hmw6i4cxs2kwfnphpfhxbbkiq7wl";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-nv";
    version = "2.1.23";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-nv-2.1.23.tar.xz";
      sha256 = "1jlap6xjn4pfwg9ab8fxm5mwf4dqfywp70bgc0071m7k66jbv3f6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoomap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-omap";
    version = "0.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-omap-0.4.5.tar.bz2";
      sha256 = "0nmbrx6913dc724y8wj2p6vqfbj5zdjfmsl037v627jj0whx9rwk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoopenchrome = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver, libXvMC, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-openchrome";
    version = "0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-openchrome-0.6.0.tar.bz2";
      sha256 = "0x9gq3hw6k661k82ikd1y2kkk4dmgv310xr5q59dwn4k6z37aafs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess libX11 libXext xorgserver libXvMC ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoqxl = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-qxl";
    version = "0.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-qxl-0.1.6.tar.xz";
      sha256 = "0pwncx60r1xxk8kpp9a46ga5h7k7hjqf14726v0gra27vdc9blra";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videor128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-r128";
    version = "6.12.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-r128-6.12.1.tar.xz";
      sha256 = "0hf7h54wxgs8njavp0kgadjq1787fhbd588j7pj685hz2wmkq0kx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videorendition = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-rendition";
    version = "4.2.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-rendition-4.2.7.tar.bz2";
      sha256 = "0yzqcdfrnnyaaaa76d4hpwycpq4x2j8qvg9m4q19lj4xbicwc4cm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videos3virge = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-s3virge";
    version = "1.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-s3virge-1.11.1.tar.xz";
      sha256 = "1qzfcq3rlpfdb6qxz8hrp9py1q11vyzl4iqxip1vpgfnfn83vl6f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosavage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-savage";
    version = "2.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-savage-2.4.1.tar.xz";
      sha256 = "1bqhgldb6yahpgav7g7cyc4kl5pm3mgkq8w2qncj36311hb92hb7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosiliconmotion = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-siliconmotion";
    version = "1.7.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.10.tar.xz";
      sha256 = "1h4g2mqxshaxii416ldw0aqy6cxnsbnzayfin51xm2526dw9q18n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosis = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-sis";
    version = "0.12.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sis-0.12.0.tar.gz";
      sha256 = "00j7i2r81496w27rf4nq9gc66n6nizp3fi7nnywrxs81j1j3pk4v";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosisusb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-sisusb";
    version = "0.9.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sisusb-0.9.7.tar.bz2";
      sha256 = "090lfs3hjz3cjd016v5dybmcsigj6ffvjdhdsqv13k90p4b08h7l";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosuncg6 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-suncg6";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-suncg6-1.1.3.tar.xz";
      sha256 = "16c3g5m0f5y9nx2x6w9jdzbs9yr6xhq31j37dcffxbsskmfxq57w";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunffb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-sunffb";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sunffb-1.2.3.tar.xz";
      sha256 = "0pf4ddh09ww7sxpzs5gr9pxh3gdwkg3f54067cp802nkw1n8vypi";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunleo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-sunleo";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sunleo-1.2.3.tar.xz";
      sha256 = "1px670aiqyzddl1nz3xx1lmri39irajrqw6dskirs2a64jgp3dpc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotdfx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-tdfx";
    version = "1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-tdfx-1.5.0.tar.bz2";
      sha256 = "0qc5wzwf1n65si9rc37bh224pzahh7gp67vfimbxs0b9yvhq0i9g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-tga";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2";
      sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotrident = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-trident";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-trident-1.4.0.tar.xz";
      sha256 = "16qqn1brz50mwcy42zi1wsw9af56qadsaaiwm9hn1p6plyf22xkz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videov4l = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-v4l";
    version = "0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-v4l-0.3.0.tar.bz2";
      sha256 = "084x4p4avy72mgm2vnnvkicw3419i6pp3wxik8zqh7gmq4xv5z75";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovboxvideo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-vboxvideo";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vboxvideo-1.0.1.tar.xz";
      sha256 = "12kzgf516mbdygpni0jzm3dv60vz6vf704f3hgc6pi9bgpy6bz4f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovesa = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-vesa";
    version = "2.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vesa-2.6.0.tar.xz";
      sha256 = "1ccvaigb1f1kz8nxxjmkfn598nabd92p16rx1g35kxm8n5qjf20h";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovmware = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-vmware";
    version = "13.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vmware-13.4.0.tar.xz";
      sha256 = "06mq7spifsrpbwq9b8kn2cn61xq6mpkq6lvh4qi6xk2yxpjixlxf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess libX11 libXext xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovoodoo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-voodoo";
    version = "1.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-voodoo-1.2.6.tar.xz";
      sha256 = "00pn5826aazsdipf7ny03s1lypzid31fmswl8y2hrgf07bq76ab2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videowsfb = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-wsfb";
    version = "0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-wsfb-0.4.0.tar.bz2";
      sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgserver xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoxgi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xf86-video-xgi";
    version = "1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-xgi-1.6.1.tar.bz2";
      sha256 = "10xd2vah0pnpw5spn40n4p95mpmgvdkly4i1cz51imnlfsw7g8si";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, fontconfig, libXaw, libXft, libXmu, xorgproto, libXrender, libXt, gettext, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xfd";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfd-1.1.4.tar.xz";
      sha256 = "1zbnj0z28dx2rm2h7pjwcz7z1jnl28gz0v9xn3hs2igxcvxhyiym";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext wrapWithXFileSearchPathHook ];
    buildInputs = [ libxkbfile fontconfig libXaw libXft libXmu xorgproto libXrender libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfontsel = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, gettext, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xfontsel";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfontsel-1.1.1.tar.xz";
      sha256 = "1j827aiv7lsr2y7jgmv6pb5wmr2l3r3nd2pys0z2a0bpi9jqcjvs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfs = callPackage ({ stdenv, pkg-config, fetchurl, libXfont2, xorgproto, xtrans, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xfs";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfs-1.2.2.tar.xz";
      sha256 = "1k4f15nrgmqkvsn48hnl1j4giwxpmcpdrnq0bq7b6hg265ix82xp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXfont2 xorgproto xtrans ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfsinfo = callPackage ({ stdenv, pkg-config, fetchurl, libFS, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xfsinfo";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfsinfo-1.0.7.tar.xz";
      sha256 = "0x48p4hk0lds2s8nwzgfl616r99s28ydx02zs7p1fxxs3i2wmwwj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libFS xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xgamma = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXxf86vm, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xgamma";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xgamma-1.0.7.tar.xz";
      sha256 = "13xw2fqp9cs7xj3nqi8khqxv81rk0dd8khp59xgs2lw9bbldly8w";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXxf86vm ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xgc = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xgc";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xgc-1.0.6.tar.xz";
      sha256 = "0h5jm2946f5m1g8a3qh1c01h3zrsjjivi09vi9rmij2frvdvp1vv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xhost = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXmu, xorgproto, gettext, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xhost";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xhost-1.0.9.tar.xz";
      sha256 = "0ib66h78ykc4zki4arh8hkcsgk1mk8yyy0ay5sdb2d908qqvb1pa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libX11 libXau libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinit = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xinit";
    version = "1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xinit-1.4.2.tar.xz";
      sha256 = "08qz6f6yhis6jdcp6hzspql6ib9a9zp0ddhhbac1b7zg4a6xrn5p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi, libXinerama, libXrandr, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xinput";
    version = "1.6.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xinput-1.6.4.tar.xz";
      sha256 = "1j2pf28c54apr56v1fmvprp657n6x4sdrv8f24rx3138cl6x015d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXi libXinerama libXrandr ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbcomp = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkbcomp";
    version = "1.4.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbcomp-1.4.7.tar.xz";
      sha256 = "0xqzz209m9i43jbyrf2lh4xdbyhzzzn9mis2f2c32kplwla82a0a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xkbcomp" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbevd = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkbevd";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbevd-1.1.5.tar.xz";
      sha256 = "0swjhk33fp15060hhzycmk288ys51wwm6l7p9xy4blz95mq7nd9q";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbprint = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkbprint";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbprint-1.0.6.tar.xz";
      sha256 = "1c57kb8d8cbf720n9bcjhhaqpk08lac0sk4l0jp8j0mryw299k4r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbutils = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXaw, libXt, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkbutils";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbutils-1.0.6.tar.xz";
      sha256 = "0pp2bsksblvvw0fx667k2bl5sm0baj7pp2cjvq0vmk093vpbp8ii";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXaw libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkeyboardconfig = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkeyboard-config";
    version = "2.42";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.42.tar.xz";
      sha256 = "01q8gs7lnx9d7iz29pal7a3whz7njmgjcpzhy82wa7zhq6znxc56";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkill = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xkill";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkill-1.0.6.tar.xz";
      sha256 = "01xrmqw498hqlhn6l1sq89s31k6sjf6xlij6a08pnrvmqiwama75";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xload = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, gettext, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xload";
    version = "1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xload-1.2.0.tar.xz";
      sha256 = "104snn0rpnc91bmgj797cj6sgmkrp43n9mg20wbmr8p14kbfc3rc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsatoms = callPackage ({ stdenv, pkg-config, fetchurl, libxcb, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xlsatoms";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsatoms-1.1.4.tar.xz";
      sha256 = "1dviriynilkw0jwl0s2h8y95pwh8cxj95cnmllkd6rn0args3gzl";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsclients = callPackage ({ stdenv, pkg-config, fetchurl, libxcb, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xlsclients";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsclients-1.1.5.tar.xz";
      sha256 = "1qxsav5gicsfwv1dqlcfpj47vy9i30i7iysrfx5aql02wxbyxfk8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsfonts = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xlsfonts";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsfonts-1.0.8.tar.xz";
      sha256 = "1kdnzyrm1wqwylghavn9lqi0h4lwf9ifkcv3zikbi176mjg90zw0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmag = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xmag";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmag-1.0.7.tar.xz";
      sha256 = "0qblrqrhxml2asgbck53a1v7c4y7ap7jcyqjg500h1i7bb63d680";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmessage = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xmessage";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmessage-1.0.7.tar.xz";
      sha256 = "0mh3lclzh82l4wkwg1d9gflnm1irjydihg30gqfxcwmpl2vwqgvh";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmodmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xmodmap";
    version = "1.0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmodmap-1.0.11.tar.xz";
      sha256 = "10byhzdfv1xckqc3d2v52xg1ggxn5j806x4450l3ig5hyxl82bws";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmore = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xmore";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmore-1.0.4.tar.xz";
      sha256 = "16havfffngvx5kc9lam8rhsdfabsj1rsv4g49z346knyq7dn1dby";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgcffiles = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xorg-cf-files";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/xorg-cf-files-1.0.8.tar.xz";
      sha256 = "1f8primgb6qw3zy7plbsj4a1kdhdqb04xpdys520zaygxxfra23l";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgdocs = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xorg-docs";
    version = "1.7.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-docs-1.7.3.tar.xz";
      sha256 = "1vyxpjcv8z5r5f5iza726ahzzwdapbbkxzv1b6w5izyrnppg58i8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgproto = callPackage ({ stdenv, pkg-config, fetchurl, libXt, python3, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xorgproto";
    version = "2024.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xorgproto-2024.1.tar.xz";
      sha256 = "0nfbbi4j130m2gxzp20hp642xizbbl68jpbzahiq8nw183yja8ip";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "applewmproto" "bigreqsproto" "compositeproto" "damageproto" "dmxproto" "dpmsproto" "dri2proto" "dri3proto" "evieproto" "fixesproto" "fontcacheproto" "fontsproto" "glproto" "inputproto" "kbproto" "lg3dproto" "presentproto" "printproto" "randrproto" "recordproto" "renderproto" "resourceproto" "scrnsaverproto" "trapproto" "videoproto" "windowswmproto" "xcalibrateproto" "xcmiscproto" "xextproto" "xf86bigfontproto" "xf86dgaproto" "xf86driproto" "xf86miscproto" "xf86rushproto" "xf86vidmodeproto" "xineramaproto" "xproto" "xproxymngproto" "xwaylandproto" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgserver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, openssl, libX11, libXau, libxcb, xcbutil, xcbutilwm, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, libXdmcp, libXfixes, libxkbfile, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xorg-server";
    version = "21.1.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xserver/xorg-server-21.1.13.tar.xz";
      sha256 = "033lvjihidc68v08izrr63va8jhkfmzcjg0d6rm26wizjkah4nml";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto openssl libX11 libXau libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-server" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgsgmldoctools = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xorg-sgml-doctools";
    version = "1.12.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-sgml-doctools-1.12.1.tar.xz";
      sha256 = "0vvdnl1x82mr2phcq9z6dg94mas56zdmbm6lmkaqjkkbf3058p8a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xorg-sgml-doctools" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xpr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xpr";
    version = "1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xpr-1.2.0.tar.xz";
      sha256 = "1hyf6mc2l7lzkf21d5j4z6glg9y455hlsg8lv2lz028k6gw0554b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xprop = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xprop";
    version = "1.2.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xprop-1.2.7.tar.xz";
      sha256 = "0pw2iv7dcy2xq5fh3427nx88pjj9d9rry3930qj1c6mricaf6dj4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrandr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr, libXrender, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xrandr";
    version = "1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrandr-1.5.2.tar.xz";
      sha256 = "0h7jy4c5zgrr06fimnnxhy5ba782b1n4aik29g6bln4h1mwy9gn8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXrandr libXrender ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xrdb";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrdb-1.2.2.tar.xz";
      sha256 = "1x1ka0zbcw66a06jvsy92bvnsj9vxbvnq1hbn1az4f0v4fmzrx9i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrefresh = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xrefresh";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrefresh-1.1.0.tar.xz";
      sha256 = "0pwb5c9g3xxs70gc35hahxq2ky8261pw9n04j01a6dffbqnmkv99";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXmu, xorgproto, libXxf86misc, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xset";
    version = "1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xset-1.2.5.tar.xz";
      sha256 = "0bsyyx3k32k9vpb8x3ks7hlfr03nm0i14fv3cg6n4f2vcdajsscz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXmu xorgproto libXxf86misc ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xsetroot = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xbitmaps, libXcursor, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xsetroot";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xsetroot-1.1.3.tar.xz";
      sha256 = "1l9qcv4mldj70slnmfg56nv7yh9j9ca1x795bl26whmlkrdb90b0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xbitmaps libXcursor libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xsm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXaw, xorgproto, libXt, wrapWithXFileSearchPathHook, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xsm";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xsm-1.0.6.tar.xz";
      sha256 = "1kk398lbwyag8dljfmjfn4psdwmh66yhvab85xckf306qrscfk5p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libICE libSM libX11 libXaw xorgproto libXt ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xstdcmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xstdcmap";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xstdcmap-1.0.5.tar.xz";
      sha256 = "1061b95j08mlwpadyilmpbzfgmm08z69k8nrkbn9k11rg7ilfn1n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xtrans = callPackage ({ stdenv, pkg-config, fetchurl, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xtrans";
    version = "1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/xtrans-1.5.0.tar.xz";
      sha256 = "1gdiiw64p279a1x033w7i002myry9v75pwmc1gsdpzbbd41vg90v";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ "xtrans" ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xtrap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXt, libXTrap, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xtrap";
    version = "1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xtrap-1.0.3.tar.bz2";
      sha256 = "0sqm4j1zflk1s94iq4waa70hna1xcys88v9a70w0vdw66czhvj2j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXt libXTrap ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xvinfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXv, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xvinfo";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xvinfo-1.1.5.tar.xz";
      sha256 = "0164qpbjmxxa1rbvh6ay1iz2qnp9hl1745k9pk6195kdnbn73piy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXv ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xwd";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwd-1.0.9.tar.xz";
      sha256 = "0gxx3y9zlh13jgwkayxljm6i58ng8jc1xzqv2g8s7d3yjj21n4nw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxkbfile libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwininfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxcb, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xwininfo";
    version = "1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwininfo-1.1.6.tar.xz";
      sha256 = "0gr5m4lyvkil3cl63zf0sw7bq5qgraqrnvddk6xgk3a42xy8j61m";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxcb xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwud = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, testers }: stdenv.mkDerivation (finalAttrs: {
    pname = "xwud";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwud-1.0.6.tar.xz";
      sha256 = "1zhsih1l3x1038fi1wi9npvfnn8j7580ca73saixjg5sbv8qq134";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    meta = {
      pkgConfigModules = [ ];
      platforms = lib.platforms.unix;
    };
  })) {};

}
