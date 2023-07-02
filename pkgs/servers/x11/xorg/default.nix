# THIS IS A GENERATED FILE.  DO NOT EDIT!
{ lib, pixman }:

self: with self; {

  inherit pixman;

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  appres = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXt }: stdenv.mkDerivation {
    pname = "appres";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/appres-1.0.6.tar.xz";
      sha256 = "02sr4f1bm3y1w24gsvjfzvbpac1kgkq27v1s68q87bd1l3i5f8lb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  bdftopcf = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "bdftopcf";
    version = "1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xorg.freedesktop.org/archive/individual/util/bdftopcf-1.1.1.tar.xz";
      sha256 = "026rzs92h9jsc7r0kvvyvwhm22q0805gp38rs14x6ghg7kam7j8i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  bitmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xbitmaps, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "bitmap";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/bitmap-1.1.0.tar.xz";
      sha256 = "141nhfmrg14axvix2mc34vfs07gmki3k14qq1vqy7v7f5yf8g1lf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw xbitmaps libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  editres = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "editres";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/editres-1.0.8.tar.xz";
      sha256 = "1ydn32x9qh2zkn90w6nfv33gcq75z67w93bakkykadl8n7zmvkw3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  encodings = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    pname = "encodings";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/encodings-1.0.7.tar.xz";
      sha256 = "193hxaygxy2msmf8cyps8jdi0kxga84hj47qv7diqlhn7gsajf9s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobe100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobe75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopia100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopia75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontadobeutopiatype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontalias = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontarabicmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbh75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhlucidatypewriter75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhttf = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbhtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream100dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstream75dpi = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamspeedo = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontbitstreamtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcronyxcyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontcursormisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdaewoomisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontdecmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontibmtype1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontisasmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontjismisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmicromisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmisccyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscethiopic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmeltho = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmiscmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontmuttmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontschumachermisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontscreencyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsonymisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontsunmisc = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fonttosfnt = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto }: stdenv.mkDerivation {
    pname = "fonttosfnt";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/fonttosfnt-1.2.2.tar.bz2";
      sha256 = "0r1s43ypy0a9z6hzdq5y02s2acj965rax4flwdyylvc54ppv86qs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontutil = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "font-util";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-util-1.4.0.tar.xz";
      sha256 = "0z8gsi0bz5nnpsl008fyb4isrkrqrmhxjar5ywwpx30j83wlnwlz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontwinitzkicyrillic = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, bdftopcf, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  fontxfree86type1 = callPackage ({ stdenv, pkg-config, fetchurl, fontutil, mkfontscale }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  gccmakedep = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "gccmakedep";
    version = "1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/gccmakedep-1.0.3.tar.bz2";
      sha256 = "1r1fpy5ni8chbgx7j5sz0008fpb6vbazpy1nifgdhgijyzqxqxdj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  iceauth = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto }: stdenv.mkDerivation {
    pname = "iceauth";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/iceauth-1.0.9.tar.xz";
      sha256 = "01cc816fvdkkfcnqnyvgcshcip2jzjivwa8hzdvsz0snak5xzf9c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  ico = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  imake = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "imake";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/imake-1.0.8.tar.bz2";
      sha256 = "00m7l90ws72k1qm101sd2rx92ckd50cszyng5d4dd77jncbf9lmq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libAppleWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libFS = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans }: stdenv.mkDerivation {
    pname = "libFS";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libFS-1.0.8.tar.bz2";
      sha256 = "03xxyvpfa3rhqcld4p2chkil482jn9cp80hj17jdybcv2hkkgqf8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libICE = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans }: stdenv.mkDerivation {
    pname = "libICE";
    version = "1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libICE-1.0.10.tar.bz2";
      sha256 = "0j638yvmyna2k4mz465jywgdybgdchdqppfx6xfazg7l5khxr1kg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libSM = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libuuid, xorgproto, xtrans }: stdenv.mkDerivation {
    pname = "libSM";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libSM-1.2.3.tar.bz2";
      sha256 = "1fwwfq9v3sqmpzpscymswxn76xhxnysa24pfim1mcpxhvjcl89id";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libuuid xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libWindowsWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libX11 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpthreadstubs, libxcb, xtrans }: stdenv.mkDerivation {
    pname = "libX11";
    version = "1.8.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libX11-1.8.6.tar.xz";
      sha256 = "1jawl8zp1h7hdmxx1sc6kmxkki187d9yixr2l03ai6wqqry5nlsr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpthreadstubs libxcb xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXScrnSaver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    pname = "libXScrnSaver";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXScrnSaver-1.2.3.tar.bz2";
      sha256 = "1y4vx1vabg7j9hamp0vrfrax5b0lmgm3h0lbgbb3hnkv3dd0f5zr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXTrap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXt }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "libXau";
    version = "1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXau-1.0.9.tar.bz2";
      sha256 = "1v3krc6x0zliaa66qq1bf9j60x5nqfy68v8axaiglxpnvgqcpy6c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXaw = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXmu, libXpm, libXt }: stdenv.mkDerivation {
    pname = "libXaw";
    version = "1.0.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXaw-1.0.14.tar.bz2";
      sha256 = "13kg59r3086383g1dyhnwxanhp2frssh9062mrgn34nzlf7gkbkn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXmu libXpm libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXcomposite = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes }: stdenv.mkDerivation {
    pname = "libXcomposite";
    version = "0.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcomposite-0.4.5.tar.bz2";
      sha256 = "13sfcglvz87vl58hd9rszwr73z0z4nwga3c12rfh7f5s2ln8l8dk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXcursor = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes, libXrender }: stdenv.mkDerivation {
    pname = "libXcursor";
    version = "1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcursor-1.2.0.tar.bz2";
      sha256 = "10l7c9fm0jmpkm9ab9dz8r6m1pr87vvgqjnbx1psz50h4pwfklrs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXdamage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes }: stdenv.mkDerivation {
    pname = "libXdamage";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdamage-1.1.5.tar.bz2";
      sha256 = "0igaw2akjf712y3rv7lx473jigxmcv9rs9y8sbrvbhya8f30cd5p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXdmcp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "libXdmcp";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdmcp-1.1.3.tar.bz2";
      sha256 = "0ab53h0rkq721ihk5hi469x500f3pgbkm1wy01yf24x5m923nli0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXext = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    pname = "libXext";
    version = "1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXext-1.3.4.tar.bz2";
      sha256 = "0azqxllcsfxc3ilhz6kwc6x7m8wc477p59ir9p0yrsldx766zbar";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfixes = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    pname = "libXfixes";
    version = "6.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfixes-6.0.0.tar.bz2";
      sha256 = "0k2v4i4r24y3kdr5ici1qqhp69djnja919xfqp54c2rylm6s5hd7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXfont2 = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib }: stdenv.mkDerivation {
    pname = "libXfont2";
    version = "2.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfont2-2.0.5.tar.bz2";
      sha256 = "0gmm20p3qq23pd2bhc5rsxil60wqvj9xi7l1nh55q8gp3hhnyz5a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc xorgproto freetype xtrans zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXft = callPackage ({ stdenv, pkg-config, fetchurl, fontconfig, freetype, libX11, xorgproto, libXrender }: stdenv.mkDerivation {
    pname = "libXft";
    version = "2.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXft-2.3.6.tar.xz";
      sha256 = "08ihq0in7iy5bwrx71nhnlkj7k1ic34brjcqs2wbnf69kwqyg9k0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ fontconfig freetype libX11 xorgproto libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXfixes }: stdenv.mkDerivation {
    pname = "libXi";
    version = "1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXi-1.8.tar.bz2";
      sha256 = "005sicls6faddkcj449858i9xz1nafy70y26frsk7iv1d9283l9f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXinerama = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    pname = "libXinerama";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXinerama-1.1.4.tar.bz2";
      sha256 = "086p0axqj57nvkaqa6r00dnr9kyrn1m8blgf0zjy25zpxkbxn200";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXmu = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt }: stdenv.mkDerivation {
    pname = "libXmu";
    version = "1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXmu-1.1.3.tar.bz2";
      sha256 = "0cdpqnx6258i4l6qhphvkdiyspysg0i5caqjy820kp63wwjk4d4w";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXau, libXext }: stdenv.mkDerivation {
    pname = "libXp";
    version = "1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXp-1.0.3.tar.bz2";
      sha256 = "0mwc2jwmq03b1m9ihax5c6gw2ln8rc70zz4fsj3kb7440nchqdkz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXau libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXpm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt, gettext }: stdenv.mkDerivation {
    pname = "libXpm";
    version = "3.5.15";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpm-3.5.15.tar.xz";
      sha256 = "1hfivygzrzpq81vg9z2l46pd5nrzm326k6z3cfw6syiibin91fv0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXpresent = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    pname = "libXpresent";
    version = "1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpresent-1.0.0.tar.bz2";
      sha256 = "12kvvar3ihf6sw49h6ywfdiwmb8i1gh8wasg1zhzp6hs2hay06n1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXrandr = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXrender }: stdenv.mkDerivation {
    pname = "libXrandr";
    version = "1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrandr-1.5.2.tar.bz2";
      sha256 = "08z0mqywrm7ij8bxlfrx0d2wy6kladdmkva1nw5k6qix82z0xsla";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXrender = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    pname = "libXrender";
    version = "0.9.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrender-0.9.10.tar.bz2";
      sha256 = "0j89cnb06g8x79wmmnwzykgkkfdhin9j7hjpvsxwlr3fz1wmjvf0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXres = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    pname = "libXres";
    version = "1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXres-1.2.1.tar.bz2";
      sha256 = "049b7dk6hx47161hg47ryjrm6pwsp27r5pby05b0wqb1pcggprmn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXt = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto, libSM, libX11 }: stdenv.mkDerivation {
    pname = "libXt";
    version = "1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXt-1.2.1.tar.bz2";
      sha256 = "0q1x7842r8rcn2m0q4q9f69h4qa097fyizs8brzx5ns62s7w1737";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto libSM libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXtst = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi }: stdenv.mkDerivation {
    pname = "libXtst";
    version = "1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXtst-1.2.3.tar.bz2";
      sha256 = "012jpyj7xfm653a9jcfqbzxyywdmwb2b5wr1dwylx14f3f54jma6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXi ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    pname = "libXv";
    version = "1.0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXv-1.0.11.tar.bz2";
      sha256 = "125hn06bd3d8y97hm2pbf5j55gg4r2hpd3ifad651i4sr7m16v6j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXvMC = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXv }: stdenv.mkDerivation {
    pname = "libXvMC";
    version = "1.0.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXvMC-1.0.13.tar.xz";
      sha256 = "0z35xqna3dnrfxgn9aa1y6jx7mrwsn8vi8dcwm3sg23qx9nvx7ha";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXv ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86dga = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    pname = "libXxf86dga";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86dga-1.1.5.tar.bz2";
      sha256 = "00vjvcdlc1sga251jkxn6gkxmx9h5n290ffxxpa40qbca1gvr61b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86misc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libXxf86vm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libdmx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    pname = "libdmx";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libdmx-1.1.4.tar.bz2";
      sha256 = "0hvjfhrcym770cr0zpqajdy3cda30aiwbjzv16iafkqkbl090gr5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libfontenc = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, zlib }: stdenv.mkDerivation {
    pname = "libfontenc";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libfontenc-1.1.4.tar.bz2";
      sha256 = "0y90170dp8wsidr1dzza0grxr1lfh30ji3b5vkjz4j6x1n0wxz1c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libpciaccess = callPackage ({ stdenv, pkg-config, fetchurl, hwdata, zlib }: stdenv.mkDerivation {
    pname = "libpciaccess";
    version = "0.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libpciaccess-0.16.tar.bz2";
      sha256 = "12glp4w1kgvmqn89lk19cgr6jccd3awxra4dxisp7pagi06rsk11";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ hwdata zlib ];
    configureFlags = [ "--with-pciids-path=${hwdata}/share/hwdata" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libpthreadstubs = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "libpthread-stubs";
    version = "0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/libpthread-stubs-0.4.tar.bz2";
      sha256 = "0cz7s9w8lqgzinicd4g36rjg08zhsbyngh0w68c3np8nlc8mkl74";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxcb = callPackage ({ stdenv, pkg-config, fetchurl, libxslt, libpthreadstubs, libXau, xcbproto, libXdmcp, python3 }: stdenv.mkDerivation {
    pname = "libxcb";
    version = "1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxcb-1.14.tar.xz";
      sha256 = "0d2chjgyn5lr9sfhacfvqgnj9l9faz11vn322a06jd6lk3dxcpm5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libxslt libpthreadstubs libXau xcbproto libXdmcp ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxcvt = callPackage ({ stdenv, pkg-config, fetchurl, meson, ninja }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxkbfile = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    pname = "libxkbfile";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxkbfile-1.1.0.tar.bz2";
      sha256 = "1irq9crvscd3yb8sr802dhvvfr35jdy1n2yz094xplmd42mbv3bm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  libxshmfence = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "libxshmfence";
    version = "1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxshmfence-1.3.tar.bz2";
      sha256 = "1ir0j92mnd1nk37mrv9bz5swnccqldicgszvfsh62jd14q6k115q";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  listres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    pname = "listres";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/listres-1.0.5.tar.xz";
      sha256 = "17fwfjh0xrvg7jj4h32pa8ns4hq4r11z61kh2xsqvsyjwyxh0anf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  lndir = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "lndir";
    version = "1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/lndir-1.0.4.tar.xz";
      sha256 = "11syg5hx3f7m1d2p7zw717lryk819h6wk8h4vmapfdxvsflkfd1y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  luit = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "luit";
    version = "20190106";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://invisible-mirror.net/archives/luit/luit-20190106.tgz";
      sha256 = "081rrajj5hpgx3pvm43grqzscnq5kl320q0wq6zzhf6wrijhz41b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  makedepend = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    pname = "makedepend";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/makedepend-1.0.6.tar.bz2";
      sha256 = "072h9nzh8s5vqfz35dli4fba36fnr219asjrb7p89n8ph0paan6m";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  mkfontscale = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto, zlib }: stdenv.mkDerivation {
    pname = "mkfontscale";
    version = "1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/mkfontscale-1.2.2.tar.xz";
      sha256 = "1i6mw97r2s1rb6spjj8fbdsgw6197smaqq2haqgnwhz73xdzpqwa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  oclock = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, libXext, libXmu, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  sessreg = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  setxkbmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, libXrandr }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  smproxy = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libXmu, libXt }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  transset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  twm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXext, libXmu, xorgproto, libXrandr, libXt }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  utilmacros = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "util-macros";
    version = "1.19.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/util-macros-1.19.3.tar.bz2";
      sha256 = "0w8ryfqylprz37zj9grl4jzdsqq67ibfwq5raj7vm1i7kmp2x08g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  viewres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  x11perf = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXft, libXmu, xorgproto, libXrender }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xauth = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXext, libXmu, xorgproto }: stdenv.mkDerivation {
    pname = "xauth";
    version = "1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xauth-1.1.2.tar.xz";
      sha256 = "0072ivzn4z59ysanz838nh8s4mcmdsx6q9xkvlfysv2k37ynmfkq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXau libXext libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xbacklight = callPackage ({ stdenv, pkg-config, fetchurl, libxcb, xcbutil }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xbitmaps = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "xbitmaps";
    version = "1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xbitmaps-1.1.2.tar.bz2";
      sha256 = "1vh73sc13s7w5r6gnc6irca56s7998bja7wgdivkfn8jccawgw5r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcalc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbproto = callPackage ({ stdenv, pkg-config, fetchurl, python3 }: stdenv.mkDerivation {
    pname = "xcb-proto";
    version = "1.14.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xcb-proto-1.14.1.tar.xz";
      sha256 = "1hzwazgyywd9mz4mjj1yv8ski27qqx7ypmyr27m39hrajyddsjph";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz";
      sha256 = "04p54r0zjc44fpw1hdy4rhygv37sx2vr2lllxjihykz5v2xkpgjs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilcursor = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutilimage, xcbutilrenderutil, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util-cursor";
    version = "0.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2";
      sha256 = "0krr4rcw6r42cncinzvzzdqnmxk3nrgpnadyg2h8k9x10q3hm885";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutilimage xcbutilrenderutil xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilerrors = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbproto, xorgproto, m4, python3 }: stdenv.mkDerivation {
    pname = "xcb-util-errors";
    version = "1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-errors-1.0.1.tar.xz";
      sha256 = "0mzkh3xj1n690dw8hrdhyjykd71ib0ls9n5cgf9asna2k1xwha2n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 python3 ];
    buildInputs = [ gperf libxcb xcbproto xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilimage = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutil, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util-image";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.1.tar.xz";
      sha256 = "0g8dwknrlz96k176qxh8ar84x9kpppci9b978zyp24nvvbjqxbfc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutil xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilkeysyms = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util-keysyms";
    version = "0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.1.tar.xz";
      sha256 = "0f66snk179hmp8ppgv1zp9y7pl1vzn52znpikm1fsaj1ji90l9kw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilrenderutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util-renderutil";
    version = "0.3.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.10.tar.xz";
      sha256 = "1fh4dnlwlqyccrhmmwlv082a7mxc7ss7vmzmp7xxp39dwbqd859y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcbutilwm = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    pname = "xcb-util-wm";
    version = "0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.xz";
      sha256 = "02wai17mxfbvlnj4l4bjbvah97rccdivzvd7mrznhr32s0hlxhv2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xclock = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXft, libxkbfile, libXmu, xorgproto, libXrender, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcmsdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11 }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcompmgr = callPackage ({ stdenv, pkg-config, fetchurl, libXcomposite, libXdamage, libXext, libXfixes, xorgproto, libXrender }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xconsole = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xconsole";
    version = "1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xconsole-1.0.8.tar.xz";
      sha256 = "195vhqjrzjf4kkzmy0kx50n1bv2kj9fg7mi18mm2w3p4d3q6ljkv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcursorgen = callPackage ({ stdenv, pkg-config, fetchurl, libpng, libX11, libXcursor, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xcursorthemes = callPackage ({ stdenv, pkg-config, fetchurl, libXcursor }: stdenv.mkDerivation {
    pname = "xcursor-themes";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xcursor-themes-1.0.6.tar.bz2";
      sha256 = "16a96li0s0ggg60v7f6ywxmsrmxdfizcw55ccv7sp4qjfisca7pf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXcursor ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXaw, libXdmcp, libXext, libXft, libXinerama, libXmu, libXpm, xorgproto, libXrender, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xdm";
    version = "1.1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdm-1.1.14.tar.xz";
      sha256 = "0prx5h0xmv08yvm0axzh74a90cyc1s1dcv98jpjwjzkr6rbg56ry";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdpyinfo = callPackage ({ stdenv, pkg-config, fetchurl, libdmx, libX11, libxcb, libXcomposite, libXext, libXi, libXinerama, xorgproto, libXrender, libXtst, libXxf86dga, libXxf86misc, libXxf86vm }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xdriinfo = callPackage ({ stdenv, pkg-config, fetchurl, libGL, xorgproto, libX11 }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xev = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr }: stdenv.mkDerivation {
    pname = "xev";
    version = "1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xev-1.2.5.tar.xz";
      sha256 = "1hbfwcnbyz4w13fbhnghl0vdhf6w9f9pb7jgjwrhykkii51ilin9";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXrandr ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xeyes = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxcb, libXext, libXi, libXmu, xorgproto, libXrender, libXt }: stdenv.mkDerivation {
    pname = "xeyes";
    version = "1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xeyes-1.2.0.tar.bz2";
      sha256 = "1nxn443pfhddmwl59wplpjkslhlyfk307qx18nrimvvb2hipx8gq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxcb libXext libXi libXmu xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputevdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, udev, mtdev, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputjoystick = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-input-joystick";
    version = "1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-joystick-1.6.3.tar.bz2";
      sha256 = "1awfq496d082brgjbr60lhm6jvr9537rflwxqdfqwfzjy3n6jxly";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputkeyboard = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-input-keyboard";
    version = "1.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-keyboard-1.9.0.tar.bz2";
      sha256 = "12032yg412kyvnmc5fha1in7mpi651d8sa1bk4138s2j2zr01jgp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputlibinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libinput, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-input-libinput";
    version = "1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-libinput-1.2.0.tar.bz2";
      sha256 = "1xk9b05csndcgcj8kbb6fkwa3c7njzzxc6qvz9bvy77y2k2s63gq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libinput xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-input-mouse";
    version = "1.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-mouse-1.9.3.tar.bz2";
      sha256 = "1iawr1wyl2qch1mqszcs0s84i92mh4xxprflnycbw1adc18b7v4k";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputsynaptics = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, libX11, libXi, xorgserver, libXtst }: stdenv.mkDerivation {
    pname = "xf86-input-synaptics";
    version = "1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-synaptics-1.9.1.tar.bz2";
      sha256 = "0xhm03qywwfgkpfl904d08lx00y28m1b6lqmks5nxizixwk3by3s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libevdev libX11 libXi xorgserver libXtst ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvmmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, udev, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-input-vmmouse";
    version = "13.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2";
      sha256 = "06ckn4hlkpig5vnivl0zj8a7ykcgvrsj8b3iccl1pgn1gaamix8a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto udev xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86inputvoid = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto }: stdenv.mkDerivation {
    pname = "xf86-input-void";
    version = "1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-void-1.4.1.tar.bz2";
      sha256 = "171k8b8s42s3w73l7ln9jqwk88w4l7r1km2blx1vy898c854yvpr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgserver xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoamdgpu = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoapm = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoark = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-ark";
    version = "0.7.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ark-0.7.5.tar.bz2";
      sha256 = "07p5vdsj2ckxb6wh02s61akcv4qfg6s1d5ld3jn3lfaayd3f1466";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoast = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-ast";
    version = "1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ast-1.1.5.tar.bz2";
      sha256 = "1pm2cy81ma7ldsw0yfk28b33h9z2hcj5rccrxhfxfgvxsiavrnqy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoati = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-ati";
    version = "5eba006e4129e8015b822f9e1d2f1e613e252cda";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-ati/-/archive/5eba006e4129e8015b822f9e1d2f1e613e252cda/xf86-video-ati-5eba006e4129e8015b822f9e1d2f1e613e252cda.tar.bz2";
      sha256 = "0gmymk8207fd9rjliq05l2gvx220h432rj3h75hv2ylr3k9vmp2b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto mesa libGL libdrm udev libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videochips = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-chips";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-chips-1.4.0.tar.bz2";
      sha256 = "1gqzy7q9v824m7hqkbbmncxg082zm0d4mafgc97c4skyiwgf9wq7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videocirrus = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-cirrus";
    version = "1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-cirrus-1.5.3.tar.bz2";
      sha256 = "1asifc6ld2g9kap15vfhvsvyl69lj7pw3d9ra9mi4najllh7pj7d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videodummy = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-dummy";
    version = "0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-dummy-0.3.8.tar.bz2";
      sha256 = "1fcm9vwgv8wnffbvkzddk4yxrh3kc0np6w65wj8k88q7jf3bn4ip";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videofbdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videogeode = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-geode";
    version = "2.11.19";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-geode-2.11.19.tar.bz2";
      sha256 = "0zn9gb49grds5mcs1dlrx241k2w1sgqmx4i5x7v6159xxqhlqsf6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglide = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoglint = callPackage ({ stdenv, pkg-config, fetchurl, libpciaccess, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-i128";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-i128-1.4.0.tar.bz2";
      sha256 = "1snhpv1igrhifcls3r498kjd14ml6x2xvih7zk9xlsd1ymmhlb4g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoi740 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videointel = callPackage ({ stdenv, pkg-config, fetchurl, cairo, xorgproto, libdrm, libpng, udev, libpciaccess, libX11, xcbutil, libxcb, libXcursor, libXdamage, libXext, libXfixes, xorgserver, libXrandr, libXrender, libxshmfence, libXtst, libXvMC }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videomga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoneomagic = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-neomagic";
    version = "1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-neomagic-1.3.0.tar.bz2";
      sha256 = "0r4h673kw8fl7afc30anwbjlbhp82mg15fvaxf470xg7z983k0wk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonewport = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonouveau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videonv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-nv";
    version = "2.1.21";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-nv-2.1.21.tar.bz2";
      sha256 = "0bdk3pc5y0n7p53q4gc2ff7bw16hy5hwdjjxkm5j3s7hdyg6960z";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoomap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoopenchrome = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver, libXvMC }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoqxl = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videor128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videorendition = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videos3virge = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-s3virge";
    version = "1.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-s3virge-1.11.0.tar.bz2";
      sha256 = "06d1v5s7xf00y18x12cz11sk00rgn0yq95w66kmgzy465pzxvj84";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosavage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-savage";
    version = "2.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-savage-2.3.9.tar.bz2";
      sha256 = "11pcrsdpdrwk0mrgv83s5nsx8a9i4lhmivnal3fjbrvi3zdw94rc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosiliconmotion = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-siliconmotion";
    version = "1.7.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.9.tar.bz2";
      sha256 = "1g2r6gxqrmjdff95d42msxdw6vmkg2zn5sqv0rxd420iwy8wdwyh";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosis = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-sis";
    version = "0.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sis-0.11.0.tar.bz2";
      sha256 = "0srvrhydjnynfb7b1s145rgmsk4f71iz0ag4icpmb05944d90xr1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosisusb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosuncg6 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunffb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videosunleo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotdfx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videotrident = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videov4l = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovboxvideo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-vboxvideo";
    version = "1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vboxvideo-1.0.0.tar.bz2";
      sha256 = "195z1js3i51qgxvhfw4bxb4dw3jcrrx2ynpm2y3475dypjzs7dkz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovesa = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-vesa";
    version = "2.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vesa-2.5.0.tar.bz2";
      sha256 = "0nf6ai74c60xk96kgr8q9mx6lrxm5id3765ws4d801irqzrj85hz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovmware = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-vmware";
    version = "13.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vmware-13.3.0.tar.bz2";
      sha256 = "0v06qhm059klq40m2yx4wypzb7h53aaassbjfmm6clcyclj1k5s7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess libX11 libXext xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videovoodoo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    pname = "xf86-video-voodoo";
    version = "1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-voodoo-1.2.5.tar.bz2";
      sha256 = "1s6p7yxmi12q4y05va53rljwyzd6ry492r1pgi7wwq6cznivhgly";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videowsfb = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xf86videoxgi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, fontconfig, libXaw, libXft, libXmu, xorgproto, libXrender, libXt, gettext, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfontsel = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xfontsel";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfontsel-1.1.0.tar.xz";
      sha256 = "1d6ifx6sw97mmr00bhfakyx2f94w14yswxc68sw49zmvawrjq18p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfs = callPackage ({ stdenv, pkg-config, fetchurl, libXfont2, xorgproto, xtrans }: stdenv.mkDerivation {
    pname = "xfs";
    version = "1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfs-1.2.1.tar.xz";
      sha256 = "1rn1l76z4l133491wb1klixbwb8az5cnrzwx37fb3vnpmplc72ix";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXfont2 xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xfsinfo = callPackage ({ stdenv, pkg-config, fetchurl, libFS, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xgamma = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXxf86vm }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xgc = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xhost = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXmu, xorgproto, gettext }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinit = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi, libXinerama, libXrandr }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbcomp = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto }: stdenv.mkDerivation {
    pname = "xkbcomp";
    version = "1.4.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbcomp-1.4.6.tar.xz";
      sha256 = "164fqnpq80vbl7693x82h38kvxcdf668vggpg9439q21xw8xcl7s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbevd = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbprint = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkbutils = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXaw, libXt }: stdenv.mkDerivation {
    pname = "xkbutils";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbutils-1.0.5.tar.xz";
      sha256 = "197f4pgw3jdnlp7sj37f3xf15ayad20sl7vvg2rvx0j5qplsi97n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkeyboardconfig = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, python3 }: stdenv.mkDerivation {
    pname = "xkeyboard-config";
    version = "2.33";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.33.tar.bz2";
      sha256 = "1g6kn7l0mixw50kgn7d97gwv1990c5rczr2x776q3xywss8dfzv5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xkill = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xload = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, gettext, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xload";
    version = "1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xload-1.1.4.tar.xz";
      sha256 = "0c9h6w4bd1q3k4cy8v56sc3v9cg94cpg3xr057sf096v428vjil3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config gettext wrapWithXFileSearchPathHook ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsatoms = callPackage ({ stdenv, pkg-config, fetchurl, libxcb }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsclients = callPackage ({ stdenv, pkg-config, fetchurl, libxcb }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xlsfonts = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    pname = "xlsfonts";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsfonts-1.0.7.tar.xz";
      sha256 = "0r84wp4352hbfcaybqp2khipm40293byvrfyrlslrd37m52njwkv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmag = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmessage = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xmessage";
    version = "1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmessage-1.0.6.tar.xz";
      sha256 = "04kahkk3kd6p1xlzf0jwfgnrb5z2r3y55q3p12b6n59py52wbsnj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmodmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xmore = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xmore";
    version = "1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmore-1.0.3.tar.bz2";
      sha256 = "06r514p30v87vx00ddlck9mwazaqk9bx08ip866p1mw2a46iwjk4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgcffiles = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "xorg-cf-files";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/xorg-cf-files-1.0.7.tar.bz2";
      sha256 = "0233jyjxjkhlar03vp8l5sm3iq6354izm3crk41h5291pgap39vl";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgdocs = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "xorg-docs";
    version = "1.7.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-docs-1.7.1.tar.bz2";
      sha256 = "0jrc4jmb4raqawx0j9jmhgasr0k6sxv0bm2hrxjh9hb26iy6gf14";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgproto = callPackage ({ stdenv, pkg-config, fetchurl, libXt, python3 }: stdenv.mkDerivation {
    pname = "xorgproto";
    version = "2021.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xorgproto-2021.5.tar.bz2";
      sha256 = "05d0kib351qmnlfimaznaw0220fr0ym7fx2gn9h2jqxxilxncbxa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgserver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, openssl, libX11, libXau, libxcb, xcbutil, xcbutilwm, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, libXdmcp, libXfixes, libxkbfile }: stdenv.mkDerivation {
    pname = "xorg-server";
    version = "21.1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xserver/xorg-server-21.1.8.tar.xz";
      sha256 = "0lmimvaw9x0ymdhjfqsrbx689bcapy8c24ajw9705j2harrxpaiq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto openssl libX11 libXau libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xorgsgmldoctools = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "xorg-sgml-doctools";
    version = "1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-sgml-doctools-1.11.tar.bz2";
      sha256 = "0k5pffyi5bx8dmfn033cyhgd3gf6viqj3x769fqixifwhbgy2777";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xpr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
    pname = "xpr";
    version = "1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xpr-1.1.0.tar.xz";
      sha256 = "1iaphm96kha6bzz34cj82r2lp5hrdpqwdca04iij4rinflab3fx0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xprop = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    pname = "xprop";
    version = "1.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xprop-1.2.6.tar.xz";
      sha256 = "0vjqnn42gscw1z2wdj24kdwjwvd7mw58pj0nm9203k1fn4jqa2sq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrandr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr, libXrender }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xrefresh = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    pname = "xrefresh";
    version = "1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrefresh-1.0.7.tar.xz";
      sha256 = "07hvfw3rdv8mzqmm9ax5z8kw544insdd152f2z8868ply8sxdwd9";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXmu, xorgproto, libXxf86misc }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xsetroot = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xbitmaps, libXcursor, libXmu, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xsm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXaw, xorgproto, libXt, wrapWithXFileSearchPathHook }: stdenv.mkDerivation {
    pname = "xsm";
    version = "1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xsm-1.0.5.tar.xz";
      sha256 = "0bgvwvj99yqivy4dyxrfa0anwvh5d634gz0w43zy8cn17ymgsc4w";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config wrapWithXFileSearchPathHook ];
    buildInputs = [ libICE libSM libX11 libXaw xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xstdcmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xtrans = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    pname = "xtrans";
    version = "1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/xtrans-1.4.0.tar.bz2";
      sha256 = "0wyp0yc6gi72hwc3kjmvm3vkj9p6s407cb6dxx37jh9wb68l8z1p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    strictDeps = true;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xtrap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXt, libXTrap }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xvinfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXv }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwininfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxcb, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

  # THIS IS A GENERATED FILE.  DO NOT EDIT!
  xwud = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
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
    meta.platforms = lib.platforms.unix;
  }) {};

}
