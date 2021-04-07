# THIS IS A GENERATED FILE.  DO NOT EDIT!
{ lib, newScope, pixman }:

lib.makeScope newScope (self: with self; {

  inherit pixman;

  appres = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXt }: stdenv.mkDerivation {
    name = "appres-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/appres-1.0.5.tar.bz2";
      sha256 = "0a2r4sxky3k7b3kdb5pbv709q9b5zi3gxjz336wl66f828vqkbgz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  bdftopcf = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "bdftopcf-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/bdftopcf-1.1.tar.bz2";
      sha256 = "18hiscgljrz10zjcws25bis32nyrg3hzgmiq6scrh7izqmgz0kab";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  bitmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xbitmaps, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    name = "bitmap-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/bitmap-1.0.9.tar.gz";
      sha256 = "0kzbv5wh02798l77y9y8d8sjkmzm9cvsn3rjh8a86v5waj50apsb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw xbitmaps libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  editres = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    name = "editres-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/editres-1.0.7.tar.bz2";
      sha256 = "04awfwmy3f9f0bchidc4ssbgrbicn5gzasg3jydpfnp5513d76h8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  encodings = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "encodings-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/encodings-1.0.5.tar.bz2";
      sha256 = "0caafx0yqqnqyvbalxhh3mb0r9v36xmcy5zjhygb2i508dhy35mx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontadobe100dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-adobe-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-100dpi-1.0.3.tar.bz2";
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontadobe75dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-adobe-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-75dpi-1.0.3.tar.bz2";
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontadobeutopia100dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-100dpi-1.0.4.tar.bz2";
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontadobeutopia75dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-75dpi-1.0.4.tar.bz2";
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontadobeutopiatype1 = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-adobe-utopia-type1-1.0.4.tar.bz2";
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontalias = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "font-alias-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-alias-1.0.3.tar.bz2";
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontarabicmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-arabic-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-arabic-misc-1.0.3.tar.bz2";
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbh100dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-100dpi-1.0.3.tar.bz2";
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbh75dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-75dpi-1.0.3.tar.bz2";
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbhlucidatypewriter100dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2";
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbhlucidatypewriter75dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2";
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbhttf = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-ttf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-ttf-1.0.3.tar.bz2";
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbhtype1 = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-bh-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bh-type1-1.0.3.tar.bz2";
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbitstream100dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-bitstream-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-100dpi-1.0.3.tar.bz2";
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbitstream75dpi = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-bitstream-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-75dpi-1.0.3.tar.bz2";
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontbitstreamtype1 = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-bitstream-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-bitstream-type1-1.0.3.tar.bz2";
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontcronyxcyrillic = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-cronyx-cyrillic-1.0.3.tar.bz2";
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontcursormisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-cursor-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-cursor-misc-1.0.3.tar.bz2";
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontdaewoomisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-daewoo-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-daewoo-misc-1.0.3.tar.bz2";
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontdecmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-dec-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-dec-misc-1.0.3.tar.bz2";
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontibmtype1 = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-ibm-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-ibm-type1-1.0.3.tar.bz2";
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontisasmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-isas-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-isas-misc-1.0.3.tar.bz2";
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontjismisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-jis-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-jis-misc-1.0.3.tar.bz2";
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmicromisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-micro-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-micro-misc-1.0.3.tar.bz2";
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmisccyrillic = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-misc-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-cyrillic-1.0.3.tar.bz2";
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmiscethiopic = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-misc-ethiopic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-ethiopic-1.0.3.tar.bz2";
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmiscmeltho = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-misc-meltho-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-meltho-1.0.3.tar.bz2";
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmiscmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-misc-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-misc-misc-1.1.2.tar.bz2";
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontmuttmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-mutt-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-mutt-misc-1.0.3.tar.bz2";
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontschumachermisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, fontutil, mkfontscale }: stdenv.mkDerivation {
    name = "font-schumacher-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-schumacher-misc-1.1.2.tar.bz2";
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf fontutil mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontscreencyrillic = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-screen-cyrillic-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-screen-cyrillic-1.0.4.tar.bz2";
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontsonymisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-sony-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-sony-misc-1.0.3.tar.bz2";
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontsunmisc = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-sun-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-sun-misc-1.0.3.tar.bz2";
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fonttosfnt = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto }: stdenv.mkDerivation {
    name = "fonttosfnt-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/fonttosfnt-1.2.1.tar.bz2";
      sha256 = "16r51h5wfy85wnbq3q8v8a184hb25c3ksjgix0mlcywdz7qkbj07";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontutil = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "font-util-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-util-1.3.1.tar.bz2";
      sha256 = "08drjb6cf84pf5ysghjpb4i7xkd2p86k3wl2a0jxs1jif6qbszma";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontwinitzkicyrillic = callPackage ({ stdenv, pkg-config, fetchurl, bdftopcf, mkfontscale }: stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-winitzki-cyrillic-1.0.3.tar.bz2";
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config bdftopcf mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  fontxfree86type1 = callPackage ({ stdenv, pkg-config, fetchurl, mkfontscale }: stdenv.mkDerivation {
    name = "font-xfree86-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/font/font-xfree86-type1-1.0.4.tar.bz2";
      sha256 = "0jp3zc0qfdaqfkgzrb44vi9vi0a8ygb35wp082yz7rvvxhmg9sya";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config mkfontscale ];
    buildInputs = [ ];
    configureFlags = [ "--with-fontrootdir=$(out)/lib/X11/fonts" ];
    meta.platforms = lib.platforms.unix;
  }) {};

  gccmakedep = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "gccmakedep-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/gccmakedep-1.0.3.tar.bz2";
      sha256 = "1r1fpy5ni8chbgx7j5sz0008fpb6vbazpy1nifgdhgijyzqxqxdj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  iceauth = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto }: stdenv.mkDerivation {
    name = "iceauth-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/iceauth-1.0.8.tar.bz2";
      sha256 = "1ik0mdidmyvy48hn8p2hwvf3535rf3m96hhf0mvcqrbj44x23vp6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  ico = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "ico-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/ico-1.0.5.tar.bz2";
      sha256 = "0gvpwfk9kvlfn631dgizc45qc2qqjn9pavdp2q7qb3drkvr64fyp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  imake = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "imake-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/imake-1.0.8.tar.bz2";
      sha256 = "00m7l90ws72k1qm101sd2rx92ckd50cszyng5d4dd77jncbf9lmq";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libAppleWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libAppleWM-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libAppleWM-1.4.1.tar.bz2";
      sha256 = "0r8x28n45q89x91mz8mv0zkkcxi8wazkac886fyvflhiv2y8ap2y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libFS = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans }: stdenv.mkDerivation {
    name = "libFS-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libFS-1.0.8.tar.bz2";
      sha256 = "03xxyvpfa3rhqcld4p2chkil482jn9cp80hj17jdybcv2hkkgqf8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libICE = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xtrans }: stdenv.mkDerivation {
    name = "libICE-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libICE-1.0.10.tar.bz2";
      sha256 = "0j638yvmyna2k4mz465jywgdybgdchdqppfx6xfazg7l5khxr1kg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libSM = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libuuid, xorgproto, xtrans }: stdenv.mkDerivation {
    name = "libSM-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libSM-1.2.3.tar.bz2";
      sha256 = "1fwwfq9v3sqmpzpscymswxn76xhxnysa24pfim1mcpxhvjcl89id";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libuuid xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libWindowsWM = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libWindowsWM-1.0.1.tar.bz2";
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libX11 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libxcb, xtrans }: stdenv.mkDerivation {
    name = "libX11-1.7.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libX11-1.7.0.tar.bz2";
      sha256 = "0m6bfwllr3pq2c00l51y62yiq15kphc8dw69zf67qhwmclxzkj1n";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libxcb xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXScrnSaver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libXScrnSaver-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXScrnSaver-1.2.3.tar.bz2";
      sha256 = "1y4vx1vabg7j9hamp0vrfrax5b0lmgm3h0lbgbb3hnkv3dd0f5zr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXTrap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXt }: stdenv.mkDerivation {
    name = "libXTrap-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXTrap-1.0.1.tar.bz2";
      sha256 = "0bi5wxj6avim61yidh9fd3j4n8czxias5m8vss9vhxjnk1aksdwg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "libXau-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXau-1.0.9.tar.bz2";
      sha256 = "1v3krc6x0zliaa66qq1bf9j60x5nqfy68v8axaiglxpnvgqcpy6c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXaw = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXmu, libXpm, libXt }: stdenv.mkDerivation {
    name = "libXaw-1.0.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXaw-1.0.14.tar.bz2";
      sha256 = "13kg59r3086383g1dyhnwxanhp2frssh9062mrgn34nzlf7gkbkn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXmu libXpm libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXaw3d = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXmu, libXpm, xorgproto, libXt }: stdenv.mkDerivation {
    name = "libXaw3d-1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXaw3d-1.6.3.tar.bz2";
      sha256 = "0i653s8g25cc0mimkwid9366bqkbyhdyjhckx7bw77j20hzrkfid";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXmu libXpm xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXcomposite = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes }: stdenv.mkDerivation {
    name = "libXcomposite-0.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcomposite-0.4.5.tar.bz2";
      sha256 = "13sfcglvz87vl58hd9rszwr73z0z4nwga3c12rfh7f5s2ln8l8dk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXcursor = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes, libXrender }: stdenv.mkDerivation {
    name = "libXcursor-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXcursor-1.2.0.tar.bz2";
      sha256 = "10l7c9fm0jmpkm9ab9dz8r6m1pr87vvgqjnbx1psz50h4pwfklrs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXdamage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXfixes }: stdenv.mkDerivation {
    name = "libXdamage-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdamage-1.1.5.tar.bz2";
      sha256 = "0igaw2akjf712y3rv7lx473jigxmcv9rs9y8sbrvbhya8f30cd5p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXdmcp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "libXdmcp-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXdmcp-1.1.3.tar.bz2";
      sha256 = "0ab53h0rkq721ihk5hi469x500f3pgbkm1wy01yf24x5m923nli0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXext = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "libXext-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXext-1.3.4.tar.bz2";
      sha256 = "0azqxllcsfxc3ilhz6kwc6x7m8wc477p59ir9p0yrsldx766zbar";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXfixes = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    name = "libXfixes-5.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfixes-5.0.3.tar.bz2";
      sha256 = "1miana3y4hwdqdparsccmygqr3ic3hs5jrqfzp70hvi2zwxd676y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXfont = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib }: stdenv.mkDerivation {
    name = "libXfont-1.5.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfont-1.5.4.tar.bz2";
      sha256 = "0hiji1bvpl78aj3a3141hkk353aich71wv8l5l2z51scfy878zqs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc xorgproto freetype xtrans zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXfont2 = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, xorgproto, freetype, xtrans, zlib }: stdenv.mkDerivation {
    name = "libXfont2-2.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXfont2-2.0.4.tar.bz2";
      sha256 = "1rk9pjxcm01lbr1dxhnvk4f2qrn6zp068qjbvvz5w0z5d0rin5bd";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc xorgproto freetype xtrans zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXft = callPackage ({ stdenv, pkg-config, fetchurl, fontconfig, freetype, libX11, xorgproto, libXrender }: stdenv.mkDerivation {
    name = "libXft-2.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXft-2.3.3.tar.bz2";
      sha256 = "05lja9s54090xwh31r0bqms4v3pimng5xr09g2rdnafx2vk6hp12";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ fontconfig freetype libX11 xorgproto libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXfixes }: stdenv.mkDerivation {
    name = "libXi-1.7.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXi-1.7.10.tar.bz2";
      sha256 = "0q8hz3slga3w3ch8wp0k7ay9ilhz315qnab0w1y2x9w3cf7hv8rn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXfixes ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXinerama = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    name = "libXinerama-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXinerama-1.1.4.tar.bz2";
      sha256 = "086p0axqj57nvkaqa6r00dnr9kyrn1m8blgf0zjy25zpxkbxn200";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXmu = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt }: stdenv.mkDerivation {
    name = "libXmu-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXmu-1.1.3.tar.bz2";
      sha256 = "0cdpqnx6258i4l6qhphvkdiyspysg0i5caqjy820kp63wwjk4d4w";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXp = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXau, libXext }: stdenv.mkDerivation {
    name = "libXp-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXp-1.0.3.tar.bz2";
      sha256 = "0mwc2jwmq03b1m9ihax5c6gw2ln8rc70zz4fsj3kb7440nchqdkz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXau libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXpm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto, libXt, gettext }: stdenv.mkDerivation {
    name = "libXpm-3.5.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpm-3.5.13.tar.bz2";
      sha256 = "09dc6nwlb2122h02vl64k9x56mxnyqz2gwpga0abfv4bb1bxmlcw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libX11 libXext xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXpresent = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    name = "libXpresent-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXpresent-1.0.0.tar.bz2";
      sha256 = "12kvvar3ihf6sw49h6ywfdiwmb8i1gh8wasg1zhzp6hs2hay06n1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXrandr = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXrender }: stdenv.mkDerivation {
    name = "libXrandr-1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrandr-1.5.2.tar.bz2";
      sha256 = "08z0mqywrm7ij8bxlfrx0d2wy6kladdmkva1nw5k6qix82z0xsla";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXrender = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    name = "libXrender-0.9.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXrender-0.9.10.tar.bz2";
      sha256 = "0j89cnb06g8x79wmmnwzykgkkfdhin9j7hjpvsxwlr3fz1wmjvf0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXres = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libXres-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXres-1.2.1.tar.bz2";
      sha256 = "049b7dk6hx47161hg47ryjrm6pwsp27r5pby05b0wqb1pcggprmn";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXt = callPackage ({ stdenv, pkg-config, fetchurl, libICE, xorgproto, libSM, libX11 }: stdenv.mkDerivation {
    name = "libXt-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXt-1.2.1.tar.bz2";
      sha256 = "0q1x7842r8rcn2m0q4q9f69h4qa097fyizs8brzx5ns62s7w1737";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE xorgproto libSM libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXtst = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi }: stdenv.mkDerivation {
    name = "libXtst-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXtst-1.2.3.tar.bz2";
      sha256 = "012jpyj7xfm653a9jcfqbzxyywdmwb2b5wr1dwylx14f3f54jma6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXi ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libXv-1.0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXv-1.0.11.tar.bz2";
      sha256 = "125hn06bd3d8y97hm2pbf5j55gg4r2hpd3ifad651i4sr7m16v6j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXvMC = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXv }: stdenv.mkDerivation {
    name = "libXvMC-1.0.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXvMC-1.0.12.tar.bz2";
      sha256 = "1kbdjsvkm5l7axv7g477qj18sab2wnqhliy6197syzizgfbsfgbb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXv ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXxf86dga = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    name = "libXxf86dga-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86dga-1.1.5.tar.bz2";
      sha256 = "00vjvcdlc1sga251jkxn6gkxmx9h5n290ffxxpa40qbca1gvr61b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXxf86misc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    name = "libXxf86misc-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86misc-1.0.4.tar.bz2";
      sha256 = "107k593sx27vjz3v7gbb223add9i7w0bjc90gbb3jqpin3i07758";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libXxf86vm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, xorgproto }: stdenv.mkDerivation {
    name = "libXxf86vm-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libXxf86vm-1.1.4.tar.bz2";
      sha256 = "0mydhlyn72i7brjwypsqrpkls3nm6vxw0li8b2nw0caz7kwjgvmg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libdmx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext }: stdenv.mkDerivation {
    name = "libdmx-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libdmx-1.1.4.tar.bz2";
      sha256 = "0hvjfhrcym770cr0zpqajdy3cda30aiwbjzv16iafkqkbl090gr5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libfontenc = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, zlib }: stdenv.mkDerivation {
    name = "libfontenc-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libfontenc-1.1.4.tar.bz2";
      sha256 = "0y90170dp8wsidr1dzza0grxr1lfh30ji3b5vkjz4j6x1n0wxz1c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libpciaccess = callPackage ({ stdenv, pkg-config, fetchurl, zlib }: stdenv.mkDerivation {
    name = "libpciaccess-0.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libpciaccess-0.16.tar.bz2";
      sha256 = "12glp4w1kgvmqn89lk19cgr6jccd3awxra4dxisp7pagi06rsk11";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libpthreadstubs = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "libpthread-stubs-0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/libpthread-stubs-0.4.tar.bz2";
      sha256 = "0cz7s9w8lqgzinicd4g36rjg08zhsbyngh0w68c3np8nlc8mkl74";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libxcb = callPackage ({ stdenv, pkg-config, fetchurl, libxslt, libpthreadstubs, libXau, xcbproto, libXdmcp, python3 }: stdenv.mkDerivation {
    name = "libxcb-1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxcb-1.14.tar.xz";
      sha256 = "0d2chjgyn5lr9sfhacfvqgnj9l9faz11vn322a06jd6lk3dxcpm5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libxslt libpthreadstubs libXau xcbproto libXdmcp ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libxkbfile = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11 }: stdenv.mkDerivation {
    name = "libxkbfile-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxkbfile-1.1.0.tar.bz2";
      sha256 = "1irq9crvscd3yb8sr802dhvvfr35jdy1n2yz094xplmd42mbv3bm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  libxshmfence = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "libxshmfence-1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/libxshmfence-1.3.tar.bz2";
      sha256 = "1ir0j92mnd1nk37mrv9bz5swnccqldicgszvfsh62jd14q6k115q";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  listres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    name = "listres-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/listres-1.0.4.tar.bz2";
      sha256 = "041bxkvv6f92sm3hhm977c4gdqdv5r1jyxjqcqfi8vkrg3s2j4ka";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  lndir = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "lndir-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/lndir-1.0.3.tar.bz2";
      sha256 = "0pdngiy8zdhsiqx2am75yfcl36l7kd7d7nl0rss8shcdvsqgmx29";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  luit = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "luit-20190106";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://invisible-mirror.net/archives/luit/luit-20190106.tgz";
      sha256 = "081rrajj5hpgx3pvm43grqzscnq5kl320q0wq6zzhf6wrijhz41b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  makedepend = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "makedepend-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/makedepend-1.0.6.tar.bz2";
      sha256 = "072h9nzh8s5vqfz35dli4fba36fnr219asjrb7p89n8ph0paan6m";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  mkfontscale = callPackage ({ stdenv, pkg-config, fetchurl, libfontenc, freetype, xorgproto, zlib }: stdenv.mkDerivation {
    name = "mkfontscale-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/mkfontscale-1.2.1.tar.bz2";
      sha256 = "1ixsnsm2mn0zy9ksdid0lj6irnhvasfik9mz8bbrs5sajzmra16a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libfontenc freetype xorgproto zlib ];
    meta.platforms = lib.platforms.unix;
  }) {};

  oclock = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, libXext, libXmu, libXt }: stdenv.mkDerivation {
    name = "oclock-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/oclock-1.0.4.tar.bz2";
      sha256 = "1zmfzfmdp42nvapf0qz1bc3i3waq5sjrpkgfw64qs4nmq30wy86c";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxkbfile libX11 libXext libXmu libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  sessreg = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto }: stdenv.mkDerivation {
    name = "sessreg-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/sessreg-1.1.2.tar.bz2";
      sha256 = "0crczl25zynkrslmm8sjaxszhrh4i33m7h5fg4wfdb3k8aarxjyz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  setxkbmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile }: stdenv.mkDerivation {
    name = "setxkbmap-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/setxkbmap-1.3.2.tar.bz2";
      sha256 = "1xdrxs65v7d0rw1yaz0vsz55w4hxym99216p085ya9978j379wlg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile ];
    meta.platforms = lib.platforms.unix;
  }) {};

  smproxy = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libXmu, libXt }: stdenv.mkDerivation {
    name = "smproxy-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/smproxy-1.0.6.tar.bz2";
      sha256 = "0rkjyzmsdqmlrkx8gy2j4q6iksk58hcc92xzdprkf8kml9ar3wbc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libSM libXmu libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  transset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "transset-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/transset-1.0.2.tar.bz2";
      sha256 = "088v8p0yfn4r3azabp6662hqikfs2gjb9xmjjd45gnngwwp19b2b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  twm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXext, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    name = "twm-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/twm-1.0.10.tar.bz2";
      sha256 = "1ms5cj1w3g26zg6bxdv1j9hl0pxr4300qnv003cz1q3cl7ffljb4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libSM libX11 libXext libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  utilmacros = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "util-macros-1.19.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/util-macros-1.19.3.tar.bz2";
      sha256 = "0w8ryfqylprz37zj9grl4jzdsqq67ibfwq5raj7vm1i7kmp2x08g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  viewres = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXmu, libXt }: stdenv.mkDerivation {
    name = "viewres-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/viewres-1.0.5.tar.bz2";
      sha256 = "1mz319kfmvcrdpi22dmdr91mif1j0j3ck1f8mmnz5g1r9kl1in2y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXmu libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  x11perf = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXft, libXmu, xorgproto, libXrender }: stdenv.mkDerivation {
    name = "x11perf-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/x11perf-1.6.1.tar.bz2";
      sha256 = "0d3wh6z6znwhfdiv0zaggfj0xgish98xa10yy76b9517zj7hnzhw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXft libXmu xorgproto libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xauth = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXext, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xauth-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xauth-1.1.tar.bz2";
      sha256 = "032klzzw8r09z36x1272ssd79bcisz8j5p8gbdy111fiknvx27bd";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXau libXext libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xbacklight = callPackage ({ stdenv, pkg-config, fetchurl, libxcb, xcbutil }: stdenv.mkDerivation {
    name = "xbacklight-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xbacklight-1.2.3.tar.bz2";
      sha256 = "1plssg0s3pbslg6rfzxp9sx8ryvn8l32zyvc8zp9zsbsfwjg69rs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb xcbutil ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xbitmaps = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "xbitmaps-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xbitmaps-1.1.2.tar.bz2";
      sha256 = "1vh73sc13s7w5r6gnc6irca56s7998bja7wgdivkfn8jccawgw5r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcalc = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, xorgproto, libXt }: stdenv.mkDerivation {
    name = "xcalc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcalc-1.1.0.tar.bz2";
      sha256 = "1sxmlcb0sb3h4z05kl5l0kxnhrc0h8c74p9m3zdc7bv58jaldmym";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbproto = callPackage ({ stdenv, pkg-config, fetchurl, python3 }: stdenv.mkDerivation {
    name = "xcb-proto-1.14.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xcb-proto-1.14.1.tar.xz";
      sha256 = "1hzwazgyywd9mz4mjj1yv8ski27qqx7ypmyr27m39hrajyddsjph";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2";
      sha256 = "1sahmrgbpyki4bb72hxym0zvxwnycmswsxiisgqlln9vrdlr9r26";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilcursor = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutilimage, xcbutilrenderutil, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-cursor-0.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2";
      sha256 = "0krr4rcw6r42cncinzvzzdqnmxk3nrgpnadyg2h8k9x10q3hm885";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutilimage xcbutilrenderutil xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilerrors = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbproto, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-errors-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-errors-1.0.tar.bz2";
      sha256 = "158rm913dg3hxrrhyvvxr8bcm0pjy5jws70dhy2s12w1krv829k8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbproto xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilimage = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xcbutil, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-image-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2";
      sha256 = "1z1gxacg7q4cw6jrd26gvi5y04npsyavblcdad1xccc8swvnmf9d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xcbutil xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilkeysyms = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-keysyms-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2";
      sha256 = "1nbd45pzc1wm6v5drr5338j4nicbgxa5hcakvsvm5pnyy47lky0f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilrenderutil = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-renderutil-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2";
      sha256 = "0nza1csdvvxbmk8vgv8vpmq7q8h05xrw3cfx9lwxd1hjzd47xsf6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcbutilwm = callPackage ({ stdenv, pkg-config, fetchurl, gperf, libxcb, xorgproto, m4 }: stdenv.mkDerivation {
    name = "xcb-util-wm-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2";
      sha256 = "0gra7hfyxajic4mjd63cpqvd20si53j1q3rbdlkqkahfciwq3gr8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config m4 ];
    buildInputs = [ gperf libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xclock = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXft, libxkbfile, libXmu, xorgproto, libXrender, libXt }: stdenv.mkDerivation {
    name = "xclock-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xclock-1.0.9.tar.bz2";
      sha256 = "1fr3q4rszgx7x2zxy2ip592a3fgx20hfwac49p2l5b7jqsr1ying";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw libXft libxkbfile libXmu xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcmsdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11 }: stdenv.mkDerivation {
    name = "xcmsdb-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcmsdb-1.0.5.tar.bz2";
      sha256 = "1ik7gzlp2igz183x70883000ygp99r20x3aah6xhaslbpdhm6n75";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcompmgr = callPackage ({ stdenv, pkg-config, fetchurl, libXcomposite, libXdamage, libXext, libXfixes, libXrender }: stdenv.mkDerivation {
    name = "xcompmgr-1.1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcompmgr-1.1.8.tar.bz2";
      sha256 = "0hvjkanrdlvk3ln5a1jx3c9ggziism2jr1na7jl3zyk0y3sdm28b";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXcomposite libXdamage libXext libXfixes libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xconsole = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt }: stdenv.mkDerivation {
    name = "xconsole-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xconsole-1.0.7.tar.bz2";
      sha256 = "1q2ib1626i5da0nda09sp3vzppjrcn82fff83cw7hwr0vy14h56i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcursorgen = callPackage ({ stdenv, pkg-config, fetchurl, libpng, libX11, libXcursor }: stdenv.mkDerivation {
    name = "xcursorgen-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xcursorgen-1.0.7.tar.bz2";
      sha256 = "0ggbv084cavp52hjgcz3vdj0g018axs0m23c03lpc5sgn92gidim";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libpng libX11 libXcursor ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xcursorthemes = callPackage ({ stdenv, pkg-config, fetchurl, libXcursor }: stdenv.mkDerivation {
    name = "xcursor-themes-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xcursor-themes-1.0.6.tar.bz2";
      sha256 = "16a96li0s0ggg60v7f6ywxmsrmxdfizcw55ccv7sp4qjfisca7pf";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXcursor ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xdm = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXaw, libXdmcp, libXext, libXft, libXinerama, libXmu, libXpm, xorgproto, libXrender, libXt }: stdenv.mkDerivation {
    name = "xdm-1.1.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdm-1.1.12.tar.bz2";
      sha256 = "1x17hdymf6rd8jmh4n1sd4g5a8ayr5w94nwjw84qs2fs5pvq7lhd";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xdpyinfo = callPackage ({ stdenv, pkg-config, fetchurl, libdmx, libX11, libxcb, libXcomposite, libXext, libXi, libXinerama, xorgproto, libXrender, libXtst, libXxf86dga, libXxf86misc, libXxf86vm }: stdenv.mkDerivation {
    name = "xdpyinfo-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdpyinfo-1.3.2.tar.bz2";
      sha256 = "0ldgrj4w2fa8jng4b3f3biaj0wyn8zvya88pnk70d7k12pcqw8rh";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xorgproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xdriinfo = callPackage ({ stdenv, pkg-config, fetchurl, libGL, xorgproto, libX11 }: stdenv.mkDerivation {
    name = "xdriinfo-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xdriinfo-1.0.6.tar.bz2";
      sha256 = "0lcx8h3zd11m4w8wf7dyp89826d437iz78cyrix436bqx31x5k6r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libGL xorgproto libX11 ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xev = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr }: stdenv.mkDerivation {
    name = "xev-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xev-1.2.3.tar.bz2";
      sha256 = "02ddsdx138g7szhwklpbzi0cxr34871iay3k28kdcihrz8f4zg36";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXrandr ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xeyes = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXmu, xorgproto, libXrender, libXt }: stdenv.mkDerivation {
    name = "xeyes-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xeyes-1.1.2.tar.bz2";
      sha256 = "0lq5j7fryx1wn998jq6h3icz1h6pqrsbs3adskjzjyhn5l6yrg2p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXmu xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputevdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, udev, mtdev, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-evdev-2.10.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-evdev-2.10.6.tar.bz2";
      sha256 = "1h1y0fwnawlp4yc5llr1l7hwfcxxpln2fxhy6arcf6w6h4z0f9l7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libevdev udev mtdev xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputjoystick = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-joystick-1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-joystick-1.6.3.tar.bz2";
      sha256 = "1awfq496d082brgjbr60lhm6jvr9537rflwxqdfqwfzjy3n6jxly";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputkeyboard = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-keyboard-1.9.0.tar.bz2";
      sha256 = "12032yg412kyvnmc5fha1in7mpi651d8sa1bk4138s2j2zr01jgp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputlibinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libinput, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-libinput-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-libinput-1.0.0.tar.bz2";
      sha256 = "0x4ay9y2clm2bql3myqnvhmikjbpzy95c800qiva8pg6dbvc4mgg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libinput xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-mouse-1.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-mouse-1.9.3.tar.bz2";
      sha256 = "1iawr1wyl2qch1mqszcs0s84i92mh4xxprflnycbw1adc18b7v4k";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputsynaptics = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libevdev, libX11, libXi, xorgserver, libXtst }: stdenv.mkDerivation {
    name = "xf86-input-synaptics-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-synaptics-1.9.1.tar.bz2";
      sha256 = "0xhm03qywwfgkpfl904d08lx00y28m1b6lqmks5nxizixwk3by3s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libevdev libX11 libXi xorgserver libXtst ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputvmmouse = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, udev, xorgserver }: stdenv.mkDerivation {
    name = "xf86-input-vmmouse-13.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2";
      sha256 = "06ckn4hlkpig5vnivl0zj8a7ykcgvrsj8b3iccl1pgn1gaamix8a";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto udev xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86inputvoid = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto }: stdenv.mkDerivation {
    name = "xf86-input-void-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-input-void-1.4.1.tar.bz2";
      sha256 = "171k8b8s42s3w73l7ln9jqwk88w4l7r1km2blx1vy898c854yvpr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgserver xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoamdgpu = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-amdgpu-19.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-amdgpu-19.1.0.tar.bz2";
      sha256 = "0pgy4ihnja0vm8504qw7qxh3pdpa3p9k6967nz15m6b1mvha83jg";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto mesa libGL libdrm udev xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoapm = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-apm-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-apm-1.3.0.tar.bz2";
      sha256 = "0znwqfc8abkiha98an8hxsngnz96z6cd976bc4bsvz1km6wqk0c0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoark = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-ark-0.7.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ark-0.7.5.tar.bz2";
      sha256 = "07p5vdsj2ckxb6wh02s61akcv4qfg6s1d5ld3jn3lfaayd3f1466";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoast = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-ast-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ast-1.1.5.tar.bz2";
      sha256 = "1pm2cy81ma7ldsw0yfk28b33h9z2hcj5rccrxhfxfgvxsiavrnqy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoati = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, mesa, libGL, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-ati-19.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-ati-19.1.0.tar.bz2";
      sha256 = "0j9w4axsqlycv4v14g53xyhkm9h7d27b2fcv9lrzb9gf54b5m7v5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto mesa libGL libdrm udev libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videochips = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-chips-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-chips-1.4.0.tar.bz2";
      sha256 = "1gqzy7q9v824m7hqkbbmncxg082zm0d4mafgc97c4skyiwgf9wq7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videocirrus = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-cirrus-1.5.3.tar.bz2";
      sha256 = "1asifc6ld2g9kap15vfhvsvyl69lj7pw3d9ra9mi4najllh7pj7d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videodummy = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-dummy-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-dummy-0.3.8.tar.bz2";
      sha256 = "1fcm9vwgv8wnffbvkzddk4yxrh3kc0np6w65wj8k88q7jf3bn4ip";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videofbdev = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2";
      sha256 = "16a66zr0l1lmssa07i3rzy07djxnb45c17ks8c71h8l06xgxihyw";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videogeode = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-geode-2.11.19";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-geode-2.11.19.tar.bz2";
      sha256 = "0zn9gb49grds5mcs1dlrx241k2w1sgqmx4i5x7v6159xxqhlqsf6";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoglide = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-glide-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-glide-1.2.2.tar.bz2";
      sha256 = "1vaav6kx4n00q4fawgqnjmbdkppl0dir2dkrj4ad372mxrvl9c4y";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoglint = callPackage ({ stdenv, pkg-config, fetchurl, libpciaccess, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-glint-1.2.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-glint-1.2.9.tar.bz2";
      sha256 = "1lkpspvrvrp9s539bhfdjfh4andaqyk63l6zjn8m3km95smk6a45";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libpciaccess xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoi128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-i128-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-i128-1.4.0.tar.bz2";
      sha256 = "1snhpv1igrhifcls3r498kjd14ml6x2xvih7zk9xlsd1ymmhlb4g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoi740 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-i740-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-i740-1.4.0.tar.bz2";
      sha256 = "0l3s1m95bdsg4gki943qipq8agswbb84dzcflpxa3vlckwhh3r26";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videointel = callPackage ({ stdenv, pkg-config, fetchurl, cairo, xorgproto, libdrm, libpng, udev, libpciaccess, libX11, xcbutil, libxcb, libXcursor, libXdamage, libXext, libXfixes, xorgserver, libXrandr, libXrender, libxshmfence, libXtst, libXvMC }: stdenv.mkDerivation {
    name = "xf86-video-intel-2.99.917";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-intel-2.99.917.tar.bz2";
      sha256 = "1jb7jspmzidfixbc0gghyjmnmpqv85i7pi13l4h2hn2ml3p83dq0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ cairo xorgproto libdrm libpng udev libpciaccess libX11 xcbutil libxcb libXcursor libXdamage libXext libXfixes xorgserver libXrandr libXrender libxshmfence libXtst libXvMC ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videomach64 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-mach64-6.9.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-mach64-6.9.6.tar.bz2";
      sha256 = "171wg8r6py1l138s58rlapin3rlpwsg9spmvhc7l68mm3g3hf1vs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videomga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-mga-2.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-mga-2.0.0.tar.bz2";
      sha256 = "0yaxpgyyj9398nzzr5vnsfxcis76z46p9814yzj8179yl7hld296";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoneomagic = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-neomagic-1.3.0.tar.bz2";
      sha256 = "0r4h673kw8fl7afc30anwbjlbhp82mg15fvaxf470xg7z983k0wk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videonewport = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-newport-0.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-newport-0.2.4.tar.bz2";
      sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videonouveau = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-nouveau-1.0.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-nouveau-1.0.17.tar.bz2";
      sha256 = "0sqm1jwjg15sp8v7039y2hsbhph8gpjd2bdzcqqiij2mgbi254s9";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videonv = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-nv-2.1.21";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-nv-2.1.21.tar.bz2";
      sha256 = "0bdk3pc5y0n7p53q4gc2ff7bw16hy5hwdjjxkm5j3s7hdyg6960z";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoomap = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-omap-0.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-omap-0.4.5.tar.bz2";
      sha256 = "0nmbrx6913dc724y8wj2p6vqfbj5zdjfmsl037v627jj0whx9rwk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoopenchrome = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver, libXvMC }: stdenv.mkDerivation {
    name = "xf86-video-openchrome-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-openchrome-0.6.0.tar.bz2";
      sha256 = "0x9gq3hw6k661k82ikd1y2kkk4dmgv310xr5q59dwn4k6z37aafs";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess libX11 libXext xorgserver libXvMC ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoqxl = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-qxl-0.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-qxl-0.1.5.tar.bz2";
      sha256 = "14jc24znnahhmz4kqalafmllsg8awlz0y6gpgdpk5ih38ph851mi";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videor128 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-r128-6.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-r128-6.11.0.tar.bz2";
      sha256 = "0snvwmrh8dqyyaq7ggicym6yrsg4brygkx9156r0m095m7fp3rav";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videorendition = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-rendition-4.2.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-rendition-4.2.7.tar.bz2";
      sha256 = "0yzqcdfrnnyaaaa76d4hpwycpq4x2j8qvg9m4q19lj4xbicwc4cm";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videos3virge = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-s3virge-1.11.0.tar.bz2";
      sha256 = "06d1v5s7xf00y18x12cz11sk00rgn0yq95w66kmgzy465pzxvj84";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosavage = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-savage-2.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-savage-2.3.9.tar.bz2";
      sha256 = "11pcrsdpdrwk0mrgv83s5nsx8a9i4lhmivnal3fjbrvi3zdw94rc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosiliconmotion = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.7.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.9.tar.bz2";
      sha256 = "1g2r6gxqrmjdff95d42msxdw6vmkg2zn5sqv0rxd420iwy8wdwyh";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosis = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-sis-0.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sis-0.11.0.tar.bz2";
      sha256 = "0srvrhydjnynfb7b1s145rgmsk4f71iz0ag4icpmb05944d90xr1";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosisusb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.9.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sisusb-0.9.7.tar.bz2";
      sha256 = "090lfs3hjz3cjd016v5dybmcsigj6ffvjdhdsqv13k90p4b08h7l";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosuncg6 = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-suncg6-1.1.2.tar.bz2";
      sha256 = "04fgwgk02m4nimlv67rrg1wnyahgymrn6rb2cjj1l8bmzkii4glr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosunffb = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sunffb-1.2.2.tar.bz2";
      sha256 = "07z3ngifwg2d4jgq8pms47n5lr2yn0ai72g86xxjnb3k20n5ym7s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videosunleo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-sunleo-1.2.2.tar.bz2";
      sha256 = "1gacm0s6rii4x5sx9py5bhvs50jd4vs3nnbwjdjymyf31kpdirl3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videotdfx = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-tdfx-1.5.0.tar.bz2";
      sha256 = "0qc5wzwf1n65si9rc37bh224pzahh7gp67vfimbxs0b9yvhq0i9g";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videotga = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-tga-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2";
      sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videotrident = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-trident-1.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-trident-1.3.8.tar.bz2";
      sha256 = "0gxcar434kx813fxdpb93126lhmkl3ikabaljhcj5qn3fkcijlcy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videov4l = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-v4l-0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-v4l-0.3.0.tar.bz2";
      sha256 = "084x4p4avy72mgm2vnnvkicw3419i6pp3wxik8zqh7gmq4xv5z75";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videovboxvideo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-vboxvideo-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vboxvideo-1.0.0.tar.bz2";
      sha256 = "195z1js3i51qgxvhfw4bxb4dw3jcrrx2ynpm2y3475dypjzs7dkz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videovesa = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-vesa-2.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vesa-2.5.0.tar.bz2";
      sha256 = "0nf6ai74c60xk96kgr8q9mx6lrxm5id3765ws4d801irqzrj85hz";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videovmware = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, udev, libpciaccess, libX11, libXext, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-vmware-13.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-vmware-13.3.0.tar.bz2";
      sha256 = "0v06qhm059klq40m2yx4wypzb7h53aaassbjfmm6clcyclj1k5s7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm udev libpciaccess libX11 libXext xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videovoodoo = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-voodoo-1.2.5.tar.bz2";
      sha256 = "1s6p7yxmi12q4y05va53rljwyzd6ry492r1pgi7wwq6cznivhgly";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videowsfb = callPackage ({ stdenv, pkg-config, fetchurl, xorgserver, xorgproto }: stdenv.mkDerivation {
    name = "xf86-video-wsfb-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-wsfb-0.4.0.tar.bz2";
      sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgserver xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xf86videoxgi = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libdrm, libpciaccess, xorgserver }: stdenv.mkDerivation {
    name = "xf86-video-xgi-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/driver/xf86-video-xgi-1.6.1.tar.bz2";
      sha256 = "10xd2vah0pnpw5spn40n4p95mpmgvdkly4i1cz51imnlfsw7g8si";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libdrm libpciaccess xorgserver ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xfd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, fontconfig, libXaw, libXft, libXmu, xorgproto, libXrender, libXt, gettext }: stdenv.mkDerivation {
    name = "xfd-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfd-1.1.3.tar.bz2";
      sha256 = "0n6r1v8sm0z0ycqch035xpm46nv5v4mav3kxh36883l3ln5r6bqr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libxkbfile fontconfig libXaw libXft libXmu xorgproto libXrender libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xfontsel = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, libXt }: stdenv.mkDerivation {
    name = "xfontsel-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfontsel-1.0.6.tar.bz2";
      sha256 = "0700lf6hx7dg88wq1yll7zjvf9gbwh06xff20yffkxb289y0pai5";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw libXmu libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xfs = callPackage ({ stdenv, pkg-config, fetchurl, libXfont2, xorgproto, xtrans }: stdenv.mkDerivation {
    name = "xfs-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfs-1.2.0.tar.bz2";
      sha256 = "0q4q4rbzx159sfn2n52y039fki6nc6a39qdfxa78yjc3aw8i48nv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXfont2 xorgproto xtrans ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xfsinfo = callPackage ({ stdenv, pkg-config, fetchurl, libFS, xorgproto }: stdenv.mkDerivation {
    name = "xfsinfo-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xfsinfo-1.0.6.tar.bz2";
      sha256 = "1mmir5i7gm71xc0ba8vnizi4744vsd31hknhi4cmgvg6kadqngla";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libFS xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xgamma = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXxf86vm }: stdenv.mkDerivation {
    name = "xgamma-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xgamma-1.0.6.tar.bz2";
      sha256 = "1lr2nb1fhg5fk2fchqxdxyl739602ggwhmgl2wiv5c8qbidw7w8f";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXxf86vm ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xgc = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt }: stdenv.mkDerivation {
    name = "xgc-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xgc-1.0.5.tar.bz2";
      sha256 = "0pigvjd3i9fchmj1inqy151aafz3dr0vq1h2zizdb2imvadqv0hl";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xhost = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXau, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xhost-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xhost-1.0.8.tar.bz2";
      sha256 = "15n3mnd4i5kh4z32qv11580qjgvnng0wry2y753ljrqkkrbkrp52";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXau libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xinit = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xinit-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xinit-1.4.1.tar.bz2";
      sha256 = "1fdbakx59vyh474skjydj1bbglpby3y03nl7mxn0z9v8gdhqz6yy";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xinput = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXext, libXi, libXinerama, libXrandr }: stdenv.mkDerivation {
    name = "xinput-1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xinput-1.6.3.tar.bz2";
      sha256 = "1vb6xdd1xmk5f7pwc5zcbxfray5sf1vbnscqwf2yl8lv7gfq38im";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXext libXi libXinerama libXrandr ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkbcomp = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto }: stdenv.mkDerivation {
    name = "xkbcomp-1.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbcomp-1.4.5.tar.bz2";
      sha256 = "0pmhshqinwqh5rip670l3szjpywky67hv232ql6gvdj489n0hlb8";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkbevd = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile }: stdenv.mkDerivation {
    name = "xkbevd-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbevd-1.1.4.tar.bz2";
      sha256 = "0sprjx8i86ljk0l7ldzbz2xlk8916z5zh78cafjv8k1a63js4c14";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkbprint = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxkbfile, xorgproto }: stdenv.mkDerivation {
    name = "xkbprint-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbprint-1.0.4.tar.bz2";
      sha256 = "04iyv5z8aqhabv7wcpvbvq0ji0jrz1666vw6gvxkvl7szswalgqb";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxkbfile xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkbutils = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, libX11, libXaw, libXt }: stdenv.mkDerivation {
    name = "xkbutils-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkbutils-1.0.4.tar.bz2";
      sha256 = "0c412isxl65wplhl7nsk12vxlri29lk48g3p52hbrs3m0awqm8fj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto libX11 libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkeyboardconfig = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, python3 }: stdenv.mkDerivation {
    name = "xkeyboard-config-2.31";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.31.tar.bz2";
      sha256 = "18xddaxh83zm698syh50w983jg6b7b8zgv0dfaf7ha485hgihi6s";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config python3 ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xkill = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xkill-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xkill-1.0.5.tar.bz2";
      sha256 = "0szzd9nzn0ybkhnfyizb876irwnjsnb78rcaxx6prb71jmmbpw65";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xload = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, xorgproto, libXt, gettext }: stdenv.mkDerivation {
    name = "xload-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xload-1.1.3.tar.bz2";
      sha256 = "01sr6yd6yhyyfgn88l867w6h9dn5ikcynaz5rwji6xqxhw1lhkpk";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config gettext ];
    buildInputs = [ libX11 libXaw libXmu xorgproto libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xlsatoms = callPackage ({ stdenv, pkg-config, fetchurl, libxcb }: stdenv.mkDerivation {
    name = "xlsatoms-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsatoms-1.1.3.tar.bz2";
      sha256 = "10m3a046jvaw5ywx4y65kl84lsxqan70gww1g1r7cf96ijaqz1jp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xlsclients = callPackage ({ stdenv, pkg-config, fetchurl, libxcb }: stdenv.mkDerivation {
    name = "xlsclients-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsclients-1.1.4.tar.bz2";
      sha256 = "1h8931sn34mcip6vpi4v7hdmr1r58gkbw4s2p97w98kykks2lgvp";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxcb ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xlsfonts = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xlsfonts-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xlsfonts-1.0.6.tar.bz2";
      sha256 = "0s6kxgv78chkwsqmhw929f4pf91gq63f4yvixxnan1h00cx0pf49";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xmag = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXaw, libXmu, libXt }: stdenv.mkDerivation {
    name = "xmag-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmag-1.0.6.tar.bz2";
      sha256 = "0qg12ifbbk9n8fh4jmyb625cknn8ssj86chd6zwdiqjin8ivr8l7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXaw libXmu libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xmessage = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt }: stdenv.mkDerivation {
    name = "xmessage-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmessage-1.0.5.tar.bz2";
      sha256 = "0a90kfm0qz8cn2pbpqfyqrc5s9bfvvy14nj848ynvw56wy0zng9p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xmodmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xmodmap-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmodmap-1.0.10.tar.bz2";
      sha256 = "0z28331i2pm16x671fa9qwsfqdmr6a43bzwmp0dm17a3sx0hjgs7";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xmore = callPackage ({ stdenv, pkg-config, fetchurl, libXaw, libXt }: stdenv.mkDerivation {
    name = "xmore-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xmore-1.0.3.tar.bz2";
      sha256 = "06r514p30v87vx00ddlck9mwazaqk9bx08ip866p1mw2a46iwjk4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xorgcffiles = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "xorg-cf-files-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/util/xorg-cf-files-1.0.6.tar.bz2";
      sha256 = "0kckng0zs1viz0nr84rdl6dswgip7ndn4pnh5nfwnviwpsfmmksd";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xorgdocs = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "xorg-docs-1.7.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-docs-1.7.1.tar.bz2";
      sha256 = "0jrc4jmb4raqawx0j9jmhgasr0k6sxv0bm2hrxjh9hb26iy6gf14";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xorgproto = callPackage ({ stdenv, pkg-config, fetchurl, libXt }: stdenv.mkDerivation {
    name = "xorgproto-2021.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/proto/xorgproto-2021.3.tar.bz2";
      sha256 = "0dypp7cvjf0rvwa7cn1zp7djw5ynhs1rwk9p0r1vczbwzha2nwsc";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xorgserver = callPackage ({ stdenv, pkg-config, fetchurl, xorgproto, openssl, libX11, libXau, libXaw, libxcb, xcbutil, xcbutilwm, xcbutilimage, xcbutilkeysyms, xcbutilrenderutil, libXdmcp, libXfixes, libxkbfile, libXmu, libXpm, libXrender, libXres, libXt }: stdenv.mkDerivation {
    name = "xorg-server-1.20.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/xserver/xorg-server-1.20.10.tar.bz2";
      sha256 = "16bwrf0ag41l7jbrllbix8z6avc5yimga7ihvq4ch3a5hb020x4p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ xorgproto openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xorgsgmldoctools = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "xorg-sgml-doctools-1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/doc/xorg-sgml-doctools-1.11.tar.bz2";
      sha256 = "0k5pffyi5bx8dmfn033cyhgd3gf6viqj3x769fqixifwhbgy2777";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xpr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xpr-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xpr-1.0.5.tar.bz2";
      sha256 = "07qy9lwjvxighcmg6qvjkgagad3wwvidrfx0jz85lgynz3qy0dmr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xprop = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xprop-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xprop-1.2.5.tar.bz2";
      sha256 = "18ckr8g1z50zkc01hprkpm1npwbq32yqib4b3l98c95z2q1yv4lv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xrandr = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXrandr, libXrender }: stdenv.mkDerivation {
    name = "xrandr-1.5.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrandr-1.5.1.tar.xz";
      sha256 = "0ql75s1n3dm2m3g1ilb9l6hqh15r0v709bgghpwazy3jknpnvivv";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXrandr libXrender ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xrdb = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xrdb-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrdb-1.2.0.tar.bz2";
      sha256 = "0ik9gh6363c47pr0dp7q22nfs8vmavjg2v4bsr0604ppl77nafpj";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xrefresh = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xrefresh-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xrefresh-1.0.6.tar.bz2";
      sha256 = "0lv3rlshh7s0z3aqx5ahnnf8cl082m934bk7gv881mz8nydznz98";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xset = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXext, libXmu, xorgproto, libXxf86misc }: stdenv.mkDerivation {
    name = "xset-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xset-1.2.4.tar.bz2";
      sha256 = "0my987wjvra7l92ry6q44ky383yg3phzxhdbn3lqhapm1ll9bzg4";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXext libXmu xorgproto libXxf86misc ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xsetroot = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xbitmaps, libXcursor, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xsetroot-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xsetroot-1.1.2.tar.bz2";
      sha256 = "0z21mqvmdl6rl63q77479wgkfygnll57liza1i3va7sr4fx45i0h";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xbitmaps libXcursor libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xsm = callPackage ({ stdenv, pkg-config, fetchurl, libICE, libSM, libX11, libXaw, libXt }: stdenv.mkDerivation {
    name = "xsm-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xsm-1.0.4.tar.bz2";
      sha256 = "09a4ss1fnrh1sgm21r4n5pivawf34paci3rn6mscyljf7a4vcd4r";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libICE libSM libX11 libXaw libXt ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xstdcmap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXmu, xorgproto }: stdenv.mkDerivation {
    name = "xstdcmap-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xstdcmap-1.0.4.tar.bz2";
      sha256 = "12vgzsxv4rw25frkgjyli6w6hy10lgpvsx9wzw2v5l5a3qzqp286";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXmu xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xtrans = callPackage ({ stdenv, pkg-config, fetchurl }: stdenv.mkDerivation {
    name = "xtrans-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/lib/xtrans-1.4.0.tar.bz2";
      sha256 = "0wyp0yc6gi72hwc3kjmvm3vkj9p6s407cb6dxx37jh9wb68l8z1p";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xtrap = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libXt, libXTrap }: stdenv.mkDerivation {
    name = "xtrap-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xtrap-1.0.3.tar.bz2";
      sha256 = "0sqm4j1zflk1s94iq4waa70hna1xcys88v9a70w0vdw66czhvj2j";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libXt libXTrap ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xvinfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto, libXv }: stdenv.mkDerivation {
    name = "xvinfo-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xvinfo-1.1.4.tar.bz2";
      sha256 = "0gz7fvxavqlrqynpfbrm2nc9yx8h0ksnbnv34fj7n1q6cq6j4lq3";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto libXv ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xwd = callPackage ({ stdenv, pkg-config, fetchurl, libxkbfile, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xwd-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwd-1.0.7.tar.bz2";
      sha256 = "1537i8q8pgf0sjklakzfvjwrq5b246qjywrx9ll8xfg0p6w1as6d";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libxkbfile libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xwininfo = callPackage ({ stdenv, pkg-config, fetchurl, libX11, libxcb, xorgproto }: stdenv.mkDerivation {
    name = "xwininfo-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwininfo-1.1.4.tar.bz2";
      sha256 = "00avrpw4h5mr1klp41lv2j4dmq465v6l5kb5bhm4k5ml8sm9i543";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 libxcb xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

  xwud = callPackage ({ stdenv, pkg-config, fetchurl, libX11, xorgproto }: stdenv.mkDerivation {
    name = "xwud-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = "mirror://xorg/individual/app/xwud-1.0.5.tar.bz2";
      sha256 = "1a8hdgy40smvblnh3s9f0vkqckl68nmivx7d48zk34m8z18p16cr";
    };
    hardeningDisable = [ "bindnow" "relro" ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libX11 xorgproto ];
    meta.platforms = lib.platforms.unix;
  }) {};

})
