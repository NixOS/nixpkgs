# THIS IS A GENERATED FILE.  DO NOT EDIT!
args: with args;

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
  }) // {inherit ;};

  bdftopcf = (mkDerivation "bdftopcf" {
    name = "bdftopcf-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/bdftopcf-1.0.4.tar.bz2;
      sha256 = "1617zmgnx50n7vxlqyj84fl7vnk813jjqmi6jpigyz1xp9br1xga";
    };
    buildInputs = [pkgconfig libXfont ];
  }) // {inherit libXfont ;};

  bigreqsproto = (mkDerivation "bigreqsproto" {
    name = "bigreqsproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/bigreqsproto-1.1.2.tar.bz2;
      sha256 = "07hvfm84scz8zjw14riiln2v4w03jlhp756ypwhq27g48jmic8a6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  compositeproto = (mkDerivation "compositeproto" {
    name = "compositeproto-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/compositeproto-0.4.2.tar.bz2;
      sha256 = "1z0crmf669hirw4s7972mmp8xig80kfndja9h559haqbpvq5k4q4";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  damageproto = (mkDerivation "damageproto" {
    name = "damageproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/damageproto-1.2.1.tar.bz2;
      sha256 = "0nzwr5pv9hg7c21n995pdiv0zqhs91yz3r8rn3aska4ykcp12z2w";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  dmxproto = (mkDerivation "dmxproto" {
    name = "dmxproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/dmxproto-2.3.1.tar.bz2;
      sha256 = "02b5x9dkgajizm8dqyx2w6hmqx3v25l67mgf35nj6sz0lgk52877";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  dri2proto = (mkDerivation "dri2proto" {
    name = "dri2proto-2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri2proto-2.8.tar.bz2;
      sha256 = "015az1vfdqmil1yay5nlsmpf6cf7vcbpslxjb72cfkzlvrv59dgr";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  dri3proto = (mkDerivation "dri3proto" {
    name = "dri3proto-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri3proto-1.0.tar.bz2;
      sha256 = "0x609xvnl8jky5m8jdklw4nymx3irkv32w99dfd8nl800bblkgh1";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  encodings = (mkDerivation "encodings" {
    name = "encodings-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/encodings-1.0.4.tar.bz2;
      sha256 = "0ffmaw80vmfwdgvdkp6495xgsqszb6s0iira5j0j6pd4i0lk3mnf";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  fixesproto = (mkDerivation "fixesproto" {
    name = "fixesproto-5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/fixesproto-5.0.tar.bz2;
      sha256 = "1ki4wiq2iivx5g4w5ckzbjbap759kfqd72yg18m3zpbb4hqkybxs";
    };
    buildInputs = [pkgconfig xextproto ];
  }) // {inherit xextproto ;};

  fontadobe100dpi = (mkDerivation "fontadobe100dpi" {
    name = "font-adobe-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-100dpi-1.0.3.tar.bz2;
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobe75dpi = (mkDerivation "fontadobe75dpi" {
    name = "font-adobe-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-75dpi-1.0.3.tar.bz2;
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia100dpi = (mkDerivation "fontadobeutopia100dpi" {
    name = "font-adobe-utopia-100dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-100dpi-1.0.4.tar.bz2;
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia75dpi = (mkDerivation "fontadobeutopia75dpi" {
    name = "font-adobe-utopia-75dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-75dpi-1.0.4.tar.bz2;
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopiatype1 = (mkDerivation "fontadobeutopiatype1" {
    name = "font-adobe-utopia-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-type1-1.0.4.tar.bz2;
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontalias = (mkDerivation "fontalias" {
    name = "font-alias-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-alias-1.0.3.tar.bz2;
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  fontarabicmisc = (mkDerivation "fontarabicmisc" {
    name = "font-arabic-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-arabic-misc-1.0.3.tar.bz2;
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontbh100dpi = (mkDerivation "fontbh100dpi" {
    name = "font-bh-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-100dpi-1.0.3.tar.bz2;
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbh75dpi = (mkDerivation "fontbh75dpi" {
    name = "font-bh-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-75dpi-1.0.3.tar.bz2;
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter100dpi = (mkDerivation "fontbhlucidatypewriter100dpi" {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2;
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter75dpi = (mkDerivation "fontbhlucidatypewriter75dpi" {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2;
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhttf = (mkDerivation "fontbhttf" {
    name = "font-bh-ttf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-ttf-1.0.3.tar.bz2;
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontbhtype1 = (mkDerivation "fontbhtype1" {
    name = "font-bh-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-type1-1.0.3.tar.bz2;
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontbitstream100dpi = (mkDerivation "fontbitstream100dpi" {
    name = "font-bitstream-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-100dpi-1.0.3.tar.bz2;
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontbitstream75dpi = (mkDerivation "fontbitstream75dpi" {
    name = "font-bitstream-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-75dpi-1.0.3.tar.bz2;
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontbitstreamtype1 = (mkDerivation "fontbitstreamtype1" {
    name = "font-bitstream-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-type1-1.0.3.tar.bz2;
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontcronyxcyrillic = (mkDerivation "fontcronyxcyrillic" {
    name = "font-cronyx-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cronyx-cyrillic-1.0.3.tar.bz2;
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontcursormisc = (mkDerivation "fontcursormisc" {
    name = "font-cursor-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cursor-misc-1.0.3.tar.bz2;
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontdaewoomisc = (mkDerivation "fontdaewoomisc" {
    name = "font-daewoo-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-daewoo-misc-1.0.3.tar.bz2;
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontdecmisc = (mkDerivation "fontdecmisc" {
    name = "font-dec-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-dec-misc-1.0.3.tar.bz2;
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontibmtype1 = (mkDerivation "fontibmtype1" {
    name = "font-ibm-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-ibm-type1-1.0.3.tar.bz2;
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontisasmisc = (mkDerivation "fontisasmisc" {
    name = "font-isas-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-isas-misc-1.0.3.tar.bz2;
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontjismisc = (mkDerivation "fontjismisc" {
    name = "font-jis-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-jis-misc-1.0.3.tar.bz2;
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontmicromisc = (mkDerivation "fontmicromisc" {
    name = "font-micro-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-micro-misc-1.0.3.tar.bz2;
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontmisccyrillic = (mkDerivation "fontmisccyrillic" {
    name = "font-misc-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-cyrillic-1.0.3.tar.bz2;
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontmiscethiopic = (mkDerivation "fontmiscethiopic" {
    name = "font-misc-ethiopic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-ethiopic-1.0.3.tar.bz2;
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontmiscmeltho = (mkDerivation "fontmiscmeltho" {
    name = "font-misc-meltho-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-meltho-1.0.3.tar.bz2;
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  fontmiscmisc = (mkDerivation "fontmiscmisc" {
    name = "font-misc-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-misc-1.1.2.tar.bz2;
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontmuttmisc = (mkDerivation "fontmuttmisc" {
    name = "font-mutt-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-mutt-misc-1.0.3.tar.bz2;
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontschumachermisc = (mkDerivation "fontschumachermisc" {
    name = "font-schumacher-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-schumacher-misc-1.1.2.tar.bz2;
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontscreencyrillic = (mkDerivation "fontscreencyrillic" {
    name = "font-screen-cyrillic-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-screen-cyrillic-1.0.4.tar.bz2;
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontsonymisc = (mkDerivation "fontsonymisc" {
    name = "font-sony-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sony-misc-1.0.3.tar.bz2;
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontsproto = (mkDerivation "fontsproto" {
    name = "fontsproto-2.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/fontsproto-2.1.2.tar.bz2;
      sha256 = "1ab8mbqxdwvdz4k5x4xb9c4n5w7i1xw276cbpk4z7a1nlpjrg746";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  fontsunmisc = (mkDerivation "fontsunmisc" {
    name = "font-sun-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sun-misc-1.0.3.tar.bz2;
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontutil = (mkDerivation "fontutil" {
    name = "font-util-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-util-1.3.0.tar.bz2;
      sha256 = "15cijajwhjzpy3ydc817zz8x5z4gbkyv3fps687jbq544mbfbafz";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  fontwinitzkicyrillic = (mkDerivation "fontwinitzkicyrillic" {
    name = "font-winitzki-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-winitzki-cyrillic-1.0.3.tar.bz2;
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit bdftopcf mkfontdir ;};

  fontxfree86type1 = (mkDerivation "fontxfree86type1" {
    name = "font-xfree86-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-xfree86-type1-1.0.4.tar.bz2;
      sha256 = "0jp3zc0qfdaqfkgzrb44vi9vi0a8ygb35wp082yz7rvvxhmg9sya";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  }) // {inherit mkfontdir mkfontscale ;};

  gccmakedep = (mkDerivation "gccmakedep" {
    name = "gccmakedep-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/gccmakedep-1.0.3.tar.bz2;
      sha256 = "1r1fpy5ni8chbgx7j5sz0008fpb6vbazpy1nifgdhgijyzqxqxdj";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  glamoregl = (mkDerivation "glamoregl" {
    name = "glamor-egl-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/glamor-egl-0.6.0.tar.bz2;
      sha256 = "1jg5clihklb9drh1jd7nhhdsszla6nv7xmbvm8yvakh5wrb1nlv6";
    };
    buildInputs = [pkgconfig dri2proto xorgserver ];
  }) // {inherit dri2proto xorgserver ;};

  glproto = (mkDerivation "glproto" {
    name = "glproto-1.4.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/glproto-1.4.17.tar.bz2;
      sha256 = "0h5ykmcddwid5qj6sbrszgkcypwn3mslvswxpgy2n2iixnyr9amd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  iceauth = (mkDerivation "iceauth" {
    name = "iceauth-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/iceauth-1.0.6.tar.bz2;
      sha256 = "1x72y99dxf2fxnlyf0yrf9yzd8xzimxshy6l8mprwhrv6lvhi6dx";
    };
    buildInputs = [pkgconfig libICE xproto ];
  }) // {inherit libICE xproto ;};

  imake = (mkDerivation "imake" {
    name = "imake-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.7.tar.bz2;
      sha256 = "0zpk8p044jh14bis838shbf4100bjg7mccd7bq54glpsq552q339";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  inputproto = (mkDerivation "inputproto" {
    name = "inputproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/inputproto-2.3.1.tar.bz2;
      sha256 = "1lf1jlxp0fc8h6fjdffhd084dqab94966l1zm3rwwsis0mifwiss";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  kbproto = (mkDerivation "kbproto" {
    name = "kbproto-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/kbproto-1.0.6.tar.bz2;
      sha256 = "0yal11hhpiisy3w8wmacsdzzzcnc3xwnswxz8k7zri40xc5aqz03";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  libAppleWM = (mkDerivation "libAppleWM" {
    name = "libAppleWM-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libAppleWM-1.4.1.tar.bz2;
      sha256 = "0r8x28n45q89x91mz8mv0zkkcxi8wazkac886fyvflhiv2y8ap2y";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  }) // {inherit applewmproto libX11 libXext xextproto ;};

  libFS = (mkDerivation "libFS" {
    name = "libFS-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libFS-1.0.6.tar.bz2;
      sha256 = "1mxfsvj9m3pn8cdkcn4kg190zp665mf4pv0083g6xykvsgxzq1wh";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  }) // {inherit fontsproto xproto xtrans ;};

  libICE = (mkDerivation "libICE" {
    name = "libICE-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libICE-1.0.9.tar.bz2;
      sha256 = "00p2b6bsg6kcdbb39bv46339qcywxfl4hsrz8asm4hy6q7r34w4g";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  }) // {inherit xproto xtrans ;};

  libSM = (mkDerivation "libSM" {
    name = "libSM-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libSM-1.2.2.tar.bz2;
      sha256 = "1gc7wavgs435g9qkp9jw4lhmaiq6ip9llv49f054ad6ryp4sib0b";
    };
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
  }) // {inherit libICE libuuid xproto xtrans ;};

  libWindowsWM = (mkDerivation "libWindowsWM" {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libWindowsWM-1.0.1.tar.bz2;
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  }) // {inherit windowswmproto libX11 libXext xextproto ;};

  libX11 = (mkDerivation "libX11" {
    name = "libX11-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.6.2.tar.bz2;
      sha256 = "05mx0s0vqzds3qjc1gmjr2s6x2ll37z4lfhgm7p2w7936zl2g81a";
    };
    buildInputs = [pkgconfig inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ];
  }) // {inherit inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ;};

  libXScrnSaver = (mkDerivation "libXScrnSaver" {
    name = "libXScrnSaver-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXScrnSaver-1.2.2.tar.bz2;
      sha256 = "07ff4r20nkkrj7h08f9fwamds9b3imj8jz5iz6y38zqw6jkyzwcg";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  }) // {inherit scrnsaverproto libX11 libXext xextproto ;};

  libXau = (mkDerivation "libXau" {
    name = "libXau-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXau-1.0.8.tar.bz2;
      sha256 = "1wm4pv12f36cwzhldpp7vy3lhm3xdcnp4f184xkxsp7b18r7gm7x";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  libXaw = (mkDerivation "libXaw" {
    name = "libXaw-1.0.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXaw-1.0.12.tar.bz2;
      sha256 = "1xnv7jy86j9vhmw74frkzcraynqbw1p1s79jasargsgwfi433z4n";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXmu libXpm xproto libXt ];
  }) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};

  libXcomposite = (mkDerivation "libXcomposite" {
    name = "libXcomposite-0.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcomposite-0.4.4.tar.bz2;
      sha256 = "0y21nfpa5s8qmx0srdlilyndas3sgl0c6rc26d5fx2vx436m1qpd";
    };
    buildInputs = [pkgconfig compositeproto libX11 libXfixes xproto ];
  }) // {inherit compositeproto libX11 libXfixes xproto ;};

  libXcursor = (mkDerivation "libXcursor" {
    name = "libXcursor-1.1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcursor-1.1.14.tar.bz2;
      sha256 = "1prkdicl5y5yx32h1azh6gjfbijvjp415javv8dsakd13jrarilv";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
  }) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};

  libXdamage = (mkDerivation "libXdamage" {
    name = "libXdamage-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXdamage-1.1.4.tar.bz2;
      sha256 = "1bamagq7g6s0d23l8rb3nppj8ifqj05f7z9bhbs4fdg8az3ffgvw";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
  }) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};

  libXdmcp = (mkDerivation "libXdmcp" {
    name = "libXdmcp-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXdmcp-1.1.1.tar.bz2;
      sha256 = "13highx4xpgkiwykpcl7z2laslrjc4pzi4h617ny9p7r6116vkls";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  libXext = (mkDerivation "libXext" {
    name = "libXext-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXext-1.3.3.tar.bz2;
      sha256 = "0dbfn5bznnrhqzvkrcmw4c44yvvpwdcsrvzxf4rk27r36b9x865m";
    };
    buildInputs = [pkgconfig libX11 xextproto xproto ];
  }) // {inherit libX11 xextproto xproto ;};

  libXfixes = (mkDerivation "libXfixes" {
    name = "libXfixes-5.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfixes-5.0.1.tar.bz2;
      sha256 = "0rs7qgzr6dpr62db7sd91c1b47hzhzfr010qwnpcm8sg122w1gk3";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  }) // {inherit fixesproto libX11 xextproto xproto ;};

  libXfont = (mkDerivation "libXfont" {
    name = "libXfont-1.4.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfont-1.4.8.tar.bz2;
      sha256 = "01fh2hnnaby8x6mv57x78nsqwhls70gwykldzd8b43vrpzzd8s2m";
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
  }) // {inherit fontconfig freetype libX11 xproto libXrender ;};

  libXi = (mkDerivation "libXi" {
    name = "libXi-1.7.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXi-1.7.4.tar.bz2;
      sha256 = "0i12lj973grlp9fa79v0vh9cahk3nf9csdjnf81iip0qcrlc5zrc";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto libXfixes xproto ];
  }) // {inherit inputproto libX11 libXext xextproto libXfixes xproto ;};

  libXinerama = (mkDerivation "libXinerama" {
    name = "libXinerama-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXinerama-1.1.3.tar.bz2;
      sha256 = "1qlqfvzw45gdzk9xirgwlp2qgj0hbsyiqj8yh8zml2bk2ygnjibs";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  }) // {inherit libX11 libXext xextproto xineramaproto ;};

  libXmu = (mkDerivation "libXmu" {
    name = "libXmu-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXmu-1.1.2.tar.bz2;
      sha256 = "02wx6jw7i0q5qwx87yf94fsn3h0xpz1k7dz1nkwfwm1j71ydqvkm";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXp = (mkDerivation "libXp" {
    name = "libXp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.2.tar.bz2;
      sha256 = "1dfh5w8sjz5b5fl6dl4y63ckq99snslz7bir8zq2rg8ax6syabwm";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  }) // {inherit printproto libX11 libXau libXext xextproto ;};

  libXpm = (mkDerivation "libXpm" {
    name = "libXpm-3.5.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXpm-3.5.11.tar.bz2;
      sha256 = "07041q4k8m4nirzl7lrqn8by2zylx0xvh6n0za301qqs3njszgf5";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  }) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXrandr = (mkDerivation "libXrandr" {
    name = "libXrandr-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrandr-1.4.2.tar.bz2;
      sha256 = "1b95p3l84ppv6j7dbbmg0zrz6k8xdwvnag1l6ajm3gk9qwdb79ya";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
  }) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};

  libXrender = (mkDerivation "libXrender" {
    name = "libXrender-0.9.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrender-0.9.8.tar.bz2;
      sha256 = "0qpwyjhbpp734vnhca992pjh4w7ijslidkzx1pcwbbk000pv050x";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
  }) // {inherit renderproto libX11 xproto ;};

  libXres = (mkDerivation "libXres" {
    name = "libXres-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXres-1.0.7.tar.bz2;
      sha256 = "1rd0bzn67cpb2qkc946gch2183r4bdjfhs6cpqbipy47m9a91296";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
  }) // {inherit resourceproto libX11 libXext xextproto xproto ;};

  libXt = (mkDerivation "libXt" {
    name = "libXt-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXt-1.1.4.tar.bz2;
      sha256 = "0myxwbx9ylam5x3ia5b5f4x8azcqdm420h9ad1r4hrgmi2lrffl4";
    };
    buildInputs = [pkgconfig libICE kbproto libSM libX11 xproto ];
  }) // {inherit libICE kbproto libSM libX11 xproto ;};

  libXtst = (mkDerivation "libXtst" {
    name = "libXtst-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXtst-1.2.2.tar.bz2;
      sha256 = "1ngn161nq679ffmbwl81i2hn75jjg5b3ffv6n4jilpvyazypy2pg";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto libXi ];
  }) // {inherit inputproto recordproto libX11 libXext xextproto libXi ;};

  libXv = (mkDerivation "libXv" {
    name = "libXv-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXv-1.0.10.tar.bz2;
      sha256 = "09a5j6bisysiipd0nw6s352565bp0n6gbyhv5hp63s3cd3w95zjm";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
  }) // {inherit videoproto libX11 libXext xextproto xproto ;};

  libXvMC = (mkDerivation "libXvMC" {
    name = "libXvMC-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXvMC-1.0.8.tar.bz2;
      sha256 = "015jk3bxfmj6zaw99x282f9npi8qqaw34yg186frags3z8g406jy";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
  }) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};

  libXxf86dga = (mkDerivation "libXxf86dga" {
    name = "libXxf86dga-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86dga-1.1.4.tar.bz2;
      sha256 = "0zn7aqj8x0951d8zb2h2andldvwkzbsc4cs7q023g6nzq6vd9v4f";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};

  libXxf86misc = (mkDerivation "libXxf86misc" {
    name = "libXxf86misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86misc-1.0.3.tar.bz2;
      sha256 = "0nvbq9y6k6m9hxdvg3crycqsnnxf1859wrisqcs37z9fhq044gsn";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};

  libXxf86vm = (mkDerivation "libXxf86vm" {
    name = "libXxf86vm-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86vm-1.1.3.tar.bz2;
      sha256 = "1f1pxj018nk7ybxv58jmn5y8gm2288p4q3l2dng9n1p25v1qcpns";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};

  libdmx = (mkDerivation "libdmx" {
    name = "libdmx-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libdmx-1.1.3.tar.bz2;
      sha256 = "00djlxas38kbsrglcmwmxfbmxjdchlbj95pqwjvdg8jn5rns6zf9";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  }) // {inherit dmxproto libX11 libXext xextproto ;};

  libfontenc = (mkDerivation "libfontenc" {
    name = "libfontenc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libfontenc-1.1.2.tar.bz2;
      sha256 = "0qign0ivqk166l9yfd51gw9lbhgs718bcrmvc40yicjr6gnyz959";
    };
    buildInputs = [pkgconfig xproto zlib ];
  }) // {inherit xproto zlib ;};

  libpciaccess = (mkDerivation "libpciaccess" {
    name = "libpciaccess-0.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.13.2.tar.bz2;
      sha256 = "06fy43n3c450h7xqpn3094bnfn7ca1mrq3i856y8kyqa0lmqraxb";
    };
    buildInputs = [pkgconfig zlib ];
  }) // {inherit zlib ;};

  libpthreadstubs = (mkDerivation "libpthreadstubs" {
    name = "libpthread-stubs-0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.bz2;
      sha256 = "16bjv3in19l84hbri41iayvvg4ls9gv1ma0x0qlbmwy67i7dbdim";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  libxcb = (mkDerivation "libxcb" {
    name = "libxcb-1.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.10.tar.bz2;
      sha256 = "1dfmyb1zjx6n0zhr4y40mc1crlmj3bfjjhmn0f30ip9nnq2spncq";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
  }) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};

  libxkbfile = (mkDerivation "libxkbfile" {
    name = "libxkbfile-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libxkbfile-1.0.8.tar.bz2;
      sha256 = "0flg5arw6n3njagmsi4i4l0zl5bfx866a1h9ydc3bi1pqlclxaca";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  }) // {inherit kbproto libX11 ;};

  libxshmfence = (mkDerivation "libxshmfence" {
    name = "libxshmfence-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libxshmfence-1.1.tar.bz2;
      sha256 = "1gnfb1z8sbbdc3xpz1zmm94lv7yvfh4kvip9s5pj37ya4llxphnv";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  lndir = (mkDerivation "lndir" {
    name = "lndir-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.3.tar.bz2;
      sha256 = "0pdngiy8zdhsiqx2am75yfcl36l7kd7d7nl0rss8shcdvsqgmx29";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  luit = (mkDerivation "luit" {
    name = "luit-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/luit-1.1.1.tar.bz2;
      sha256 = "0dn694mk56x6hdk6y9ylx4f128h5jcin278gnw2gb807rf3ygc1h";
    };
    buildInputs = [pkgconfig libfontenc ];
  }) // {inherit libfontenc ;};

  makedepend = (mkDerivation "makedepend" {
    name = "makedepend-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/makedepend-1.0.5.tar.bz2;
      sha256 = "09alw99r6y2bbd1dc786n3jfgv4j520apblyn7cw6jkjydshba7p";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  mkfontdir = (mkDerivation "mkfontdir" {
    name = "mkfontdir-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/mkfontdir-1.0.7.tar.bz2;
      sha256 = "0c3563kw9fg15dpgx4dwvl12qz6sdqdns1pxa574hc7i5m42mman";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  mkfontscale = (mkDerivation "mkfontscale" {
    name = "mkfontscale-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/mkfontscale-1.1.1.tar.bz2;
      sha256 = "0cdpn1ii2iw1vg2ga4w62acrh78gzgf0vza4g8wx5kkp4jcifh14";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  }) // {inherit libfontenc freetype xproto zlib ;};

  presentproto = (mkDerivation "presentproto" {
    name = "presentproto-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/presentproto-1.0.tar.bz2;
      sha256 = "1kir51aqg9cwazs14ivcldcn3mzadqgykc9cg87rm40zf947sb41";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  printproto = (mkDerivation "printproto" {
    name = "printproto-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/printproto-1.0.5.tar.bz2;
      sha256 = "06liap8n4s25sgp27d371cc7yg9a08dxcr3pmdjp761vyin3360j";
    };
    buildInputs = [pkgconfig libXau ];
  }) // {inherit libXau ;};

  randrproto = (mkDerivation "randrproto" {
    name = "randrproto-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/randrproto-1.4.0.tar.bz2;
      sha256 = "1kq9h93qdnniiivry8jmhlgwn9fbx9xp5r9cmzfihlx5cs62xi45";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  recordproto = (mkDerivation "recordproto" {
    name = "recordproto-1.14.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/recordproto-1.14.2.tar.bz2;
      sha256 = "0w3kgr1zabwf79bpc28dcnj0fpni6r53rpi82ngjbalj5s6m8xx7";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  renderproto = (mkDerivation "renderproto" {
    name = "renderproto-0.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/renderproto-0.11.1.tar.bz2;
      sha256 = "0dr5xw6s0qmqg0q5pdkb4jkdhaja0vbfqla79qh5j1xjj9dmlwq6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  resourceproto = (mkDerivation "resourceproto" {
    name = "resourceproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/resourceproto-1.2.0.tar.bz2;
      sha256 = "0638iyfiiyjw1hg3139pai0j6m65gkskrvd9684zgc6ydcx00riw";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  scrnsaverproto = (mkDerivation "scrnsaverproto" {
    name = "scrnsaverproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/scrnsaverproto-1.2.2.tar.bz2;
      sha256 = "0rfdbfwd35d761xkfifcscx56q0n56043ixlmv70r4v4l66hmdwb";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  sessreg = (mkDerivation "sessreg" {
    name = "sessreg-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/sessreg-1.0.8.tar.bz2;
      sha256 = "1hy4wvgawajf4qw2k51fkcjzxw0drx60ydzpmqhj7k1g4z3cqahf";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};

  setxkbmap = (mkDerivation "setxkbmap" {
    name = "setxkbmap-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/setxkbmap-1.3.0.tar.bz2;
      sha256 = "1inygpvlgc6vr5h9laxw9lnvafnccl3fy0g5n9ll28iq3yfmqc1x";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};

  smproxy = (mkDerivation "smproxy" {
    name = "smproxy-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/smproxy-1.0.5.tar.bz2;
      sha256 = "02fn5wa1gs2jap6sr9j9yk6zsvz82j8l61pf74iyqwa99q4wnb67";
    };
    buildInputs = [pkgconfig libICE libSM libXmu libXt ];
  }) // {inherit libICE libSM libXmu libXt ;};

  twm = (mkDerivation "twm" {
    name = "twm-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/twm-1.0.8.tar.bz2;
      sha256 = "0i1ff8h2gh1ab311da5dlhl0nrma0qbrk403ymzi4cnnacikaq3n";
    };
    buildInputs = [pkgconfig libICE libSM libX11 libXext libXmu xproto libXt ];
  }) // {inherit libICE libSM libX11 libXext libXmu xproto libXt ;};

  utilmacros = (mkDerivation "utilmacros" {
    name = "util-macros-1.19.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/util-macros-1.19.0.tar.bz2;
      sha256 = "1fnhpryf55l0yqajxn0cxan3kvsjzi67nlanz8clwqzf54cb2d98";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  videoproto = (mkDerivation "videoproto" {
    name = "videoproto-2.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/videoproto-2.3.2.tar.bz2;
      sha256 = "1dnlkd9nb0m135lgd6hd61vc29sdyarsyya8aqpx7z10p261dbld";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  windowswmproto = (mkDerivation "windowswmproto" {
    name = "windowswmproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/windowswmproto-1.0.4.tar.bz2;
      sha256 = "0syjxgy4m8l94qrm03nvn5k6bkxc8knnlld1gbllym97nvnv0ny0";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  x11perf = (mkDerivation "x11perf" {
    name = "x11perf-1.5.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/x11perf-1.5.4.tar.bz2;
      sha256 = "111iwpxhnxjiq44w96zf0kszg5zpgv1g3ayx18v4nhdzl9bqivi4";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  }) // {inherit libX11 libXext libXft libXmu libXrender ;};

  xauth = (mkDerivation "xauth" {
    name = "xauth-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xauth-1.0.9.tar.bz2;
      sha256 = "13y2invb0894b1in03jbglximbz6v31y2kr4yjjgica8xciibkjn";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu xproto ];
  }) // {inherit libX11 libXau libXext libXmu xproto ;};

  xbacklight = (mkDerivation "xbacklight" {
    name = "xbacklight-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xbacklight-1.2.1.tar.bz2;
      sha256 = "0arnd1j8vzhzmw72mqhjjcb2qwcbs9qphsy3ps593ajyld8wzxhp";
    };
    buildInputs = [pkgconfig libxcb xcbutil ];
  }) // {inherit libxcb xcbutil ;};

  xbitmaps = (mkDerivation "xbitmaps" {
    name = "xbitmaps-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xbitmaps-1.1.1.tar.bz2;
      sha256 = "178ym90kwidia6nas4qr5n5yqh698vv8r02js0r4vg3b6lsb0w9n";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xcbproto = (mkDerivation "xcbproto" {
    name = "xcb-proto-1.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.10.tar.bz2;
      sha256 = "01dgp802i4ic9wkmpa7g1wm50pp547d3b96jjz2hnxavhpfhvx3y";
    };
    buildInputs = [pkgconfig python ];
  }) // {inherit python ;};

  xcbutil = (mkDerivation "xcbutil" {
    name = "xcb-util-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.3.9.tar.bz2;
      sha256 = "1i0qbhqkcdlbbsj7ifkyjsffl61whj24d3zlg5pxf3xj1af2a4f6";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilimage = (mkDerivation "xcbutilimage" {
    name = "xcb-util-image-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-image-0.3.9.tar.bz2;
      sha256 = "1pr1l1nkg197gyl9d0fpwmn72jqpxjfgn9y13q4gawg1m873qnnk";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbutil xproto ];
  }) // {inherit gperf m4 libxcb xcbutil xproto ;};

  xcbutilkeysyms = (mkDerivation "xcbutilkeysyms" {
    name = "xcb-util-keysyms-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.3.9.tar.bz2;
      sha256 = "0vjwk7vrcfnlhiadv445c6skfxmdrg5v4qf81y8s2s5xagqarqbv";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilrenderutil = (mkDerivation "xcbutilrenderutil" {
    name = "xcb-util-renderutil-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2;
      sha256 = "0nza1csdvvxbmk8vgv8vpmq7q8h05xrw3cfx9lwxd1hjzd47xsf6";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  }) // {inherit gperf m4 libxcb xproto ;};

  xcbutilwm = (mkDerivation "xcbutilwm" {
    name = "xcb-util-wm-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2;
      sha256 = "0gra7hfyxajic4mjd63cpqvd20si53j1q3rbdlkqkahfciwq3gr8";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  }) // {inherit gperf m4 libxcb xproto ;};

  xclock = (mkDerivation "xclock" {
    name = "xclock-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.7.tar.bz2;
      sha256 = "1l3xv4bsca6bwxx73jyjz0blav86i7vwffkhdb1ac81y9slyrki3";
    };
    buildInputs = [pkgconfig libX11 libXaw libXft libxkbfile libXmu xproto libXrender libXt ];
  }) // {inherit libX11 libXaw libXft libxkbfile libXmu xproto libXrender libXt ;};

  xcmiscproto = (mkDerivation "xcmiscproto" {
    name = "xcmiscproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcmiscproto-1.2.2.tar.bz2;
      sha256 = "1pyjv45wivnwap2wvsbrzdvjc5ql8bakkbkrvcv6q9bjjf33ccmi";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xcmsdb = (mkDerivation "xcmsdb" {
    name = "xcmsdb-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcmsdb-1.0.4.tar.bz2;
      sha256 = "03ms731l3kvaldq7ycbd30j6134b61i3gbll4b2gl022wyzbjq74";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};

  xcursorgen = (mkDerivation "xcursorgen" {
    name = "xcursorgen-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xcursorgen-1.0.6.tar.bz2;
      sha256 = "0v7nncj3kaa8c0524j7ricdf4rvld5i7c3m6fj55l5zbah7r3j1i";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  }) // {inherit libpng libX11 libXcursor ;};

  xcursorthemes = (mkDerivation "xcursorthemes" {
    name = "xcursor-themes-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/data/xcursor-themes-1.0.4.tar.bz2;
      sha256 = "11mv661nj1p22sqkv87ryj2lcx4m68a04b0rs6iqh3fzp42jrzg3";
    };
    buildInputs = [pkgconfig libXcursor ];
  }) // {inherit libXcursor ;};

  xdm = (mkDerivation "xdm" {
    name = "xdm-1.1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdm-1.1.11.tar.bz2;
      sha256 = "0iqw11977lpr9nk1is4fca84d531vck0mq7jldwl44m0vrnl5nnl";
    };
    buildInputs = [pkgconfig libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
  }) // {inherit libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};

  xdpyinfo = (mkDerivation "xdpyinfo" {
    name = "xdpyinfo-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdpyinfo-1.3.1.tar.bz2;
      sha256 = "154b29zlrq33lmni883jgwyrb2kx7z8h52jx1s3ys5x5d582iydf";
    };
    buildInputs = [pkgconfig libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  }) // {inherit libdmx libX11 libxcb libXcomposite libXext libXi libXinerama xproto libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};

  xdriinfo = (mkDerivation "xdriinfo" {
    name = "xdriinfo-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xdriinfo-1.0.4.tar.bz2;
      sha256 = "076bjix941znyjmh3j5jjsnhp2gv2iq53d0ks29mvvv87cyy9iim";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  }) // {inherit glproto libX11 ;};

  xev = (mkDerivation "xev" {
    name = "xev-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xev-1.2.1.tar.bz2;
      sha256 = "0hv296mysglcgkx6lj1wxc23kshb2kix1a8yqppxj5vz16mpzw8i";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr ];
  }) // {inherit libX11 xproto libXrandr ;};

  xextproto = (mkDerivation "xextproto" {
    name = "xextproto-7.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xextproto-7.3.0.tar.bz2;
      sha256 = "1c2vma9gqgc2v06rfxdiqgwhxmzk2cbmknwf1ng3m76vr0xb5x7k";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xeyes = (mkDerivation "xeyes" {
    name = "xeyes-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xeyes-1.1.1.tar.bz2;
      sha256 = "08d5x2kar5kg4yammw6hhk10iva6jmh8cqq176a1z7nm1il9hplp";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXrender libXt ];
  }) // {inherit libX11 libXext libXmu libXrender libXt ;};

  xf86bigfontproto = (mkDerivation "xf86bigfontproto" {
    name = "xf86bigfontproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86bigfontproto-1.2.0.tar.bz2;
      sha256 = "0j0n7sj5xfjpmmgx6n5x556rw21hdd18fwmavp95wps7qki214ms";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xf86dgaproto = (mkDerivation "xf86dgaproto" {
    name = "xf86dgaproto-2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86dgaproto-2.1.tar.bz2;
      sha256 = "0l4hx48207mx0hp09026r6gy9nl3asbq0c75hri19wp1118zcpmc";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xf86driproto = (mkDerivation "xf86driproto" {
    name = "xf86driproto-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86driproto-2.1.1.tar.bz2;
      sha256 = "07v69m0g2dfzb653jni4x656jlr7l84c1k39j8qc8vfb45r8sjww";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xf86inputevdev = (mkDerivation "xf86inputevdev" {
    name = "xf86-input-evdev-2.8.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.8.4.tar.bz2;
      sha256 = "030haki1h0m85h91c91812gdnk6znfamw5kpr010zxwwbsgxxyl5";
    };
    buildInputs = [pkgconfig inputproto udev xorgserver xproto ];
  }) // {inherit inputproto udev xorgserver xproto ;};

  xf86inputjoystick = (mkDerivation "xf86inputjoystick" {
    name = "xf86-input-joystick-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-joystick-1.6.2.tar.bz2;
      sha256 = "038mfqairyyqvz02rk7v3i070sab1wr0k6fkxvyvxdgkfbnqcfzf";
    };
    buildInputs = [pkgconfig inputproto kbproto xorgserver xproto ];
  }) // {inherit inputproto kbproto xorgserver xproto ;};

  xf86inputkeyboard = (mkDerivation "xf86inputkeyboard" {
    name = "xf86-input-keyboard-1.8.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-keyboard-1.8.0.tar.bz2;
      sha256 = "0nyb61w30z32djrllgr2s1i13di3vsl6hg4pqjhxdal71971ria1";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputmouse = (mkDerivation "xf86inputmouse" {
    name = "xf86-input-mouse-1.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-mouse-1.9.0.tar.bz2;
      sha256 = "12344w0cxac1ld54qqwynxwazbmmpvqh1mzcskmfkmakmr5iwq2x";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  }) // {inherit inputproto xorgserver xproto ;};

  xf86inputsynaptics = (mkDerivation "xf86inputsynaptics" {
    name = "xf86-input-synaptics-1.7.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-synaptics-1.7.6.tar.bz2;
      sha256 = "0ls8f7gy92f54hdqsa19vypg0xm496jrgdhdn4qphycxwn3gwkbm";
    };
    buildInputs = [pkgconfig inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ];
  }) // {inherit inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ;};

  xf86inputvmmouse = (mkDerivation "xf86inputvmmouse" {
    name = "xf86-input-vmmouse-13.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2;
      sha256 = "0b31ap9wp7nwpnihz8m7bz3p0hhaipxxhl652nw4v380cq1vdkq4";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputvoid = (mkDerivation "xf86inputvoid" {
    name = "xf86-input-void-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-void-1.4.0.tar.bz2;
      sha256 = "01bmk324fq48wydvy1qrnxbw6qz0fjd0i80g0n4cqr1c4mjmif9a";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  }) // {inherit xorgserver xproto ;};

  xf86miscproto = (mkDerivation "xf86miscproto" {
    name = "xf86miscproto-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xf86miscproto-0.9.3.tar.bz2;
      sha256 = "15dhcdpv61fyj6rhzrhnwri9hlw8rjfy05z1vik118lc99mfrf25";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xf86videoark = (mkDerivation "xf86videoark" {
    name = "xf86-video-ark-0.7.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ark-0.7.5.tar.bz2;
      sha256 = "07p5vdsj2ckxb6wh02s61akcv4qfg6s1d5ld3jn3lfaayd3f1466";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess xextproto xorgserver xproto ;};

  xf86videoast = (mkDerivation "xf86videoast" {
    name = "xf86-video-ast-0.98.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ast-0.98.0.tar.bz2;
      sha256 = "188nv73w0p5xhfxz2dffli44yzyn1qhhq3qkwc8wva9dhg25n8lh";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoati = (mkDerivation "xf86videoati" {
    name = "xf86-video-ati-7.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-7.4.0.tar.bz2;
      sha256 = "1nbnvxlyn75bcf23m39p7yw80kilgdxmjdvzgcs3walshnlhq8wn";
    };
    buildInputs = [pkgconfig fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videocirrus = (mkDerivation "xf86videocirrus" {
    name = "xf86-video-cirrus-1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-cirrus-1.5.2.tar.bz2;
      sha256 = "1mycqgjp18b6adqj2h90vp324xh8ysyi5migfmjc914vbnkf2q9k";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videodummy = (mkDerivation "xf86videodummy" {
    name = "xf86-video-dummy-0.3.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-dummy-0.3.7.tar.bz2;
      sha256 = "1046p64xap69vlsmsz5rjv0djc970yhvq44fmllmas0mqp5lzy2n";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};

  xf86videofbdev = (mkDerivation "xf86videofbdev" {
    name = "xf86-video-fbdev-0.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2;
      sha256 = "06ym7yy017lanj730hfkpfk4znx3dsj8jq3qvyzsn8w294kb7m4x";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};

  xf86videogeode = (mkDerivation "xf86videogeode" {
    name = "xf86-video-geode-2.11.15";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-geode-2.11.15.tar.bz2;
      sha256 = "1w4ghr2a41kaw4g9na8ws5fjbmy8zkbxpxa21vmqc8mkjzb3pnq0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoglide = (mkDerivation "xf86videoglide" {
    name = "xf86-video-glide-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glide-1.2.2.tar.bz2;
      sha256 = "1vaav6kx4n00q4fawgqnjmbdkppl0dir2dkrj4ad372mxrvl9c4y";
    };
    buildInputs = [pkgconfig xextproto xorgserver xproto ];
  }) // {inherit xextproto xorgserver xproto ;};

  xf86videoglint = (mkDerivation "xf86videoglint" {
    name = "xf86-video-glint-1.2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glint-1.2.8.tar.bz2;
      sha256 = "08a2aark2yn9irws9c78d9q44dichr03i9zbk61jgr54ncxqhzv5";
    };
    buildInputs = [pkgconfig libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videoi128 = (mkDerivation "xf86videoi128" {
    name = "xf86-video-i128-1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-i128-1.3.6.tar.bz2;
      sha256 = "171b8lbxr56w3isph947dnw7x87hc46v6m3mcxdcz44gk167x0pq";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videointel = (mkDerivation "xf86videointel" {
    name = "xf86-video-intel-2.21.15";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.21.15.tar.bz2;
      sha256 = "1z6ncmpszmwqi9xr590c4kp4gjjf7mndcr56r35x2bx7h87i8nkx";
    };
    buildInputs = [pkgconfig dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto xorgserver xproto libXrender libXvMC ];
  }) // {inherit dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto xorgserver xproto libXrender libXvMC ;};

  xf86videomach64 = (mkDerivation "xf86videomach64" {
    name = "xf86-video-mach64-6.9.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mach64-6.9.4.tar.bz2;
      sha256 = "0pl582vnc6hdxqhf5c0qdyanjqxb4crnhqlmxxml5a60syw0iwcp";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videomga = (mkDerivation "xf86videomga" {
    name = "xf86-video-mga-1.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mga-1.6.3.tar.bz2;
      sha256 = "1my7y67sadjjmab1dyxckylrggi7p01yk4wwg9w6k1q96pmb213p";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videomodesetting = (mkDerivation "xf86videomodesetting" {
    name = "xf86-video-modesetting-0.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-modesetting-0.9.0.tar.bz2;
      sha256 = "0p6pjn5bnd2wr3lmas4b12zcq12d9ilvssga93fzlg90fdahikwh";
    };
    buildInputs = [pkgconfig fontsproto libdrm udev libpciaccess randrproto libX11 xextproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm udev libpciaccess randrproto libX11 xextproto xorgserver xproto ;};

  xf86videoneomagic = (mkDerivation "xf86videoneomagic" {
    name = "xf86-video-neomagic-1.2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-neomagic-1.2.8.tar.bz2;
      sha256 = "0x48sxs1p3kmwk3pq1j7vl93y59gdmgkq1x5xbnh0yal0angdash";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess xorgserver xproto ;};

  xf86videonewport = (mkDerivation "xf86videonewport" {
    name = "xf86-video-newport-0.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-newport-0.2.4.tar.bz2;
      sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};

  xf86videonouveau = (mkDerivation "xf86videonouveau" {
    name = "xf86-video-nouveau-1.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nouveau-1.0.10.tar.bz2;
      sha256 = "17fvjplzfx86099sqys0bfl8lfbmjz8li84kzj2x95mf1cbb7fn1";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videonv = (mkDerivation "xf86videonv" {
    name = "xf86-video-nv-2.1.20";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nv-2.1.20.tar.bz2;
      sha256 = "1gqh1khc4zalip5hh2nksgs7i3piqq18nncgmsx9qvzi05azd5c3";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoopenchrome = (mkDerivation "xf86videoopenchrome" {
    name = "xf86-video-openchrome-0.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-openchrome-0.3.3.tar.bz2;
      sha256 = "1v8j4i1r268n4fc5gq54zg1x50j0rhw71f3lba7411mcblg2z7p4";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ;};

  xf86videor128 = (mkDerivation "xf86videor128" {
    name = "xf86-video-r128-6.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-r128-6.9.2.tar.bz2;
      sha256 = "1q3fsc603k2yinphx5rrcl5356qkpywwz8axlw277l2231gjjbcb";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ;};

  xf86videosavage = (mkDerivation "xf86videosavage" {
    name = "xf86-video-savage-2.3.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-savage-2.3.7.tar.bz2;
      sha256 = "0i2aqp68rfkrz9c1p6d7ny9x7bjrlnby7q56zf01fb12r42l4784";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videosiliconmotion = (mkDerivation "xf86videosiliconmotion" {
    name = "xf86-video-siliconmotion-1.7.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.7.tar.bz2;
      sha256 = "1an321kqvsxq0z35acwl99lc8hpdkayw0q180744ypcl8ffvbf47";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess videoproto xextproto xorgserver xproto ;};

  xf86videosis = (mkDerivation "xf86videosis" {
    name = "xf86-video-sis-0.10.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sis-0.10.7.tar.bz2;
      sha256 = "1l0w84x39gq4y9j81dny9r6rma1xkqvxpsavpkd8h7h8panbcbmy";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86videosuncg6 = (mkDerivation "xf86videosuncg6" {
    name = "xf86-video-suncg6-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-suncg6-1.1.2.tar.bz2;
      sha256 = "04fgwgk02m4nimlv67rrg1wnyahgymrn6rb2cjj1l8bmzkii4glr";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosunffb = (mkDerivation "xf86videosunffb" {
    name = "xf86-video-sunffb-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sunffb-1.2.2.tar.bz2;
      sha256 = "07z3ngifwg2d4jgq8pms47n5lr2yn0ai72g86xxjnb3k20n5ym7s";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};

  xf86videotdfx = (mkDerivation "xf86videotdfx" {
    name = "xf86-video-tdfx-1.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tdfx-1.4.5.tar.bz2;
      sha256 = "0nfqf1c8939s21ci1g7gacwzlr4g4nnilahgz7j2bz30zfnzpmbh";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videotga = (mkDerivation "xf86videotga" {
    name = "xf86-video-tga-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2;
      sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videotrident = (mkDerivation "xf86videotrident" {
    name = "xf86-video-trident-1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-trident-1.3.6.tar.bz2;
      sha256 = "0141qbfsm32i0pxjyx5czpa8x8m4lvapsp4amw1qigaa0gry6n3a";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videov4l = (mkDerivation "xf86videov4l" {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  }) // {inherit randrproto videoproto xorgserver xproto ;};

  xf86videovesa = (mkDerivation "xf86videovesa" {
    name = "xf86-video-vesa-2.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vesa-2.3.3.tar.bz2;
      sha256 = "1y5fsg0c4bgmh1cfsbnaaf388fppyy02i7mcy9vax78flkjpb2yf";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videovmware = (mkDerivation "xf86videovmware" {
    name = "xf86-video-vmware-13.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vmware-13.0.2.tar.bz2;
      sha256 = "0m1wfsv34s4pyr5ry87yyjb2p6vmy6vyypdz5jx0sqnkx8n3vfn8";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ;};

  xf86videovoodoo = (mkDerivation "xf86videovoodoo" {
    name = "xf86-video-voodoo-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-voodoo-1.2.5.tar.bz2;
      sha256 = "1s6p7yxmi12q4y05va53rljwyzd6ry492r1pgi7wwq6cznivhgly";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videowsfb = (mkDerivation "xf86videowsfb" {
    name = "xf86-video-wsfb-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-wsfb-0.4.0.tar.bz2;
      sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  }) // {inherit xorgserver xproto ;};

  xf86vidmodeproto = (mkDerivation "xf86vidmodeproto" {
    name = "xf86vidmodeproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86vidmodeproto-2.3.1.tar.bz2;
      sha256 = "0w47d7gfa8zizh2bshdr2rffvbr4jqjv019mdgyh6cmplyd4kna5";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xfs = (mkDerivation "xfs" {
    name = "xfs-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.3.tar.bz2;
      sha256 = "1dwnf5gncpnjsbh9bdrc665kfnclhzzcpwpfnprvrnq4mlr4mx3v";
    };
    buildInputs = [pkgconfig libXfont xproto xtrans ];
  }) // {inherit libXfont xproto xtrans ;};

  xgamma = (mkDerivation "xgamma" {
    name = "xgamma-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xgamma-1.0.5.tar.bz2;
      sha256 = "0463sawps86jnxn121ramsz4sicy3az5wa5wsq4rqm8dm3za48p3";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  }) // {inherit libX11 libXxf86vm ;};

  xhost = (mkDerivation "xhost" {
    name = "xhost-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xhost-1.0.6.tar.bz2;
      sha256 = "1hlxm0is9nks1cx033s1733kkib9ivx2bxa3pb9yayqavwibkxd6";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu xproto ];
  }) // {inherit libX11 libXau libXmu xproto ;};

  xineramaproto = (mkDerivation "xineramaproto" {
    name = "xineramaproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xineramaproto-1.2.1.tar.bz2;
      sha256 = "0ns8abd27x7gbp4r44z3wc5k9zqxxj8zjnazqpcyr4n17nxp8xcp";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xinit = (mkDerivation "xinit" {
    name = "xinit-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinit-1.3.3.tar.bz2;
      sha256 = "1bq0mqy7y305g2rds1g5443f3d2kgxzafqhmiyabbmg3ws6qgckl";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xinput = (mkDerivation "xinput" {
    name = "xinput-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinput-1.6.1.tar.bz2;
      sha256 = "07w7zlpdhpwzzshg8q0y152cy3wl2fj7x1897glnp2la487jsqxp";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi libXinerama libXrandr ];
  }) // {inherit inputproto libX11 libXext libXi libXinerama libXrandr ;};

  xkbcomp = (mkDerivation "xkbcomp" {
    name = "xkbcomp-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkbcomp-1.2.4.tar.bz2;
      sha256 = "0bas1d2wjiy5zy9d0g92d2p9pwv4aapfbfidi7hxy8ax8jmwkl4i";
    };
    buildInputs = [pkgconfig libX11 libxkbfile xproto ];
  }) // {inherit libX11 libxkbfile xproto ;};

  xkbevd = (mkDerivation "xkbevd" {
    name = "xkbevd-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkbevd-1.1.3.tar.bz2;
      sha256 = "05h1xcnbalndbrryyqs8wzy9h3wz655vc0ymhlk2q4aik17licjm";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};

  xkbprint = (mkDerivation "xkbprint" {
    name = "xkbprint-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbprint-1.0.3.tar.bz2;
      sha256 = "1h4jb3gjrbjp79h5gcgkjvdxykcy2bmq03smpls820c8wnw6v17s";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};

  xkbutils = (mkDerivation "xkbutils" {
    name = "xkbutils-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbutils-1.0.4.tar.bz2;
      sha256 = "0c412isxl65wplhl7nsk12vxlri29lk48g3p52hbrs3m0awqm8fj";
    };
    buildInputs = [pkgconfig inputproto libX11 libXaw xproto libXt ];
  }) // {inherit inputproto libX11 libXaw xproto libXt ;};

  xkeyboardconfig = (mkDerivation "xkeyboardconfig" {
    name = "xkeyboard-config-2.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.11.tar.bz2;
      sha256 = "0xkdyyi759hzls42hp4j3q2lc35n4j6b2g44ilx5qarci5h584p7";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xkill = (mkDerivation "xkill" {
    name = "xkill-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkill-1.0.4.tar.bz2;
      sha256 = "0bl1ky8ps9jg842j4mnmf4zbx8nkvk0h77w7bqjlpwij9wq2mvw8";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
  }) // {inherit libX11 libXmu xproto ;};

  xlsatoms = (mkDerivation "xlsatoms" {
    name = "xlsatoms-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xlsatoms-1.1.1.tar.bz2;
      sha256 = "1y9nfl8s7njxbnci8c20j986xixharasgg40vdw92y593j6dk2rv";
    };
    buildInputs = [pkgconfig libxcb ];
  }) // {inherit libxcb ;};

  xlsclients = (mkDerivation "xlsclients" {
    name = "xlsclients-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsclients-1.1.3.tar.bz2;
      sha256 = "0g9x7rrggs741x9xwvv1k9qayma980d88nhdqw7j3pn3qvy6d5jx";
    };
    buildInputs = [pkgconfig libxcb ];
  }) // {inherit libxcb ;};

  xmessage = (mkDerivation "xmessage" {
    name = "xmessage-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.4.tar.bz2;
      sha256 = "0s5bjlpxnmh8sxx6nfg9m0nr32r1sr3irr71wsnv76s33i34ppxw";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};

  xmodmap = (mkDerivation "xmodmap" {
    name = "xmodmap-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmodmap-1.0.8.tar.bz2;
      sha256 = "1hwzm54m4ng09ls9i4bq0x84zbyhamgzasgrvhxxp8jqk34f7qpg";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xorgcffiles = (mkDerivation "xorgcffiles" {
    name = "xorg-cf-files-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.5.tar.bz2;
      sha256 = "1m3ypq0xcy46ghxc0svl1rbhpy3zvgmy0aa2mn7w7v7d8d8bh8zd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xorgdocs = (mkDerivation "xorgdocs" {
    name = "xorg-docs-1.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xorg-docs-1.7.tar.bz2;
      sha256 = "0prphdba6kgr1bxk7r07wxxx6x6pqjw6prr5qclypsb5sf5r3cdr";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xorgserver = (mkDerivation "xorgserver" {
    name = "xorg-server-1.14.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.14.7.tar.bz2;
      sha256 = "07s54g9q1bry1050dsa7x6hy55yjvq9sxs6ks89pc8l6mnk6zxpw";
    };
    buildInputs = [pkgconfig renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ];
  }) // {inherit renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ;};

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
  }) // {inherit ;};

  xpr = (mkDerivation "xpr" {
    name = "xpr-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xpr-1.0.4.tar.bz2;
      sha256 = "1dbcv26w2yand2qy7b3h5rbvw1mdmdd57jw88v53sgdr3vrqvngy";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
  }) // {inherit libX11 libXmu xproto ;};

  xprop = (mkDerivation "xprop" {
    name = "xprop-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xprop-1.2.2.tar.bz2;
      sha256 = "1ilvhqfjcg6f1hqahjkp8qaay9rhvmv2blvj3w9asraq0aqqivlv";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xproto = (mkDerivation "xproto" {
    name = "xproto-7.0.26";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xproto-7.0.26.tar.bz2;
      sha256 = "0ksi8vhfd916bx2f3xlyhn6azf6cvvzrsdja26haa1cqfp0n4qb3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xrandr = (mkDerivation "xrandr" {
    name = "xrandr-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrandr-1.4.2.tar.bz2;
      sha256 = "1g4hnj53wknsjwiqivyy3jl4qw7jwrpncz7d5p2z29zq5zlnxrxj";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr libXrender ];
  }) // {inherit libX11 xproto libXrandr libXrender ;};

  xrdb = (mkDerivation "xrdb" {
    name = "xrdb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrdb-1.1.0.tar.bz2;
      sha256 = "0nsnr90wazcdd50nc5dqswy0bmq6qcj14nnrhyi7rln9pxmpp0kk";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
  }) // {inherit libX11 libXmu xproto ;};

  xrefresh = (mkDerivation "xrefresh" {
    name = "xrefresh-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrefresh-1.0.5.tar.bz2;
      sha256 = "1mlinwgvql6s1rbf46yckbfr9j22d3c3z7jx3n6ix7ca18dnf4rj";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xset = (mkDerivation "xset" {
    name = "xset-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xset-1.2.3.tar.bz2;
      sha256 = "0qw0iic27bz3yz2wynf1gxs70hhkcf9c4jrv7zhlg1mq57xz90j3";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu xproto libXxf86misc ];
  }) // {inherit libX11 libXext libXmu xproto libXxf86misc ;};

  xsetroot = (mkDerivation "xsetroot" {
    name = "xsetroot-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xsetroot-1.1.0.tar.bz2;
      sha256 = "1bazzsf9sy0q2bj4lxvh1kvyrhmpggzb7jg575i15sksksa3xwc8";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXcursor libXmu ];
  }) // {inherit libX11 xbitmaps libXcursor libXmu ;};

  xtrans = (mkDerivation "xtrans" {
    name = "xtrans-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/xtrans-1.3.4.tar.bz2;
      sha256 = "0fjq9xa37k1czkidj3c5sads51gibrjvrxz9ag3hh9fmxzilwk85";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};

  xvinfo = (mkDerivation "xvinfo" {
    name = "xvinfo-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xvinfo-1.1.2.tar.bz2;
      sha256 = "1qsh7fszi727l3vwlaf9pb7bpikdv15smrx5qhlgg3kqzl7xklzf";
    };
    buildInputs = [pkgconfig libX11 xproto libXv ];
  }) // {inherit libX11 xproto libXv ;};

  xwd = (mkDerivation "xwd" {
    name = "xwd-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xwd-1.0.6.tar.bz2;
      sha256 = "0ybx48agdvjp9lgwvcw79r1x6jbqbyl3fliy3i5xwy4d4si9dcrv";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

  xwininfo = (mkDerivation "xwininfo" {
    name = "xwininfo-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xwininfo-1.1.3.tar.bz2;
      sha256 = "1y1zn8ijqslb5lfpbq4bb78kllhch8in98ps7n8fg3dxjpmb13i1";
    };
    buildInputs = [pkgconfig libX11 libxcb xproto ];
  }) // {inherit libX11 libxcb xproto ;};

  xwud = (mkDerivation "xwud" {
    name = "xwud-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xwud-1.0.4.tar.bz2;
      sha256 = "1ggql6maivah58kwsh3z9x1hvzxm1a8888xx4s78cl77ryfa1cyn";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  }) // {inherit libX11 xproto ;};

}; in xorg
