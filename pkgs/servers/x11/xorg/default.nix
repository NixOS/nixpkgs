# THIS IS A GENERATED FILE.  DO NOT EDIT!
args @ { clangStdenv, fetchurl, fetchgit, fetchpatch, stdenv, pkgconfig, intltool, freetype, fontconfig
, libxslt, expat, libpng, zlib, perl, mesa_drivers, spice_protocol
, dbus, libuuid, openssl, gperf, m4, libevdev, tradcpp, libinput, mcpp, makeWrapper, autoreconfHook
, autoconf, automake, libtool, xmlto, asciidoc, flex, bison, python, mtdev, pixman, ... }: with args;

let

  mkDerivation = name: attrs:
    let newAttrs = (overrides."${name}" or (x: x)) attrs;
        stdenv = newAttrs.stdenv or args.stdenv;
    in stdenv.mkDerivation (removeAttrs newAttrs [ "stdenv" ]);

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

  inherit pixman;

  applewmproto = (mkDerivation "applewmproto" {
    name = "applewmproto-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/applewmproto-1.4.2.tar.bz2;
      sha256 = "1zi4p07mp6jmk030p4gmglwxcwp0lzs5mi31y1b4rp8lsqxdxizw";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  appres = (mkDerivation "appres" {
    name = "appres-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/appres-1.0.4.tar.bz2;
      sha256 = "139yp08qy1w6dccamdy0fh343yhaf1am1v81m2j435nd4ya4wqcz";
    };
    buildInputs = [pkgconfig libX11 xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto libXt ;};

  bdftopcf = (mkDerivation "bdftopcf" {
    name = "bdftopcf-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/bdftopcf-1.0.5.tar.bz2;
      sha256 = "09i03sk878cmx2i40lkpsysn7zqcvlczb30j7x3lryb11jz4gx1q";
    };
    buildInputs = [pkgconfig libXfont ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXfont ;};

  bigreqsproto = (mkDerivation "bigreqsproto" {
    name = "bigreqsproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/bigreqsproto-1.1.2.tar.bz2;
      sha256 = "07hvfm84scz8zjw14riiln2v4w03jlhp756ypwhq27g48jmic8a6";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  compositeproto = (mkDerivation "compositeproto" {
    name = "compositeproto-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/compositeproto-0.4.2.tar.bz2;
      sha256 = "1z0crmf669hirw4s7972mmp8xig80kfndja9h559haqbpvq5k4q4";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  damageproto = (mkDerivation "damageproto" {
    name = "damageproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/damageproto-1.2.1.tar.bz2;
      sha256 = "0nzwr5pv9hg7c21n995pdiv0zqhs91yz3r8rn3aska4ykcp12z2w";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  dmxproto = (mkDerivation "dmxproto" {
    name = "dmxproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/dmxproto-2.3.1.tar.bz2;
      sha256 = "02b5x9dkgajizm8dqyx2w6hmqx3v25l67mgf35nj6sz0lgk52877";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  dri2proto = (mkDerivation "dri2proto" {
    name = "dri2proto-2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri2proto-2.8.tar.bz2;
      sha256 = "015az1vfdqmil1yay5nlsmpf6cf7vcbpslxjb72cfkzlvrv59dgr";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  dri3proto = (mkDerivation "dri3proto" {
    name = "dri3proto-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri3proto-1.0.tar.bz2;
      sha256 = "0x609xvnl8jky5m8jdklw4nymx3irkv32w99dfd8nl800bblkgh1";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  encodings = (mkDerivation "encodings" {
    name = "encodings-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/encodings-1.0.4.tar.bz2;
      sha256 = "0ffmaw80vmfwdgvdkp6495xgsqszb6s0iira5j0j6pd4i0lk3mnf";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  fixesproto = (mkDerivation "fixesproto" {
    name = "fixesproto-5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/fixesproto-5.0.tar.bz2;
      sha256 = "1ki4wiq2iivx5g4w5ckzbjbap759kfqd72yg18m3zpbb4hqkybxs";
    };
    buildInputs = [pkgconfig xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xextproto ;};

  fontadobe100dpi = (mkDerivation "fontadobe100dpi" {
    name = "font-adobe-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-100dpi-1.0.3.tar.bz2;
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobe75dpi = (mkDerivation "fontadobe75dpi" {
    name = "font-adobe-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-75dpi-1.0.3.tar.bz2;
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia100dpi = (mkDerivation "fontadobeutopia100dpi" {
    name = "font-adobe-utopia-100dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-100dpi-1.0.4.tar.bz2;
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia75dpi = (mkDerivation "fontadobeutopia75dpi" {
    name = "font-adobe-utopia-75dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-75dpi-1.0.4.tar.bz2;
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopiatype1 = (mkDerivation "fontadobeutopiatype1" {
    name = "font-adobe-utopia-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-type1-1.0.4.tar.bz2;
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontalias = (mkDerivation "fontalias" {
    name = "font-alias-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-alias-1.0.3.tar.bz2;
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  fontarabicmisc = (mkDerivation "fontarabicmisc" {
    name = "font-arabic-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-arabic-misc-1.0.3.tar.bz2;
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontbh100dpi = (mkDerivation "fontbh100dpi" {
    name = "font-bh-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-100dpi-1.0.3.tar.bz2;
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbh75dpi = (mkDerivation "fontbh75dpi" {
    name = "font-bh-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-75dpi-1.0.3.tar.bz2;
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter100dpi = (mkDerivation "fontbhlucidatypewriter100dpi" {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2;
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter75dpi = (mkDerivation "fontbhlucidatypewriter75dpi" {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2;
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhttf = (mkDerivation "fontbhttf" {
    name = "font-bh-ttf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-ttf-1.0.3.tar.bz2;
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontbhtype1 = (mkDerivation "fontbhtype1" {
    name = "font-bh-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-type1-1.0.3.tar.bz2;
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontbitstream100dpi = (mkDerivation "fontbitstream100dpi" {
    name = "font-bitstream-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-100dpi-1.0.3.tar.bz2;
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontbitstream75dpi = (mkDerivation "fontbitstream75dpi" {
    name = "font-bitstream-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-75dpi-1.0.3.tar.bz2;
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontbitstreamtype1 = (mkDerivation "fontbitstreamtype1" {
    name = "font-bitstream-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-type1-1.0.3.tar.bz2;
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontcronyxcyrillic = (mkDerivation "fontcronyxcyrillic" {
    name = "font-cronyx-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cronyx-cyrillic-1.0.3.tar.bz2;
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontcursormisc = (mkDerivation "fontcursormisc" {
    name = "font-cursor-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cursor-misc-1.0.3.tar.bz2;
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontdaewoomisc = (mkDerivation "fontdaewoomisc" {
    name = "font-daewoo-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-daewoo-misc-1.0.3.tar.bz2;
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontdecmisc = (mkDerivation "fontdecmisc" {
    name = "font-dec-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-dec-misc-1.0.3.tar.bz2;
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontibmtype1 = (mkDerivation "fontibmtype1" {
    name = "font-ibm-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-ibm-type1-1.0.3.tar.bz2;
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontisasmisc = (mkDerivation "fontisasmisc" {
    name = "font-isas-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-isas-misc-1.0.3.tar.bz2;
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontjismisc = (mkDerivation "fontjismisc" {
    name = "font-jis-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-jis-misc-1.0.3.tar.bz2;
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontmicromisc = (mkDerivation "fontmicromisc" {
    name = "font-micro-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-micro-misc-1.0.3.tar.bz2;
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontmisccyrillic = (mkDerivation "fontmisccyrillic" {
    name = "font-misc-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-cyrillic-1.0.3.tar.bz2;
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontmiscethiopic = (mkDerivation "fontmiscethiopic" {
    name = "font-misc-ethiopic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-ethiopic-1.0.3.tar.bz2;
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontmiscmeltho = (mkDerivation "fontmiscmeltho" {
    name = "font-misc-meltho-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-meltho-1.0.3.tar.bz2;
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  fontmiscmisc = (mkDerivation "fontmiscmisc" {
    name = "font-misc-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-misc-1.1.2.tar.bz2;
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontmuttmisc = (mkDerivation "fontmuttmisc" {
    name = "font-mutt-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-mutt-misc-1.0.3.tar.bz2;
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontschumachermisc = (mkDerivation "fontschumachermisc" {
    name = "font-schumacher-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-schumacher-misc-1.1.2.tar.bz2;
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontscreencyrillic = (mkDerivation "fontscreencyrillic" {
    name = "font-screen-cyrillic-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-screen-cyrillic-1.0.4.tar.bz2;
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontsonymisc = (mkDerivation "fontsonymisc" {
    name = "font-sony-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sony-misc-1.0.3.tar.bz2;
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontsproto = (mkDerivation "fontsproto" {
    name = "fontsproto-2.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/fontsproto-2.1.3.tar.bz2;
      sha256 = "1f2sdsd74y34nnaf4m1zlcbhyv8xb6irnisc99f84c4ivnq4d415";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  fontsunmisc = (mkDerivation "fontsunmisc" {
    name = "font-sun-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sun-misc-1.0.3.tar.bz2;
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontutil = (mkDerivation "fontutil" {
    name = "font-util-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/font/font-util-1.3.1.tar.bz2;
      sha256 = "08drjb6cf84pf5ysghjpb4i7xkd2p86k3wl2a0jxs1jif6qbszma";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  fontwinitzkicyrillic = (mkDerivation "fontwinitzkicyrillic" {
    name = "font-winitzki-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-winitzki-cyrillic-1.0.3.tar.bz2;
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit bdftopcf mkfontdir ;};

  fontxfree86type1 = (mkDerivation "fontxfree86type1" {
    name = "font-xfree86-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-xfree86-type1-1.0.4.tar.bz2;
      sha256 = "0jp3zc0qfdaqfkgzrb44vi9vi0a8ygb35wp082yz7rvvxhmg9sya";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit mkfontdir mkfontscale ;};

  gccmakedep = (mkDerivation "gccmakedep" {
    name = "gccmakedep-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/gccmakedep-1.0.3.tar.bz2;
      sha256 = "1r1fpy5ni8chbgx7j5sz0008fpb6vbazpy1nifgdhgijyzqxqxdj";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  glamoregl = (mkDerivation "glamoregl" {
    name = "glamor-egl-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/glamor-egl-0.6.0.tar.bz2;
      sha256 = "1jg5clihklb9drh1jd7nhhdsszla6nv7xmbvm8yvakh5wrb1nlv6";
    };
    buildInputs = [pkgconfig dri2proto xorgserver ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit dri2proto xorgserver ;};

  glproto = (mkDerivation "glproto" {
    name = "glproto-1.4.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/glproto-1.4.17.tar.bz2;
      sha256 = "0h5ykmcddwid5qj6sbrszgkcypwn3mslvswxpgy2n2iixnyr9amd";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  iceauth = (mkDerivation "iceauth" {
    name = "iceauth-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/iceauth-1.0.7.tar.bz2;
      sha256 = "02izdyzhwpgiyjd8brzilwvwnfr72ncjb6mzz3y1icwrxqnsy5hj";
    };
    buildInputs = [pkgconfig libICE xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libICE xproto ;};

  imake = (mkDerivation "imake" {
    name = "imake-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.7.tar.bz2;
      sha256 = "0zpk8p044jh14bis838shbf4100bjg7mccd7bq54glpsq552q339";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  inputproto = (mkDerivation "inputproto" {
    name = "inputproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/inputproto-2.3.1.tar.bz2;
      sha256 = "1lf1jlxp0fc8h6fjdffhd084dqab94966l1zm3rwwsis0mifwiss";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  kbproto = (mkDerivation "kbproto" {
    name = "kbproto-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/kbproto-1.0.7.tar.bz2;
      sha256 = "0mxqj1pzhjpz9495vrjnpi10kv2n1s4vs7di0sh3yvipfq5j30pq";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  libAppleWM = (mkDerivation "libAppleWM" {
    name = "libAppleWM-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libAppleWM-1.4.1.tar.bz2;
      sha256 = "0r8x28n45q89x91mz8mv0zkkcxi8wazkac886fyvflhiv2y8ap2y";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit applewmproto libX11 libXext xextproto ;};

  libFS = (mkDerivation "libFS" {
    name = "libFS-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libFS-1.0.7.tar.bz2;
      sha256 = "1wy4km3qwwajbyl8y9pka0zwizn7d9pfiyjgzba02x3a083lr79f";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto xproto xtrans ;};

  libICE = (mkDerivation "libICE" {
    name = "libICE-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libICE-1.0.9.tar.bz2;
      sha256 = "00p2b6bsg6kcdbb39bv46339qcywxfl4hsrz8asm4hy6q7r34w4g";
    };
    buildInputs = [pkgconfig xproto xtrans ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto xtrans ;};

  libSM = (mkDerivation "libSM" {
    name = "libSM-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libSM-1.2.2.tar.bz2;
      sha256 = "1gc7wavgs435g9qkp9jw4lhmaiq6ip9llv49f054ad6ryp4sib0b";
    };
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libICE libuuid xproto xtrans ;};

  libWindowsWM = (mkDerivation "libWindowsWM" {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libWindowsWM-1.0.1.tar.bz2;
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit windowswmproto libX11 libXext xextproto ;};

  libX11 = (mkDerivation "libX11" {
    name = "libX11-1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.6.3.tar.bz2;
      sha256 = "04c1vj53xq2xgyxx5vhln3wm2d76hh1n95fvs3myhligkz1sfcfg";
    };
    buildInputs = [pkgconfig inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ;};

  libXScrnSaver = (mkDerivation "libXScrnSaver" {
    name = "libXScrnSaver-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXScrnSaver-1.2.2.tar.bz2;
      sha256 = "07ff4r20nkkrj7h08f9fwamds9b3imj8jz5iz6y38zqw6jkyzwcg";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit scrnsaverproto libX11 libXext xextproto ;};

  libXau = (mkDerivation "libXau" {
    name = "libXau-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXau-1.0.8.tar.bz2;
      sha256 = "1wm4pv12f36cwzhldpp7vy3lhm3xdcnp4f184xkxsp7b18r7gm7x";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  libXaw = (mkDerivation "libXaw" {
    name = "libXaw-1.0.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXaw-1.0.13.tar.bz2;
      sha256 = "1kdhxplwrn43d9jp3v54llp05kwx210lrsdvqb6944jp29rhdy4f";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXmu libXpm xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};

  libXcomposite = (mkDerivation "libXcomposite" {
    name = "libXcomposite-0.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcomposite-0.4.4.tar.bz2;
      sha256 = "0y21nfpa5s8qmx0srdlilyndas3sgl0c6rc26d5fx2vx436m1qpd";
    };
    buildInputs = [pkgconfig compositeproto libX11 libXfixes xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit compositeproto libX11 libXfixes xproto ;};

  libXcursor = (mkDerivation "libXcursor" {
    name = "libXcursor-1.1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcursor-1.1.14.tar.bz2;
      sha256 = "1prkdicl5y5yx32h1azh6gjfbijvjp415javv8dsakd13jrarilv";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};

  libXdamage = (mkDerivation "libXdamage" {
    name = "libXdamage-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXdamage-1.1.4.tar.bz2;
      sha256 = "1bamagq7g6s0d23l8rb3nppj8ifqj05f7z9bhbs4fdg8az3ffgvw";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};

  libXdmcp = (mkDerivation "libXdmcp" {
    name = "libXdmcp-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXdmcp-1.1.2.tar.bz2;
      sha256 = "1qp4yhxbfnpj34swa0fj635kkihdkwaiw7kf55cg5zqqg630kzl1";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  libXext = (mkDerivation "libXext" {
    name = "libXext-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXext-1.3.3.tar.bz2;
      sha256 = "0dbfn5bznnrhqzvkrcmw4c44yvvpwdcsrvzxf4rk27r36b9x865m";
    };
    buildInputs = [pkgconfig libX11 xextproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xextproto xproto ;};

  libXfixes = (mkDerivation "libXfixes" {
    name = "libXfixes-5.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfixes-5.0.1.tar.bz2;
      sha256 = "0rs7qgzr6dpr62db7sd91c1b47hzhzfr010qwnpcm8sg122w1gk3";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fixesproto libX11 xextproto xproto ;};

  libXfont = (mkDerivation "libXfont" {
    name = "libXfont-1.5.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfont-1.5.1.tar.bz2;
      sha256 = "1630v3sfvwwlimb2ja10c84ql6v1mw9bdfhvan7pbybkgi99h25p";
    };
    buildInputs = [pkgconfig libfontenc fontsproto freetype xproto xtrans zlib ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libfontenc fontsproto freetype xproto xtrans zlib ;};

  libXfont2 = (mkDerivation "libXfont2" {
    name = "libXfont2-2.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfont2-2.0.1.tar.bz2;
      sha256 = "0znvwk36nhmyqpmhbm9mzisgixp1mp5qkfald8x1n5yxbm3vpyz9";
    };
    buildInputs = [pkgconfig libfontenc fontsproto freetype xproto xtrans zlib ];
  }) // {inherit libfontenc fontsproto freetype xproto xtrans zlib ;};

  libXft = (mkDerivation "libXft" {
    name = "libXft-2.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXft-2.3.2.tar.bz2;
      sha256 = "0k6wzi5rzs0d0n338ms8n8lfyhq914hw4yl2j7553wqxfqjci8zm";
    };
    buildInputs = [pkgconfig fontconfig freetype libX11 xproto libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontconfig freetype libX11 xproto libXrender ;};

  libXi = (mkDerivation "libXi" {
    name = "libXi-1.7.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXi-1.7.6.tar.bz2;
      sha256 = "1b5p0l19ynmd6blnqr205wyngh6fagl35nqb4v05dw60rr9aachz";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto libXfixes xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto libX11 libXext xextproto libXfixes xproto ;};

  libXinerama = (mkDerivation "libXinerama" {
    name = "libXinerama-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXinerama-1.1.3.tar.bz2;
      sha256 = "1qlqfvzw45gdzk9xirgwlp2qgj0hbsyiqj8yh8zml2bk2ygnjibs";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xineramaproto ;};

  libXmu = (mkDerivation "libXmu" {
    name = "libXmu-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXmu-1.1.2.tar.bz2;
      sha256 = "02wx6jw7i0q5qwx87yf94fsn3h0xpz1k7dz1nkwfwm1j71ydqvkm";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXp = (mkDerivation "libXp" {
    name = "libXp-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.3.tar.bz2;
      sha256 = "0mwc2jwmq03b1m9ihax5c6gw2ln8rc70zz4fsj3kb7440nchqdkz";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit printproto libX11 libXau libXext xextproto ;};

  libXpm = (mkDerivation "libXpm" {
    name = "libXpm-3.5.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXpm-3.5.11.tar.bz2;
      sha256 = "07041q4k8m4nirzl7lrqn8by2zylx0xvh6n0za301qqs3njszgf5";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXpresent = (mkDerivation "libXpresent" {
    name = "libXpresent-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXpresent-1.0.0.tar.bz2;
      sha256 = "12kvvar3ihf6sw49h6ywfdiwmb8i1gh8wasg1zhzp6hs2hay06n1";
    };
    buildInputs = [pkgconfig presentproto libX11 xextproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit presentproto libX11 xextproto xproto ;};

  libXrandr = (mkDerivation "libXrandr" {
    name = "libXrandr-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrandr-1.5.0.tar.bz2;
      sha256 = "0n6ycs1arf4wb1cal9il6v7vbxbf21qhs9sbfl8xndgwnxclk1kg";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};

  libXrender = (mkDerivation "libXrender" {
    name = "libXrender-0.9.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrender-0.9.9.tar.bz2;
      sha256 = "06myx7044qqdswxndsmd82fpp670klnizkgzdm194h51h1wyabzw";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit renderproto libX11 xproto ;};

  libXres = (mkDerivation "libXres" {
    name = "libXres-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXres-1.0.7.tar.bz2;
      sha256 = "1rd0bzn67cpb2qkc946gch2183r4bdjfhs6cpqbipy47m9a91296";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit resourceproto libX11 libXext xextproto xproto ;};

  libXt = (mkDerivation "libXt" {
    name = "libXt-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXt-1.1.5.tar.bz2;
      sha256 = "06lz6i7rbrp19kgikpaz4c97fw7n31k2h2aiikczs482g2zbdvj6";
    };
    buildInputs = [pkgconfig libICE kbproto libSM libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libICE kbproto libSM libX11 xproto ;};

  libXtst = (mkDerivation "libXtst" {
    name = "libXtst-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXtst-1.2.2.tar.bz2;
      sha256 = "1ngn161nq679ffmbwl81i2hn75jjg5b3ffv6n4jilpvyazypy2pg";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto libXi ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto recordproto libX11 libXext xextproto libXi ;};

  libXv = (mkDerivation "libXv" {
    name = "libXv-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXv-1.0.10.tar.bz2;
      sha256 = "09a5j6bisysiipd0nw6s352565bp0n6gbyhv5hp63s3cd3w95zjm";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit videoproto libX11 libXext xextproto xproto ;};

  libXvMC = (mkDerivation "libXvMC" {
    name = "libXvMC-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXvMC-1.0.9.tar.bz2;
      sha256 = "0mjp1b21dvkaz7r0iq085r92nh5vkpmx99awfgqq9hgzyvgxf0q7";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};

  libXxf86dga = (mkDerivation "libXxf86dga" {
    name = "libXxf86dga-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86dga-1.1.4.tar.bz2;
      sha256 = "0zn7aqj8x0951d8zb2h2andldvwkzbsc4cs7q023g6nzq6vd9v4f";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};

  libXxf86misc = (mkDerivation "libXxf86misc" {
    name = "libXxf86misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86misc-1.0.3.tar.bz2;
      sha256 = "0nvbq9y6k6m9hxdvg3crycqsnnxf1859wrisqcs37z9fhq044gsn";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};

  libXxf86vm = (mkDerivation "libXxf86vm" {
    name = "libXxf86vm-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86vm-1.1.4.tar.bz2;
      sha256 = "0mydhlyn72i7brjwypsqrpkls3nm6vxw0li8b2nw0caz7kwjgvmg";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};

  libdmx = (mkDerivation "libdmx" {
    name = "libdmx-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libdmx-1.1.3.tar.bz2;
      sha256 = "00djlxas38kbsrglcmwmxfbmxjdchlbj95pqwjvdg8jn5rns6zf9";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit dmxproto libX11 libXext xextproto ;};

  libfontenc = (mkDerivation "libfontenc" {
    name = "libfontenc-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libfontenc-1.1.3.tar.bz2;
      sha256 = "08gxmrhgw97mv0pvkfmd46zzxrn6zdw4g27073zl55gwwqq8jn3h";
    };
    buildInputs = [pkgconfig xproto zlib ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto zlib ;};

  libpciaccess = (mkDerivation "libpciaccess" {
    name = "libpciaccess-0.13.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.13.4.tar.bz2;
      sha256 = "1krgryi9ngjr66242v0v5mczihgv0y7rrvx0563arr318mjn9y07";
    };
    buildInputs = [pkgconfig zlib ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit zlib ;};

  libpthreadstubs = (mkDerivation "libpthreadstubs" {
    name = "libpthread-stubs-0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.bz2;
      sha256 = "16bjv3in19l84hbri41iayvvg4ls9gv1ma0x0qlbmwy67i7dbdim";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  libxcb = (mkDerivation "libxcb" {
    name = "libxcb-1.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.11.1.tar.bz2;
      sha256 = "0c4xyvdyx5adh8dzyhnrmvwwz24gri4z1czxmxqm63i0gmngs85p";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};

  libxkbfile = (mkDerivation "libxkbfile" {
    name = "libxkbfile-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libxkbfile-1.0.9.tar.bz2;
      sha256 = "0smimr14zvail7ar68n7spvpblpdnih3jxrva7cpa6cn602px0ai";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit kbproto libX11 ;};

  libxshmfence = (mkDerivation "libxshmfence" {
    name = "libxshmfence-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libxshmfence-1.2.tar.bz2;
      sha256 = "032b0nlkdrpbimdld4gqvhqx53rzn8fawvf1ybhzn7lcswgjs6yj";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  lndir = (mkDerivation "lndir" {
    name = "lndir-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.3.tar.bz2;
      sha256 = "0pdngiy8zdhsiqx2am75yfcl36l7kd7d7nl0rss8shcdvsqgmx29";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  luit = (mkDerivation "luit" {
    name = "luit-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/luit-1.1.1.tar.bz2;
      sha256 = "0dn694mk56x6hdk6y9ylx4f128h5jcin278gnw2gb807rf3ygc1h";
    };
    buildInputs = [pkgconfig libfontenc ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libfontenc ;};

  makedepend = (mkDerivation "makedepend" {
    name = "makedepend-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/makedepend-1.0.5.tar.bz2;
      sha256 = "09alw99r6y2bbd1dc786n3jfgv4j520apblyn7cw6jkjydshba7p";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  mkfontdir = (mkDerivation "mkfontdir" {
    name = "mkfontdir-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/mkfontdir-1.0.7.tar.bz2;
      sha256 = "0c3563kw9fg15dpgx4dwvl12qz6sdqdns1pxa574hc7i5m42mman";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  mkfontscale = (mkDerivation "mkfontscale" {
    name = "mkfontscale-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/mkfontscale-1.1.2.tar.bz2;
      sha256 = "081z8lwh9c1gyrx3ad12whnpv3jpfbqsc366mswpfm48mwl54vcc";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libfontenc freetype xproto zlib ;};

  presentproto = (mkDerivation "presentproto" {
    name = "presentproto-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/presentproto-1.0.tar.bz2;
      sha256 = "1kir51aqg9cwazs14ivcldcn3mzadqgykc9cg87rm40zf947sb41";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  printproto = (mkDerivation "printproto" {
    name = "printproto-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/printproto-1.0.5.tar.bz2;
      sha256 = "06liap8n4s25sgp27d371cc7yg9a08dxcr3pmdjp761vyin3360j";
    };
    buildInputs = [pkgconfig libXau ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXau ;};

  randrproto = (mkDerivation "randrproto" {
    name = "randrproto-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/randrproto-1.5.0.tar.bz2;
      sha256 = "0s4496z61y5q45q20gldwpf788b9nsa8hb13gnck1mwwwwrmarsc";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  recordproto = (mkDerivation "recordproto" {
    name = "recordproto-1.14.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/recordproto-1.14.2.tar.bz2;
      sha256 = "0w3kgr1zabwf79bpc28dcnj0fpni6r53rpi82ngjbalj5s6m8xx7";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  renderproto = (mkDerivation "renderproto" {
    name = "renderproto-0.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/renderproto-0.11.1.tar.bz2;
      sha256 = "0dr5xw6s0qmqg0q5pdkb4jkdhaja0vbfqla79qh5j1xjj9dmlwq6";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  resourceproto = (mkDerivation "resourceproto" {
    name = "resourceproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/resourceproto-1.2.0.tar.bz2;
      sha256 = "0638iyfiiyjw1hg3139pai0j6m65gkskrvd9684zgc6ydcx00riw";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  scrnsaverproto = (mkDerivation "scrnsaverproto" {
    name = "scrnsaverproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/scrnsaverproto-1.2.2.tar.bz2;
      sha256 = "0rfdbfwd35d761xkfifcscx56q0n56043ixlmv70r4v4l66hmdwb";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  sessreg = (mkDerivation "sessreg" {
    name = "sessreg-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/sessreg-1.1.0.tar.bz2;
      sha256 = "0z013rskwmdadd8cdlxvh4asmgim61qijyzfbqmr1q1mg1jpf4am";
    };
    buildInputs = [pkgconfig xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xproto ;};

  setxkbmap = (mkDerivation "setxkbmap" {
    name = "setxkbmap-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/setxkbmap-1.3.1.tar.bz2;
      sha256 = "1qfk097vjysqb72pq89h0la3462kbb2dh1d11qzs2fr67ybb7pd9";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libxkbfile ;};

  smproxy = (mkDerivation "smproxy" {
    name = "smproxy-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/smproxy-1.0.6.tar.bz2;
      sha256 = "0rkjyzmsdqmlrkx8gy2j4q6iksk58hcc92xzdprkf8kml9ar3wbc";
    };
    buildInputs = [pkgconfig libICE libSM libXmu libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libICE libSM libXmu libXt ;};

  twm = (mkDerivation "twm" {
    name = "twm-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/twm-1.0.9.tar.bz2;
      sha256 = "02iicvhkp3i7q5rliyymiq9bppjr0pzfs6rgb78kppryqdx1cxf5";
    };
    buildInputs = [pkgconfig libICE libSM libX11 libXext libXmu xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libICE libSM libX11 libXext libXmu xproto libXt ;};

  utilmacros = (mkDerivation "utilmacros" {
    name = "util-macros-1.19.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/util-macros-1.19.0.tar.bz2;
      sha256 = "1fnhpryf55l0yqajxn0cxan3kvsjzi67nlanz8clwqzf54cb2d98";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  videoproto = (mkDerivation "videoproto" {
    name = "videoproto-2.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/videoproto-2.3.2.tar.bz2;
      sha256 = "1dnlkd9nb0m135lgd6hd61vc29sdyarsyya8aqpx7z10p261dbld";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  windowswmproto = (mkDerivation "windowswmproto" {
    name = "windowswmproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/windowswmproto-1.0.4.tar.bz2;
      sha256 = "0syjxgy4m8l94qrm03nvn5k6bkxc8knnlld1gbllym97nvnv0ny0";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  x11perf = (mkDerivation "x11perf" {
    name = "x11perf-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/x11perf-1.6.0.tar.bz2;
      sha256 = "0lb716yfdb8f11h4cz93d1bapqdxf1xplsb21kbp4xclq7g9hw78";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu xproto libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext libXft libXmu xproto libXrender ;};

  xauth = (mkDerivation "xauth" {
    name = "xauth-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xauth-1.0.9.tar.bz2;
      sha256 = "13y2invb0894b1in03jbglximbz6v31y2kr4yjjgica8xciibkjn";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXau libXext libXmu xproto ;};

  xbacklight = (mkDerivation "xbacklight" {
    name = "xbacklight-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xbacklight-1.2.1.tar.bz2;
      sha256 = "0arnd1j8vzhzmw72mqhjjcb2qwcbs9qphsy3ps593ajyld8wzxhp";
    };
    buildInputs = [pkgconfig libxcb xcbutil ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libxcb xcbutil ;};

  xbitmaps = (mkDerivation "xbitmaps" {
    name = "xbitmaps-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xbitmaps-1.1.1.tar.bz2;
      sha256 = "178ym90kwidia6nas4qr5n5yqh698vv8r02js0r4vg3b6lsb0w9n";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xcbproto = (mkDerivation "xcbproto" {
    name = "xcb-proto-1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.11.tar.bz2;
      sha256 = "0bp3f53l9fy5x3mn1rkj1g81aiyzl90wacwvqdgy831aa3kfxb5l";
    };
    buildInputs = [pkgconfig python ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit python ;};

  xcbutil = (mkDerivation "xcbutil" {
    name = "xcb-util-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2;
      sha256 = "1sahmrgbpyki4bb72hxym0zvxwnycmswsxiisgqlln9vrdlr9r26";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilcursor = (mkDerivation "xcbutilcursor" {
    name = "xcb-util-cursor-0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.2.tar.bz2;
      sha256 = "0fpv46zb7kz04qxwvpax4cpd2kd8yhsm2n0if1isniqdh5xkcrgd";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbutilimage xcbutilrenderutil xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xcbutilimage xcbutilrenderutil xproto ;};

  xcbutilerrors = (mkDerivation "xcbutilerrors" {
    name = "xcb-util-errors-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-errors-1.0.tar.bz2;
      sha256 = "158rm913dg3hxrrhyvvxr8bcm0pjy5jws70dhy2s12w1krv829k8";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbproto xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xcbproto xproto ;};

  xcbutilimage = (mkDerivation "xcbutilimage" {
    name = "xcb-util-image-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2;
      sha256 = "1z1gxacg7q4cw6jrd26gvi5y04npsyavblcdad1xccc8swvnmf9d";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbutil xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xcbutil xproto ;};

  xcbutilkeysyms = (mkDerivation "xcbutilkeysyms" {
    name = "xcb-util-keysyms-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2;
      sha256 = "1nbd45pzc1wm6v5drr5338j4nicbgxa5hcakvsvm5pnyy47lky0f";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilrenderutil = (mkDerivation "xcbutilrenderutil" {
    name = "xcb-util-renderutil-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2;
      sha256 = "0nza1csdvvxbmk8vgv8vpmq7q8h05xrw3cfx9lwxd1hjzd47xsf6";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilwm = (mkDerivation "xcbutilwm" {
    name = "xcb-util-wm-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2;
      sha256 = "0gra7hfyxajic4mjd63cpqvd20si53j1q3rbdlkqkahfciwq3gr8";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit gperf m4 libxcb xproto ;};

  xclock = (mkDerivation "xclock" {
    name = "xclock-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.7.tar.bz2;
      sha256 = "1l3xv4bsca6bwxx73jyjz0blav86i7vwffkhdb1ac81y9slyrki3";
    };
    buildInputs = [pkgconfig libX11 libXaw libXft libxkbfile libXmu xproto libXrender libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXaw libXft libxkbfile libXmu xproto libXrender libXt ;};

  xcmiscproto = (mkDerivation "xcmiscproto" {
    name = "xcmiscproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcmiscproto-1.2.2.tar.bz2;
      sha256 = "1pyjv45wivnwap2wvsbrzdvjc5ql8bakkbkrvcv6q9bjjf33ccmi";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xcmsdb = (mkDerivation "xcmsdb" {
    name = "xcmsdb-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xcmsdb-1.0.5.tar.bz2;
      sha256 = "1ik7gzlp2igz183x70883000ygp99r20x3aah6xhaslbpdhm6n75";
    };
    buildInputs = [pkgconfig libX11 ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 ;};

  xcompmgr = (mkDerivation "xcompmgr" {
    name = "xcompmgr-1.1.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xcompmgr-1.1.7.tar.bz2;
      sha256 = "14k89mz13jxgp4h2pz0yq0fbkw1lsfcb3acv8vkknc9i4ld9n168";
    };
    buildInputs = [pkgconfig libXcomposite libXdamage libXext libXfixes libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXcomposite libXdamage libXext libXfixes libXrender ;};

  xcursorgen = (mkDerivation "xcursorgen" {
    name = "xcursorgen-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xcursorgen-1.0.6.tar.bz2;
      sha256 = "0v7nncj3kaa8c0524j7ricdf4rvld5i7c3m6fj55l5zbah7r3j1i";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libpng libX11 libXcursor ;};

  xcursorthemes = (mkDerivation "xcursorthemes" {
    name = "xcursor-themes-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/data/xcursor-themes-1.0.4.tar.bz2;
      sha256 = "11mv661nj1p22sqkv87ryj2lcx4m68a04b0rs6iqh3fzp42jrzg3";
    };
    buildInputs = [pkgconfig libXcursor ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXcursor ;};

  xdm = (mkDerivation "xdm" {
    name = "xdm-1.1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdm-1.1.11.tar.bz2;
      sha256 = "0iqw11977lpr9nk1is4fca84d531vck0mq7jldwl44m0vrnl5nnl";
    };
    buildInputs = [pkgconfig libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};

  xdpyinfo = (mkDerivation "xdpyinfo" {
    name = "xdpyinfo-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdpyinfo-1.3.2.tar.bz2;
      sha256 = "0ldgrj4w2fa8jng4b3f3biaj0wyn8zvya88pnk70d7k12pcqw8rh";
    };
    buildInputs = [pkgconfig libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};

  xdriinfo = (mkDerivation "xdriinfo" {
    name = "xdriinfo-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdriinfo-1.0.5.tar.bz2;
      sha256 = "0681d0y8liqakkpz7mmsf689jcxrvs5291r20qi78mc9xxk3gfjc";
    };
    buildInputs = [pkgconfig glproto libX11 ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit glproto libX11 ;};

  xev = (mkDerivation "xev" {
    name = "xev-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xev-1.2.2.tar.bz2;
      sha256 = "0krivhrxpq6719103r541xpi3i3a0y15f7ypc4lnrx8sdhmfcjnr";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto libXrandr ;};

  xextproto = (mkDerivation "xextproto" {
    name = "xextproto-7.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xextproto-7.3.0.tar.bz2;
      sha256 = "1c2vma9gqgc2v06rfxdiqgwhxmzk2cbmknwf1ng3m76vr0xb5x7k";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xeyes = (mkDerivation "xeyes" {
    name = "xeyes-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xeyes-1.1.1.tar.bz2;
      sha256 = "08d5x2kar5kg4yammw6hhk10iva6jmh8cqq176a1z7nm1il9hplp";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXrender libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext libXmu libXrender libXt ;};

  xf86bigfontproto = (mkDerivation "xf86bigfontproto" {
    name = "xf86bigfontproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86bigfontproto-1.2.0.tar.bz2;
      sha256 = "0j0n7sj5xfjpmmgx6n5x556rw21hdd18fwmavp95wps7qki214ms";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xf86dgaproto = (mkDerivation "xf86dgaproto" {
    name = "xf86dgaproto-2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86dgaproto-2.1.tar.bz2;
      sha256 = "0l4hx48207mx0hp09026r6gy9nl3asbq0c75hri19wp1118zcpmc";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xf86driproto = (mkDerivation "xf86driproto" {
    name = "xf86driproto-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86driproto-2.1.1.tar.bz2;
      sha256 = "07v69m0g2dfzb653jni4x656jlr7l84c1k39j8qc8vfb45r8sjww";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xf86inputevdev = (mkDerivation "xf86inputevdev" {
    name = "xf86-input-evdev-2.10.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.10.1.tar.bz2;
      sha256 = "05z05n39v8s2b0hwhcjb1bca7j8gc62bv9jxnibawwmjym3jp75g";
    };
    buildInputs = [pkgconfig inputproto udev xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto udev xorgserver xproto ;};

  xf86inputjoystick = (mkDerivation "xf86inputjoystick" {
    name = "xf86-input-joystick-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-joystick-1.6.2.tar.bz2;
      sha256 = "038mfqairyyqvz02rk7v3i070sab1wr0k6fkxvyvxdgkfbnqcfzf";
    };
    buildInputs = [pkgconfig inputproto kbproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto kbproto xorgserver xproto ;};

  xf86inputkeyboard = (mkDerivation "xf86inputkeyboard" {
    name = "xf86-input-keyboard-1.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-keyboard-1.8.1.tar.bz2;
      sha256 = "04d27kwqq03fc26an6051hs3i0bff8albhnngzyd59wxpwwzzj0s";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputlibinput = (mkDerivation "xf86inputlibinput" {
    name = "xf86-input-libinput-0.16.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-libinput-0.16.0.tar.bz2;
      sha256 = "0jbgnxsbr3g4g9vkspcc6pqy7av59zx5bb78vkvaqy8yx4qybbgx";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputmouse = (mkDerivation "xf86inputmouse" {
    name = "xf86-input-mouse-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-mouse-1.9.1.tar.bz2;
      sha256 = "1kn5kx3qyn9qqvd6s24a2l1wfgck2pgfvzl90xpl024wfxsx719l";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputsynaptics = (mkDerivation "xf86inputsynaptics" {
    name = "xf86-input-synaptics-1.8.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-synaptics-1.8.3.tar.bz2;
      sha256 = "009zx199pilcvlaqm6fx4mg94q81d6vvl5rznmw3frzkfh6117yk";
    };
    buildInputs = [pkgconfig inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ;};

  xf86inputvmmouse = (mkDerivation "xf86inputvmmouse" {
    name = "xf86-input-vmmouse-13.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2;
      sha256 = "06ckn4hlkpig5vnivl0zj8a7ykcgvrsj8b3iccl1pgn1gaamix8a";
    };
    buildInputs = [pkgconfig inputproto udev randrproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto udev randrproto xorgserver xproto ;};

  xf86inputvoid = (mkDerivation "xf86inputvoid" {
    name = "xf86-input-void-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-void-1.4.1.tar.bz2;
      sha256 = "171k8b8s42s3w73l7ln9jqwk88w4l7r1km2blx1vy898c854yvpr";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xorgserver xproto ;};

  xf86miscproto = (mkDerivation "xf86miscproto" {
    name = "xf86miscproto-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xf86miscproto-0.9.3.tar.bz2;
      sha256 = "15dhcdpv61fyj6rhzrhnwri9hlw8rjfy05z1vik118lc99mfrf25";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xf86videoark = (mkDerivation "xf86videoark" {
    name = "xf86-video-ark-0.7.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ark-0.7.5.tar.bz2;
      sha256 = "07p5vdsj2ckxb6wh02s61akcv4qfg6s1d5ld3jn3lfaayd3f1466";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess xextproto xorgserver xproto ;};

  xf86videoast = (mkDerivation "xf86videoast" {
    name = "xf86-video-ast-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ast-1.1.5.tar.bz2;
      sha256 = "1pm2cy81ma7ldsw0yfk28b33h9z2hcj5rccrxhfxfgvxsiavrnqy";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoati = (mkDerivation "xf86videoati" {
    name = "xf86-video-ati-7.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-7.6.1.tar.bz2;
      sha256 = "0k6kw69mcarlmxlb4jlhz887jxqr94qx2pin04xcv2ysp3pdj5i5";
    };
    buildInputs = [pkgconfig fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videochips = (mkDerivation "xf86videochips" {
    name = "xf86-video-chips-1.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-chips-1.2.6.tar.bz2;
      sha256 = "073bcdsvvsg19mb963sa5v7x2zs19y0q6javmgpiwfaqkz7zbblr";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videocirrus = (mkDerivation "xf86videocirrus" {
    name = "xf86-video-cirrus-1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-cirrus-1.5.3.tar.bz2;
      sha256 = "1asifc6ld2g9kap15vfhvsvyl69lj7pw3d9ra9mi4najllh7pj7d";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videodummy = (mkDerivation "xf86videodummy" {
    name = "xf86-video-dummy-0.3.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-dummy-0.3.7.tar.bz2;
      sha256 = "1046p64xap69vlsmsz5rjv0djc970yhvq44fmllmas0mqp5lzy2n";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};

  xf86videofbdev = (mkDerivation "xf86videofbdev" {
    name = "xf86-video-fbdev-0.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2;
      sha256 = "06ym7yy017lanj730hfkpfk4znx3dsj8jq3qvyzsn8w294kb7m4x";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};

  xf86videogeode = (mkDerivation "xf86videogeode" {
    name = "xf86-video-geode-2.11.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-geode-2.11.17.tar.bz2;
      sha256 = "0h9w6cfj7s86rg72c6qci8f733hg4g7paan5fwmmj7p74ckd9d07";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoglide = (mkDerivation "xf86videoglide" {
    name = "xf86-video-glide-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glide-1.2.2.tar.bz2;
      sha256 = "1vaav6kx4n00q4fawgqnjmbdkppl0dir2dkrj4ad372mxrvl9c4y";
    };
    buildInputs = [pkgconfig xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xextproto xorgserver xproto ;};

  xf86videoglint = (mkDerivation "xf86videoglint" {
    name = "xf86-video-glint-1.2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glint-1.2.8.tar.bz2;
      sha256 = "08a2aark2yn9irws9c78d9q44dichr03i9zbk61jgr54ncxqhzv5";
    };
    buildInputs = [pkgconfig libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videoi128 = (mkDerivation "xf86videoi128" {
    name = "xf86-video-i128-1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-i128-1.3.6.tar.bz2;
      sha256 = "171b8lbxr56w3isph947dnw7x87hc46v6m3mcxdcz44gk167x0pq";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoi740 = (mkDerivation "xf86videoi740" {
    name = "xf86-video-i740-1.3.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-i740-1.3.5.tar.bz2;
      sha256 = "0973zzmdsvlmplcax1c91is7v78lcwy6d9mwp11npgqzl782vq0w";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videointel = (mkDerivation "xf86videointel" {
    name = "xf86-video-intel-2015-11-14";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/0340718366d7cb168a46930eb7be22f2d88354d8.tar.gz;
      sha256 = "0x11dig1wmpjz5n35sh30zs58ar8q8836w3zrkwkvgxj6q6smvvr";
    };
    buildInputs = [pkgconfig dri2proto dri3proto fontsproto libdrm libpng udev libpciaccess presentproto randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes xorgserver xproto libXrandr libXrender libxshmfence libXtst libXvMC ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit dri2proto dri3proto fontsproto libdrm libpng udev libpciaccess presentproto randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes xorgserver xproto libXrandr libXrender libxshmfence libXtst libXvMC ;};

  xf86videomach64 = (mkDerivation "xf86videomach64" {
    name = "xf86-video-mach64-6.9.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mach64-6.9.5.tar.bz2;
      sha256 = "07xlf5nsjm0x18ij5gyy4lf8hwpl10i8chi3skpqjh84drdri61y";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videomga = (mkDerivation "xf86videomga" {
    name = "xf86-video-mga-1.6.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mga-1.6.4.tar.bz2;
      sha256 = "0kyl8w99arviv27pc349zsy2vinnm7mdpy34vr9nzisicw5nkij8";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videomodesetting = (mkDerivation "xf86videomodesetting" {
    name = "xf86-video-modesetting-0.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-modesetting-0.9.0.tar.bz2;
      sha256 = "0p6pjn5bnd2wr3lmas4b12zcq12d9ilvssga93fzlg90fdahikwh";
    };
    buildInputs = [pkgconfig fontsproto libdrm udev libpciaccess randrproto libX11 xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm udev libpciaccess randrproto libX11 xextproto xorgserver xproto ;};

  xf86videoneomagic = (mkDerivation "xf86videoneomagic" {
    name = "xf86-video-neomagic-1.2.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-neomagic-1.2.9.tar.bz2;
      sha256 = "1whb2kgyqaxdjim27ya404acz50izgmafwnb6y9m89q5n6b97y3j";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess xorgserver xproto ;};

  xf86videonewport = (mkDerivation "xf86videonewport" {
    name = "xf86-video-newport-0.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-newport-0.2.4.tar.bz2;
      sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};

  xf86videonouveau = (mkDerivation "xf86videonouveau" {
    name = "xf86-video-nouveau-1.0.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nouveau-1.0.12.tar.bz2;
      sha256 = "07irv1zkk0rkyn1d7f2gn1icgcz2ix0pwv74sjian763gynmg80f";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videonv = (mkDerivation "xf86videonv" {
    name = "xf86-video-nv-2.1.20";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nv-2.1.20.tar.bz2;
      sha256 = "1gqh1khc4zalip5hh2nksgs7i3piqq18nncgmsx9qvzi05azd5c3";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoopenchrome = (mkDerivation "xf86videoopenchrome" {
    name = "xf86-video-openchrome-0.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-openchrome-0.3.3.tar.bz2;
      sha256 = "1v8j4i1r268n4fc5gq54zg1x50j0rhw71f3lba7411mcblg2z7p4";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ;};

  xf86videoqxl = (mkDerivation "xf86videoqxl" {
    name = "xf86-video-qxl-0.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-qxl-0.1.3.tar.bz2;
      sha256 = "1368dd5mihn3s098n7wa3fpjkp8pnamabfjjipkqs9zyrcvncy3m";
    };
    buildInputs = [pkgconfig fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};

  xf86videor128 = (mkDerivation "xf86videor128" {
    name = "xf86-video-r128-6.10.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-r128-6.10.0.tar.bz2;
      sha256 = "0g9m1n5184h05mq14vb6k288zm6g81a9m048id00l8v8f6h33mc0";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ;};

  xf86videorendition = (mkDerivation "xf86videorendition" {
    name = "xf86-video-rendition-4.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-rendition-4.2.6.tar.bz2;
      sha256 = "1a7rqafxzc2hd0s5pnq8s8j9d3jg64ndc0xnq4160kasyqhwy3k6";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videos3virge = (mkDerivation "xf86videos3virge" {
    name = "xf86-video-s3virge-1.10.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-s3virge-1.10.7.tar.bz2;
      sha256 = "1nm4cngjbw226q63rdacw6nx5lgxv7l7rsa8vhpr0gs80pg6igjx";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videosavage = (mkDerivation "xf86videosavage" {
    name = "xf86-video-savage-2.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-savage-2.3.8.tar.bz2;
      sha256 = "0qzshncynjdmyhavhqw4x5ha3gwbygi0zbsy158fpg1jcnla9kpx";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videosiliconmotion = (mkDerivation "xf86videosiliconmotion" {
    name = "xf86-video-siliconmotion-1.7.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.8.tar.bz2;
      sha256 = "1sqv0y31mi4zmh9yaxqpzg7p8y2z01j6qys433hb8n4yznllkm79";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess videoproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess videoproto xextproto xorgserver xproto ;};

  xf86videosis = (mkDerivation "xf86videosis" {
    name = "xf86-video-sis-0.10.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sis-0.10.8.tar.bz2;
      sha256 = "1znkqwdyd6am23xbsfjzamq125j5rrylg5mzqky4scv9gxbz5wy8";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86videosuncg6 = (mkDerivation "xf86videosuncg6" {
    name = "xf86-video-suncg6-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-suncg6-1.1.2.tar.bz2;
      sha256 = "04fgwgk02m4nimlv67rrg1wnyahgymrn6rb2cjj1l8bmzkii4glr";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosunffb = (mkDerivation "xf86videosunffb" {
    name = "xf86-video-sunffb-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sunffb-1.2.2.tar.bz2;
      sha256 = "07z3ngifwg2d4jgq8pms47n5lr2yn0ai72g86xxjnb3k20n5ym7s";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};

  xf86videotdfx = (mkDerivation "xf86videotdfx" {
    name = "xf86-video-tdfx-1.4.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tdfx-1.4.6.tar.bz2;
      sha256 = "0dvdrhyn1iv6rr85v1c52s1gl0j1qrxgv7x0r7qn3ba0gj38i2is";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videotga = (mkDerivation "xf86videotga" {
    name = "xf86-video-tga-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2;
      sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videotrident = (mkDerivation "xf86videotrident" {
    name = "xf86-video-trident-1.3.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-trident-1.3.7.tar.bz2;
      sha256 = "1bhkwic2acq9za4yz4bwj338cwv5mdrgr2qmgkhlj3bscbg1imgc";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videov4l = (mkDerivation "xf86videov4l" {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit randrproto videoproto xorgserver xproto ;};

  xf86videovesa = (mkDerivation "xf86videovesa" {
    name = "xf86-video-vesa-2.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vesa-2.3.4.tar.bz2;
      sha256 = "1haiw8r1z8ihk68d0jqph2wsld13w4qkl86biq46fvyxg7cg9pbv";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videovmware = (mkDerivation "xf86videovmware" {
    name = "xf86-video-vmware-13.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vmware-13.1.0.tar.bz2;
      sha256 = "1k50whwnkzxam2ihc1sw456dx0pvr76naycm4qhyjxqv9d72879w";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ;};

  xf86videovoodoo = (mkDerivation "xf86videovoodoo" {
    name = "xf86-video-voodoo-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-voodoo-1.2.5.tar.bz2;
      sha256 = "1s6p7yxmi12q4y05va53rljwyzd6ry492r1pgi7wwq6cznivhgly";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videowsfb = (mkDerivation "xf86videowsfb" {
    name = "xf86-video-wsfb-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-wsfb-0.4.0.tar.bz2;
      sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit xorgserver xproto ;};

  xf86videoxgi = (mkDerivation "xf86videoxgi" {
    name = "xf86-video-xgi-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-xgi-1.6.1.tar.bz2;
      sha256 = "10xd2vah0pnpw5spn40n4p95mpmgvdkly4i1cz51imnlfsw7g8si";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86vidmodeproto = (mkDerivation "xf86vidmodeproto" {
    name = "xf86vidmodeproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86vidmodeproto-2.3.1.tar.bz2;
      sha256 = "0w47d7gfa8zizh2bshdr2rffvbr4jqjv019mdgyh6cmplyd4kna5";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xfs = (mkDerivation "xfs" {
    name = "xfs-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.4.tar.bz2;
      sha256 = "1ylz4r7adf567rnlbb52yi9x3qi4pyv954kkhm7ld4f0fkk7a2x4";
    };
    buildInputs = [pkgconfig libXfont xproto xtrans ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXfont xproto xtrans ;};

  xgamma = (mkDerivation "xgamma" {
    name = "xgamma-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xgamma-1.0.6.tar.bz2;
      sha256 = "1lr2nb1fhg5fk2fchqxdxyl739602ggwhmgl2wiv5c8qbidw7w8f";
    };
    buildInputs = [pkgconfig libX11 xproto libXxf86vm ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto libXxf86vm ;};

  xgc = (mkDerivation "xgc" {
    name = "xgc-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xgc-1.0.5.tar.bz2;
      sha256 = "0pigvjd3i9fchmj1inqy151aafz3dr0vq1h2zizdb2imvadqv0hl";
    };
    buildInputs = [pkgconfig libXaw libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXaw libXt ;};

  xhost = (mkDerivation "xhost" {
    name = "xhost-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xhost-1.0.7.tar.bz2;
      sha256 = "16n26xw6l01zq31d4qvsaz50misvizhn7iihzdn5f7s72pp1krlk";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXau libXmu xproto ;};

  xineramaproto = (mkDerivation "xineramaproto" {
    name = "xineramaproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xineramaproto-1.2.1.tar.bz2;
      sha256 = "0ns8abd27x7gbp4r44z3wc5k9zqxxj8zjnazqpcyr4n17nxp8xcp";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xinit = (mkDerivation "xinit" {
    name = "xinit-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinit-1.3.4.tar.bz2;
      sha256 = "1cq2g469mb2cfgr8k57960yrn90bl33vfqri4pdh2zm0jxrqvn3m";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xinput = (mkDerivation "xinput" {
    name = "xinput-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinput-1.6.2.tar.bz2;
      sha256 = "1i75mviz9dyqyf7qigzmxq8vn31i86aybm662fzjz5c086dx551n";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi libXinerama libXrandr ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto libX11 libXext libXi libXinerama libXrandr ;};

  xkbcomp = (mkDerivation "xkbcomp" {
    name = "xkbcomp-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbcomp-1.3.1.tar.bz2;
      sha256 = "0gcjy70ppmcl610z8gxc7sydsx93f8cm8pggm4qhihaa1ngdq103";
    };
    buildInputs = [pkgconfig libX11 libxkbfile xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libxkbfile xproto ;};

  xkbevd = (mkDerivation "xkbevd" {
    name = "xkbevd-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbevd-1.1.4.tar.bz2;
      sha256 = "0sprjx8i86ljk0l7ldzbz2xlk8916z5zh78cafjv8k1a63js4c14";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libxkbfile ;};

  xkbprint = (mkDerivation "xkbprint" {
    name = "xkbprint-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbprint-1.0.4.tar.bz2;
      sha256 = "04iyv5z8aqhabv7wcpvbvq0ji0jrz1666vw6gvxkvl7szswalgqb";
    };
    buildInputs = [pkgconfig libX11 libxkbfile xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libxkbfile xproto ;};

  xkbutils = (mkDerivation "xkbutils" {
    name = "xkbutils-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbutils-1.0.4.tar.bz2;
      sha256 = "0c412isxl65wplhl7nsk12vxlri29lk48g3p52hbrs3m0awqm8fj";
    };
    buildInputs = [pkgconfig inputproto libX11 libXaw xproto libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit inputproto libX11 libXaw xproto libXt ;};

  xkeyboardconfig = (mkDerivation "xkeyboardconfig" {
    name = "xkeyboard-config-2.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.16.tar.bz2;
      sha256 = "0n0xinsljc5mww1qw7dfp8knv0f1r9hs6pdhl0fggdwn5hhiz2hy";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xkill = (mkDerivation "xkill" {
    name = "xkill-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkill-1.0.4.tar.bz2;
      sha256 = "0bl1ky8ps9jg842j4mnmf4zbx8nkvk0h77w7bqjlpwij9wq2mvw8";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXmu xproto ;};

  xlsatoms = (mkDerivation "xlsatoms" {
    name = "xlsatoms-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsatoms-1.1.2.tar.bz2;
      sha256 = "196yjik910xsr7dwy8daa0amr0r22ynfs360z0ndp9mx7mydrra7";
    };
    buildInputs = [pkgconfig libxcb ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libxcb ;};

  xlsclients = (mkDerivation "xlsclients" {
    name = "xlsclients-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsclients-1.1.3.tar.bz2;
      sha256 = "0g9x7rrggs741x9xwvv1k9qayma980d88nhdqw7j3pn3qvy6d5jx";
    };
    buildInputs = [pkgconfig libxcb ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libxcb ;};

  xlsfonts = (mkDerivation "xlsfonts" {
    name = "xlsfonts-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsfonts-1.0.5.tar.bz2;
      sha256 = "1yi774g6r1kafsbnxbkrwyndd3i60362ck1fps9ywz076pn5naa0";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xmag = (mkDerivation "xmag" {
    name = "xmag-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmag-1.0.6.tar.bz2;
      sha256 = "0qg12ifbbk9n8fh4jmyb625cknn8ssj86chd6zwdiqjin8ivr8l7";
    };
    buildInputs = [pkgconfig libX11 libXaw libXmu libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXaw libXmu libXt ;};

  xmessage = (mkDerivation "xmessage" {
    name = "xmessage-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.4.tar.bz2;
      sha256 = "0s5bjlpxnmh8sxx6nfg9m0nr32r1sr3irr71wsnv76s33i34ppxw";
    };
    buildInputs = [pkgconfig libXaw libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libXaw libXt ;};

  xmodmap = (mkDerivation "xmodmap" {
    name = "xmodmap-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmodmap-1.0.9.tar.bz2;
      sha256 = "0y649an3jqfq9klkp9y5gj20xb78fw6g193f5mnzpl0hbz6fbc5p";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xorgcffiles = (mkDerivation "xorgcffiles" {
    name = "xorg-cf-files-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.6.tar.bz2;
      sha256 = "0kckng0zs1viz0nr84rdl6dswgip7ndn4pnh5nfwnviwpsfmmksd";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xorgdocs = (mkDerivation "xorgdocs" {
    name = "xorg-docs-1.7.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/doc/xorg-docs-1.7.1.tar.bz2;
      sha256 = "0jrc4jmb4raqawx0j9jmhgasr0k6sxv0bm2hrxjh9hb26iy6gf14";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xorgserver = (mkDerivation "xorgserver" {
    name = "xorg-server-1.18.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.18.3.tar.bz2;
      sha256 = "1ka206v4nbw6qz072gh0543aq44azq2zv9f0yysy5nvwa4i9qwza";
    };
    buildInputs = [pkgconfig dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit dri2proto dri3proto renderproto libdrm openssl libX11 libXau libXaw libxcb xcbutil xcbutilwm xcbutilimage xcbutilkeysyms xcbutilrenderutil libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt ;};

  # TODO:
  # With the current state of ./generate-expr-from-tarballs.pl,
  # this will get overwritten when next invoked.
  # Could add a special case to ./generate-expr-from-tarballs.pl,
  # or perhaps there's a cleaner solution.
  #xquartz = (mkDerivation "xquartz" {
  #  name = "xorg-server-1.14.6";
  #  builder = ./builder.sh;
  #  src = fetchurl {
  #    url = mirror://xorg/individual/xserver/xorg-server-1.14.6.tar.bz2;
  #    sha256 = "0c57vp1z0p38dj5gfipkmlw6bvbz1mrr0sb3sbghdxxdyq4kzcz8";
  #  };
  #  buildInputs = [pkgconfig renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ];
  #}) // {inherit renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ;};

  xorgsgmldoctools = (mkDerivation "xorgsgmldoctools" {
    name = "xorg-sgml-doctools-1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xorg-sgml-doctools-1.11.tar.bz2;
      sha256 = "0k5pffyi5bx8dmfn033cyhgd3gf6viqj3x769fqixifwhbgy2777";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xpr = (mkDerivation "xpr" {
    name = "xpr-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xpr-1.0.4.tar.bz2;
      sha256 = "1dbcv26w2yand2qy7b3h5rbvw1mdmdd57jw88v53sgdr3vrqvngy";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXmu xproto ;};

  xprop = (mkDerivation "xprop" {
    name = "xprop-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xprop-1.2.2.tar.bz2;
      sha256 = "1ilvhqfjcg6f1hqahjkp8qaay9rhvmv2blvj3w9asraq0aqqivlv";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xproto = (mkDerivation "xproto" {
    name = "xproto-7.0.28";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xproto-7.0.28.tar.bz2;
      sha256 = "1jpnvm33vi2dar5y5zgz7jjh0m8fpkcxm0f0lbwfx37ns5l5bs19";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xrandr = (mkDerivation "xrandr" {
    name = "xrandr-1.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrandr-1.4.3.tar.bz2;
      sha256 = "06xy0kr6ih7ilrwl6b5g6ay75vm2j4lxnv1d5xlj6sdqhqsaqm3i";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr libXrender ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto libXrandr libXrender ;};

  xrdb = (mkDerivation "xrdb" {
    name = "xrdb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrdb-1.1.0.tar.bz2;
      sha256 = "0nsnr90wazcdd50nc5dqswy0bmq6qcj14nnrhyi7rln9pxmpp0kk";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXmu xproto ;};

  xrefresh = (mkDerivation "xrefresh" {
    name = "xrefresh-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrefresh-1.0.5.tar.bz2;
      sha256 = "1mlinwgvql6s1rbf46yckbfr9j22d3c3z7jx3n6ix7ca18dnf4rj";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xset = (mkDerivation "xset" {
    name = "xset-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xset-1.2.3.tar.bz2;
      sha256 = "0qw0iic27bz3yz2wynf1gxs70hhkcf9c4jrv7zhlg1mq57xz90j3";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu xproto libXxf86misc ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libXext libXmu xproto libXxf86misc ;};

  xsetroot = (mkDerivation "xsetroot" {
    name = "xsetroot-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xsetroot-1.1.0.tar.bz2;
      sha256 = "1bazzsf9sy0q2bj4lxvh1kvyrhmpggzb7jg575i15sksksa3xwc8";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXcursor libXmu ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xbitmaps libXcursor libXmu ;};

  xtrans = (mkDerivation "xtrans" {
    name = "xtrans-1.3.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/xtrans-1.3.5.tar.bz2;
      sha256 = "00c3ph17acnsch3gbdmx33b9ifjnl5w7vx8hrmic1r1cjcv3pgdd";
    };
    buildInputs = [pkgconfig ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit ;};

  xvinfo = (mkDerivation "xvinfo" {
    name = "xvinfo-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xvinfo-1.1.3.tar.bz2;
      sha256 = "1sz5wqhxd1fqsfi1w5advdlwzkizf2fgl12hdpk66f7mv9l8pflz";
    };
    buildInputs = [pkgconfig libX11 xproto libXv ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto libXv ;};

  xwd = (mkDerivation "xwd" {
    name = "xwd-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xwd-1.0.6.tar.bz2;
      sha256 = "0ybx48agdvjp9lgwvcw79r1x6jbqbyl3fliy3i5xwy4d4si9dcrv";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

  xwininfo = (mkDerivation "xwininfo" {
    name = "xwininfo-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xwininfo-1.1.3.tar.bz2;
      sha256 = "1y1zn8ijqslb5lfpbq4bb78kllhch8in98ps7n8fg3dxjpmb13i1";
    };
    buildInputs = [pkgconfig libX11 libxcb xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 libxcb xproto ;};

  xwud = (mkDerivation "xwud" {
    name = "xwud-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xwud-1.0.4.tar.bz2;
      sha256 = "1ggql6maivah58kwsh3z9x1hvzxm1a8888xx4s78cl77ryfa1cyn";
    };
    buildInputs = [pkgconfig libX11 xproto ];
    meta.platforms = stdenv.lib.platforms.unix;
  }) // {inherit libX11 xproto ;};

}; in xorg
