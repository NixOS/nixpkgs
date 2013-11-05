# THIS IS A GENERATED FILE.  DO NOT EDIT!
args: with args;

let

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

  inherit pixman;

  applewmproto = (stdenv.mkDerivation ((if overrides ? applewmproto then overrides.applewmproto else x: x) {
    name = "applewmproto-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/applewmproto-1.4.2.tar.bz2;
      sha256 = "1zi4p07mp6jmk030p4gmglwxcwp0lzs5mi31y1b4rp8lsqxdxizw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  bdftopcf = (stdenv.mkDerivation ((if overrides ? bdftopcf then overrides.bdftopcf else x: x) {
    name = "bdftopcf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/bdftopcf-1.0.3.tar.bz2;
      sha256 = "02hx981f7jfwylxj21s91yvv4h597nqqzz3vd6ar81zyn84b944w";
    };
    buildInputs = [pkgconfig libXfont ];
  })) // {inherit libXfont ;};

  bigreqsproto = (stdenv.mkDerivation ((if overrides ? bigreqsproto then overrides.bigreqsproto else x: x) {
    name = "bigreqsproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/bigreqsproto-1.1.2.tar.bz2;
      sha256 = "07hvfm84scz8zjw14riiln2v4w03jlhp756ypwhq27g48jmic8a6";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  compositeproto = (stdenv.mkDerivation ((if overrides ? compositeproto then overrides.compositeproto else x: x) {
    name = "compositeproto-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/compositeproto-0.4.2.tar.bz2;
      sha256 = "1z0crmf669hirw4s7972mmp8xig80kfndja9h559haqbpvq5k4q4";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  damageproto = (stdenv.mkDerivation ((if overrides ? damageproto then overrides.damageproto else x: x) {
    name = "damageproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/damageproto-1.2.1.tar.bz2;
      sha256 = "0nzwr5pv9hg7c21n995pdiv0zqhs91yz3r8rn3aska4ykcp12z2w";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  dmxproto = (stdenv.mkDerivation ((if overrides ? dmxproto then overrides.dmxproto else x: x) {
    name = "dmxproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/dmxproto-2.3.1.tar.bz2;
      sha256 = "02b5x9dkgajizm8dqyx2w6hmqx3v25l67mgf35nj6sz0lgk52877";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  dri2proto = (stdenv.mkDerivation ((if overrides ? dri2proto then overrides.dri2proto else x: x) {
    name = "dri2proto-2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri2proto-2.8.tar.bz2;
      sha256 = "015az1vfdqmil1yay5nlsmpf6cf7vcbpslxjb72cfkzlvrv59dgr";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  encodings = (stdenv.mkDerivation ((if overrides ? encodings then overrides.encodings else x: x) {
    name = "encodings-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/encodings-1.0.4.tar.bz2;
      sha256 = "0ffmaw80vmfwdgvdkp6495xgsqszb6s0iira5j0j6pd4i0lk3mnf";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fixesproto = (stdenv.mkDerivation ((if overrides ? fixesproto then overrides.fixesproto else x: x) {
    name = "fixesproto-5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/fixesproto-5.0.tar.bz2;
      sha256 = "1ki4wiq2iivx5g4w5ckzbjbap759kfqd72yg18m3zpbb4hqkybxs";
    };
    buildInputs = [pkgconfig xextproto ];
  })) // {inherit xextproto ;};

  fontadobe100dpi = (stdenv.mkDerivation ((if overrides ? fontadobe100dpi then overrides.fontadobe100dpi else x: x) {
    name = "font-adobe-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-100dpi-1.0.3.tar.bz2;
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobe75dpi = (stdenv.mkDerivation ((if overrides ? fontadobe75dpi then overrides.fontadobe75dpi else x: x) {
    name = "font-adobe-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-75dpi-1.0.3.tar.bz2;
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia100dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia100dpi then overrides.fontadobeutopia100dpi else x: x) {
    name = "font-adobe-utopia-100dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-100dpi-1.0.4.tar.bz2;
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia75dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia75dpi then overrides.fontadobeutopia75dpi else x: x) {
    name = "font-adobe-utopia-75dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-75dpi-1.0.4.tar.bz2;
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopiatype1 = (stdenv.mkDerivation ((if overrides ? fontadobeutopiatype1 then overrides.fontadobeutopiatype1 else x: x) {
    name = "font-adobe-utopia-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-adobe-utopia-type1-1.0.4.tar.bz2;
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontalias = (stdenv.mkDerivation ((if overrides ? fontalias then overrides.fontalias else x: x) {
    name = "font-alias-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-alias-1.0.3.tar.bz2;
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontarabicmisc = (stdenv.mkDerivation ((if overrides ? fontarabicmisc then overrides.fontarabicmisc else x: x) {
    name = "font-arabic-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-arabic-misc-1.0.3.tar.bz2;
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontbh100dpi = (stdenv.mkDerivation ((if overrides ? fontbh100dpi then overrides.fontbh100dpi else x: x) {
    name = "font-bh-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-100dpi-1.0.3.tar.bz2;
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbh75dpi = (stdenv.mkDerivation ((if overrides ? fontbh75dpi then overrides.fontbh75dpi else x: x) {
    name = "font-bh-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-75dpi-1.0.3.tar.bz2;
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter100dpi then overrides.fontbhlucidatypewriter100dpi else x: x) {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2;
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter75dpi then overrides.fontbhlucidatypewriter75dpi else x: x) {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2;
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhttf = (stdenv.mkDerivation ((if overrides ? fontbhttf then overrides.fontbhttf else x: x) {
    name = "font-bh-ttf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-ttf-1.0.3.tar.bz2;
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontbhtype1 = (stdenv.mkDerivation ((if overrides ? fontbhtype1 then overrides.fontbhtype1 else x: x) {
    name = "font-bh-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bh-type1-1.0.3.tar.bz2;
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontbitstream100dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream100dpi then overrides.fontbitstream100dpi else x: x) {
    name = "font-bitstream-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-100dpi-1.0.3.tar.bz2;
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontbitstream75dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream75dpi then overrides.fontbitstream75dpi else x: x) {
    name = "font-bitstream-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-75dpi-1.0.3.tar.bz2;
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontbitstreamtype1 = (stdenv.mkDerivation ((if overrides ? fontbitstreamtype1 then overrides.fontbitstreamtype1 else x: x) {
    name = "font-bitstream-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-bitstream-type1-1.0.3.tar.bz2;
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontcronyxcyrillic = (stdenv.mkDerivation ((if overrides ? fontcronyxcyrillic then overrides.fontcronyxcyrillic else x: x) {
    name = "font-cronyx-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cronyx-cyrillic-1.0.3.tar.bz2;
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontcursormisc = (stdenv.mkDerivation ((if overrides ? fontcursormisc then overrides.fontcursormisc else x: x) {
    name = "font-cursor-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-cursor-misc-1.0.3.tar.bz2;
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontdaewoomisc = (stdenv.mkDerivation ((if overrides ? fontdaewoomisc then overrides.fontdaewoomisc else x: x) {
    name = "font-daewoo-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-daewoo-misc-1.0.3.tar.bz2;
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontdecmisc = (stdenv.mkDerivation ((if overrides ? fontdecmisc then overrides.fontdecmisc else x: x) {
    name = "font-dec-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-dec-misc-1.0.3.tar.bz2;
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontibmtype1 = (stdenv.mkDerivation ((if overrides ? fontibmtype1 then overrides.fontibmtype1 else x: x) {
    name = "font-ibm-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-ibm-type1-1.0.3.tar.bz2;
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontisasmisc = (stdenv.mkDerivation ((if overrides ? fontisasmisc then overrides.fontisasmisc else x: x) {
    name = "font-isas-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-isas-misc-1.0.3.tar.bz2;
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontjismisc = (stdenv.mkDerivation ((if overrides ? fontjismisc then overrides.fontjismisc else x: x) {
    name = "font-jis-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-jis-misc-1.0.3.tar.bz2;
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontmicromisc = (stdenv.mkDerivation ((if overrides ? fontmicromisc then overrides.fontmicromisc else x: x) {
    name = "font-micro-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-micro-misc-1.0.3.tar.bz2;
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontmisccyrillic = (stdenv.mkDerivation ((if overrides ? fontmisccyrillic then overrides.fontmisccyrillic else x: x) {
    name = "font-misc-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-cyrillic-1.0.3.tar.bz2;
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontmiscethiopic = (stdenv.mkDerivation ((if overrides ? fontmiscethiopic then overrides.fontmiscethiopic else x: x) {
    name = "font-misc-ethiopic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-ethiopic-1.0.3.tar.bz2;
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontmiscmeltho = (stdenv.mkDerivation ((if overrides ? fontmiscmeltho then overrides.fontmiscmeltho else x: x) {
    name = "font-misc-meltho-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-meltho-1.0.3.tar.bz2;
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  fontmiscmisc = (stdenv.mkDerivation ((if overrides ? fontmiscmisc then overrides.fontmiscmisc else x: x) {
    name = "font-misc-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-misc-misc-1.1.2.tar.bz2;
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontmuttmisc = (stdenv.mkDerivation ((if overrides ? fontmuttmisc then overrides.fontmuttmisc else x: x) {
    name = "font-mutt-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-mutt-misc-1.0.3.tar.bz2;
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontschumachermisc = (stdenv.mkDerivation ((if overrides ? fontschumachermisc then overrides.fontschumachermisc else x: x) {
    name = "font-schumacher-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-schumacher-misc-1.1.2.tar.bz2;
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontscreencyrillic = (stdenv.mkDerivation ((if overrides ? fontscreencyrillic then overrides.fontscreencyrillic else x: x) {
    name = "font-screen-cyrillic-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-screen-cyrillic-1.0.4.tar.bz2;
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontsonymisc = (stdenv.mkDerivation ((if overrides ? fontsonymisc then overrides.fontsonymisc else x: x) {
    name = "font-sony-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sony-misc-1.0.3.tar.bz2;
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontsproto = (stdenv.mkDerivation ((if overrides ? fontsproto then overrides.fontsproto else x: x) {
    name = "fontsproto-2.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/fontsproto-2.1.2.tar.bz2;
      sha256 = "1ab8mbqxdwvdz4k5x4xb9c4n5w7i1xw276cbpk4z7a1nlpjrg746";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontsunmisc = (stdenv.mkDerivation ((if overrides ? fontsunmisc then overrides.fontsunmisc else x: x) {
    name = "font-sun-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-sun-misc-1.0.3.tar.bz2;
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontutil = (stdenv.mkDerivation ((if overrides ? fontutil then overrides.fontutil else x: x) {
    name = "font-util-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-util-1.3.0.tar.bz2;
      sha256 = "15cijajwhjzpy3ydc817zz8x5z4gbkyv3fps687jbq544mbfbafz";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontwinitzkicyrillic = (stdenv.mkDerivation ((if overrides ? fontwinitzkicyrillic then overrides.fontwinitzkicyrillic else x: x) {
    name = "font-winitzki-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-winitzki-cyrillic-1.0.3.tar.bz2;
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};

  fontxfree86type1 = (stdenv.mkDerivation ((if overrides ? fontxfree86type1 then overrides.fontxfree86type1 else x: x) {
    name = "font-xfree86-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/font-xfree86-type1-1.0.4.tar.bz2;
      sha256 = "0jp3zc0qfdaqfkgzrb44vi9vi0a8ygb35wp082yz7rvvxhmg9sya";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};

  gccmakedep = (stdenv.mkDerivation ((if overrides ? gccmakedep then overrides.gccmakedep else x: x) {
    name = "gccmakedep-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/gccmakedep-1.0.2.tar.bz2;
      sha256 = "04dfamx3fvkvqfgs6xy2a6yqbxjrj4777ylxp38g60hhbdl4jg86";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  glproto = (stdenv.mkDerivation ((if overrides ? glproto then overrides.glproto else x: x) {
    name = "glproto-1.4.16";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/glproto-1.4.16.tar.bz2;
      sha256 = "13arnb4bz5pn89bxbh3shr8gihkhyznpjnq3zzr05msygwx6dpal";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  iceauth = (stdenv.mkDerivation ((if overrides ? iceauth then overrides.iceauth else x: x) {
    name = "iceauth-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/iceauth-1.0.5.tar.bz2;
      sha256 = "1aq6v671s2x5rc6zn0rgxb4wddg4vq94mckw3cpwl7ccrjjvd5hl";
    };
    buildInputs = [pkgconfig libICE xproto ];
  })) // {inherit libICE xproto ;};

  imake = (stdenv.mkDerivation ((if overrides ? imake then overrides.imake else x: x) {
    name = "imake-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.5.tar.bz2;
      sha256 = "1h8ww97aymm10l9qn21n1b9x5ypjrqr10qpf48jjcbc9fg77gklr";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  inputproto = (stdenv.mkDerivation ((if overrides ? inputproto then overrides.inputproto else x: x) {
    name = "inputproto-2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/inputproto-2.3.tar.bz2;
      sha256 = "0by3aa8i1gki6i904i34vlrymv5p8il05gr83sf8x7v9ys9v29kx";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  kbproto = (stdenv.mkDerivation ((if overrides ? kbproto then overrides.kbproto else x: x) {
    name = "kbproto-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/kbproto-1.0.6.tar.bz2;
      sha256 = "0yal11hhpiisy3w8wmacsdzzzcnc3xwnswxz8k7zri40xc5aqz03";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  libAppleWM = (stdenv.mkDerivation ((if overrides ? libAppleWM then overrides.libAppleWM else x: x) {
    name = "libAppleWM-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libAppleWM-1.4.1.tar.bz2;
      sha256 = "0r8x28n45q89x91mz8mv0zkkcxi8wazkac886fyvflhiv2y8ap2y";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  })) // {inherit applewmproto libX11 libXext xextproto ;};

  libFS = (stdenv.mkDerivation ((if overrides ? libFS then overrides.libFS else x: x) {
    name = "libFS-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libFS-1.0.5.tar.bz2;
      sha256 = "01v1z6hy702pcxz89kqb84w9gjjrvnjqsxc2zzvswlw0vl2k1sr2";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  })) // {inherit fontsproto xproto xtrans ;};

  libICE = (stdenv.mkDerivation ((if overrides ? libICE then overrides.libICE else x: x) {
    name = "libICE-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libICE-1.0.8.tar.bz2;
      sha256 = "07mp13pb3s73kj7y490gnx619znzwk91mlf8kdw0rzq29ll93a94";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  })) // {inherit xproto xtrans ;};

  libSM = (stdenv.mkDerivation ((if overrides ? libSM then overrides.libSM else x: x) {
    name = "libSM-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libSM-1.2.1.tar.bz2;
      sha256 = "07bzi6xwlhq36f60qfspjbz0qjj7zcgayi1vp4ihgx34kib1vhck";
    };
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
  })) // {inherit libICE libuuid xproto xtrans ;};

  libWindowsWM = (stdenv.mkDerivation ((if overrides ? libWindowsWM then overrides.libWindowsWM else x: x) {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libWindowsWM-1.0.1.tar.bz2;
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  })) // {inherit windowswmproto libX11 libXext xextproto ;};

  libX11 = (stdenv.mkDerivation ((if overrides ? libX11 then overrides.libX11 else x: x) {
    name = "libX11-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.6.1.tar.bz2;
      sha256 = "14hqf180dxax3xf65bq95psd4bx8az1q1l6lxsjzbd2qdg0lz98h";
    };
    buildInputs = [pkgconfig inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ];
  })) // {inherit inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ;};

  libXScrnSaver = (stdenv.mkDerivation ((if overrides ? libXScrnSaver then overrides.libXScrnSaver else x: x) {
    name = "libXScrnSaver-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXScrnSaver-1.2.2.tar.bz2;
      sha256 = "07ff4r20nkkrj7h08f9fwamds9b3imj8jz5iz6y38zqw6jkyzwcg";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  })) // {inherit scrnsaverproto libX11 libXext xextproto ;};

  libXau = (stdenv.mkDerivation ((if overrides ? libXau then overrides.libXau else x: x) {
    name = "libXau-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXau-1.0.7.tar.bz2;
      sha256 = "12d4f7sdv2pjxhk0lcay0pahccddszkw579dc59daqi37r8bllvi";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  libXaw = (stdenv.mkDerivation ((if overrides ? libXaw then overrides.libXaw else x: x) {
    name = "libXaw-1.0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXaw-1.0.11.tar.bz2;
      sha256 = "14ll7ndf5njc30hz2w197qvwp7fqj7y14wq4p1cyxlbipfn79a47";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXmu libXpm xproto libXt ];
  })) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};

  libXcomposite = (stdenv.mkDerivation ((if overrides ? libXcomposite then overrides.libXcomposite else x: x) {
    name = "libXcomposite-0.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXcomposite-0.4.3.tar.bz2;
      sha256 = "1b8sniijb85v4my6v30ma9yqnwl4hkclci9l1hqxnipfyhl4sa9j";
    };
    buildInputs = [pkgconfig compositeproto libX11 libXfixes xproto ];
  })) // {inherit compositeproto libX11 libXfixes xproto ;};

  libXcursor = (stdenv.mkDerivation ((if overrides ? libXcursor then overrides.libXcursor else x: x) {
    name = "libXcursor-1.1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcursor-1.1.14.tar.bz2;
      sha256 = "1prkdicl5y5yx32h1azh6gjfbijvjp415javv8dsakd13jrarilv";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
  })) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};

  libXdamage = (stdenv.mkDerivation ((if overrides ? libXdamage then overrides.libXdamage else x: x) {
    name = "libXdamage-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXdamage-1.1.3.tar.bz2;
      sha256 = "1a678bwap74sqczbr2z4y4fvbr35km3inkm8bi1igjyk4v46jqdw";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
  })) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};

  libXdmcp = (stdenv.mkDerivation ((if overrides ? libXdmcp then overrides.libXdmcp else x: x) {
    name = "libXdmcp-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXdmcp-1.1.1.tar.bz2;
      sha256 = "13highx4xpgkiwykpcl7z2laslrjc4pzi4h617ny9p7r6116vkls";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  libXext = (stdenv.mkDerivation ((if overrides ? libXext then overrides.libXext else x: x) {
    name = "libXext-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXext-1.3.2.tar.bz2;
      sha256 = "1q1j0kjyhmy24wqr6mdkrrciffyqhmc8vn95za2w1ka6qrdhfagq";
    };
    buildInputs = [pkgconfig libX11 xextproto xproto ];
  })) // {inherit libX11 xextproto xproto ;};

  libXfixes = (stdenv.mkDerivation ((if overrides ? libXfixes then overrides.libXfixes else x: x) {
    name = "libXfixes-5.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfixes-5.0.1.tar.bz2;
      sha256 = "0rs7qgzr6dpr62db7sd91c1b47hzhzfr010qwnpcm8sg122w1gk3";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  })) // {inherit fixesproto libX11 xextproto xproto ;};

  libXfont = (stdenv.mkDerivation ((if overrides ? libXfont then overrides.libXfont else x: x) {
    name = "libXfont-1.4.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfont-1.4.6.tar.bz2;
      sha256 = "17vy2p8myxx8644yd05qsl2qvv9m3mhdbniw87mcw5ywai2zxjyh";
    };
    buildInputs = [pkgconfig libfontenc fontsproto freetype xproto xtrans zlib ];
  })) // {inherit libfontenc fontsproto freetype xproto xtrans zlib ;};

  libXft = (stdenv.mkDerivation ((if overrides ? libXft then overrides.libXft else x: x) {
    name = "libXft-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXft-2.3.1.tar.bz2;
      sha256 = "1gdv6559cdz1lfw73x7wsvax1fkvphmayrymprljhyyb5nwk5kkz";
    };
    buildInputs = [pkgconfig fontconfig freetype libX11 xproto libXrender ];
  })) // {inherit fontconfig freetype libX11 xproto libXrender ;};

  libXi = (stdenv.mkDerivation ((if overrides ? libXi then overrides.libXi else x: x) {
    name = "libXi-1.7.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXi-1.7.2.tar.bz2;
      sha256 = "03mj9i6h0n8icjkx5a16wh1gyyhfiayj02ydc6sy4i9nqqfph96z";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto libXfixes xproto ];
  })) // {inherit inputproto libX11 libXext xextproto libXfixes xproto ;};

  libXinerama = (stdenv.mkDerivation ((if overrides ? libXinerama then overrides.libXinerama else x: x) {
    name = "libXinerama-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXinerama-1.1.3.tar.bz2;
      sha256 = "1qlqfvzw45gdzk9xirgwlp2qgj0hbsyiqj8yh8zml2bk2ygnjibs";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  })) // {inherit libX11 libXext xextproto xineramaproto ;};

  libXmu = (stdenv.mkDerivation ((if overrides ? libXmu then overrides.libXmu else x: x) {
    name = "libXmu-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXmu-1.1.1.tar.bz2;
      sha256 = "1pbym8rrznxqd60zwf7w4xpf27sa72bky2knginqcfnca32q343h";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXp = (stdenv.mkDerivation ((if overrides ? libXp then overrides.libXp else x: x) {
    name = "libXp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.2.tar.bz2;
      sha256 = "1dfh5w8sjz5b5fl6dl4y63ckq99snslz7bir8zq2rg8ax6syabwm";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  })) // {inherit printproto libX11 libXau libXext xextproto ;};

  libXpm = (stdenv.mkDerivation ((if overrides ? libXpm then overrides.libXpm else x: x) {
    name = "libXpm-3.5.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXpm-3.5.10.tar.bz2;
      sha256 = "0dd737ch4q9gr151wff1m3q2j7wf3pip4y81601xdrsh8wipxnx6";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXrandr = (stdenv.mkDerivation ((if overrides ? libXrandr then overrides.libXrandr else x: x) {
    name = "libXrandr-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrandr-1.4.1.tar.bz2;
      sha256 = "01dr1wvyxq2y4yq4hilgglkjlvn551dmnl4l65nfm8nh1x4s056r";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
  })) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};

  libXrender = (stdenv.mkDerivation ((if overrides ? libXrender then overrides.libXrender else x: x) {
    name = "libXrender-0.9.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrender-0.9.8.tar.bz2;
      sha256 = "0qpwyjhbpp734vnhca992pjh4w7ijslidkzx1pcwbbk000pv050x";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
  })) // {inherit renderproto libX11 xproto ;};

  libXres = (stdenv.mkDerivation ((if overrides ? libXres then overrides.libXres else x: x) {
    name = "libXres-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXres-1.0.7.tar.bz2;
      sha256 = "1rd0bzn67cpb2qkc946gch2183r4bdjfhs6cpqbipy47m9a91296";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
  })) // {inherit resourceproto libX11 libXext xextproto xproto ;};

  libXt = (stdenv.mkDerivation ((if overrides ? libXt then overrides.libXt else x: x) {
    name = "libXt-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXt-1.1.4.tar.bz2;
      sha256 = "0myxwbx9ylam5x3ia5b5f4x8azcqdm420h9ad1r4hrgmi2lrffl4";
    };
    buildInputs = [pkgconfig libICE kbproto libSM libX11 xproto ];
  })) // {inherit libICE kbproto libSM libX11 xproto ;};

  libXtst = (stdenv.mkDerivation ((if overrides ? libXtst then overrides.libXtst else x: x) {
    name = "libXtst-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libXtst-1.2.1.tar.bz2;
      sha256 = "1q750hjplq1rfyxkr4545z1y2a1wfnc828ynvbws7b4jwdk3xsky";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto libXi ];
  })) // {inherit inputproto recordproto libX11 libXext xextproto libXi ;};

  libXv = (stdenv.mkDerivation ((if overrides ? libXv then overrides.libXv else x: x) {
    name = "libXv-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXv-1.0.8.tar.bz2;
      sha256 = "1mvkmypf9rsr3lr161hf9sjadlirb116jfp5lk70j29r8x9yn02g";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
  })) // {inherit videoproto libX11 libXext xextproto xproto ;};

  libXvMC = (stdenv.mkDerivation ((if overrides ? libXvMC then overrides.libXvMC else x: x) {
    name = "libXvMC-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXvMC-1.0.8.tar.bz2;
      sha256 = "015jk3bxfmj6zaw99x282f9npi8qqaw34yg186frags3z8g406jy";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
  })) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};

  libXxf86dga = (stdenv.mkDerivation ((if overrides ? libXxf86dga then overrides.libXxf86dga else x: x) {
    name = "libXxf86dga-1.1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86dga-1.1.4.tar.bz2;
      sha256 = "0zn7aqj8x0951d8zb2h2andldvwkzbsc4cs7q023g6nzq6vd9v4f";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};

  libXxf86misc = (stdenv.mkDerivation ((if overrides ? libXxf86misc then overrides.libXxf86misc else x: x) {
    name = "libXxf86misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86misc-1.0.3.tar.bz2;
      sha256 = "0nvbq9y6k6m9hxdvg3crycqsnnxf1859wrisqcs37z9fhq044gsn";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};

  libXxf86vm = (stdenv.mkDerivation ((if overrides ? libXxf86vm then overrides.libXxf86vm else x: x) {
    name = "libXxf86vm-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86vm-1.1.3.tar.bz2;
      sha256 = "1f1pxj018nk7ybxv58jmn5y8gm2288p4q3l2dng9n1p25v1qcpns";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};

  libdmx = (stdenv.mkDerivation ((if overrides ? libdmx then overrides.libdmx else x: x) {
    name = "libdmx-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libdmx-1.1.3.tar.bz2;
      sha256 = "00djlxas38kbsrglcmwmxfbmxjdchlbj95pqwjvdg8jn5rns6zf9";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  })) // {inherit dmxproto libX11 libXext xextproto ;};

  libfontenc = (stdenv.mkDerivation ((if overrides ? libfontenc then overrides.libfontenc else x: x) {
    name = "libfontenc-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libfontenc-1.1.1.tar.bz2;
      sha256 = "0zq1483xy31sssq0h3xxf8y1v4q14cp8rv164ayn7fsn30pq2wny";
    };
    buildInputs = [pkgconfig xproto zlib ];
  })) // {inherit xproto zlib ;};

  libpciaccess = (stdenv.mkDerivation ((if overrides ? libpciaccess then overrides.libpciaccess else x: x) {
    name = "libpciaccess-0.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.13.2.tar.bz2;
      sha256 = "06fy43n3c450h7xqpn3094bnfn7ca1mrq3i856y8kyqa0lmqraxb";
    };
    buildInputs = [pkgconfig zlib ];
  })) // {inherit zlib ;};

  libpthreadstubs = (stdenv.mkDerivation ((if overrides ? libpthreadstubs then overrides.libpthreadstubs else x: x) {
    name = "libpthread-stubs-0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.bz2;
      sha256 = "16bjv3in19l84hbri41iayvvg4ls9gv1ma0x0qlbmwy67i7dbdim";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  libxcb = (stdenv.mkDerivation ((if overrides ? libxcb then overrides.libxcb else x: x) {
    name = "libxcb-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.9.1.tar.bz2;
      sha256 = "0brn7vw66widc5mw7gynwy8dln3gmzym2fqqyzk6k58bxgs5yjnl";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
  })) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};

  libxkbfile = (stdenv.mkDerivation ((if overrides ? libxkbfile then overrides.libxkbfile else x: x) {
    name = "libxkbfile-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/libxkbfile-1.0.8.tar.bz2;
      sha256 = "0flg5arw6n3njagmsi4i4l0zl5bfx866a1h9ydc3bi1pqlclxaca";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  })) // {inherit kbproto libX11 ;};

  lndir = (stdenv.mkDerivation ((if overrides ? lndir then overrides.lndir else x: x) {
    name = "lndir-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.3.tar.bz2;
      sha256 = "0pdngiy8zdhsiqx2am75yfcl36l7kd7d7nl0rss8shcdvsqgmx29";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  luit = (stdenv.mkDerivation ((if overrides ? luit then overrides.luit else x: x) {
    name = "luit-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/luit-1.1.1.tar.bz2;
      sha256 = "0dn694mk56x6hdk6y9ylx4f128h5jcin278gnw2gb807rf3ygc1h";
    };
    buildInputs = [pkgconfig libfontenc ];
  })) // {inherit libfontenc ;};

  makedepend = (stdenv.mkDerivation ((if overrides ? makedepend then overrides.makedepend else x: x) {
    name = "makedepend-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/makedepend-1.0.4.tar.bz2;
      sha256 = "1zpp2b9dfvlnfj2i1mzdyn785rpl7vih5lap7kcpiv80xspbhmmb";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  mkfontdir = (stdenv.mkDerivation ((if overrides ? mkfontdir then overrides.mkfontdir else x: x) {
    name = "mkfontdir-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/mkfontdir-1.0.7.tar.bz2;
      sha256 = "0c3563kw9fg15dpgx4dwvl12qz6sdqdns1pxa574hc7i5m42mman";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  mkfontscale = (stdenv.mkDerivation ((if overrides ? mkfontscale then overrides.mkfontscale else x: x) {
    name = "mkfontscale-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/mkfontscale-1.1.0.tar.bz2;
      sha256 = "1539h3ws66vcql6sf2831bcs0r4d9b05lcgpswkw33lvcxighmff";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  })) // {inherit libfontenc freetype xproto zlib ;};

  printproto = (stdenv.mkDerivation ((if overrides ? printproto then overrides.printproto else x: x) {
    name = "printproto-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/printproto-1.0.5.tar.bz2;
      sha256 = "06liap8n4s25sgp27d371cc7yg9a08dxcr3pmdjp761vyin3360j";
    };
    buildInputs = [pkgconfig libXau ];
  })) // {inherit libXau ;};

  randrproto = (stdenv.mkDerivation ((if overrides ? randrproto then overrides.randrproto else x: x) {
    name = "randrproto-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/randrproto-1.4.0.tar.bz2;
      sha256 = "1kq9h93qdnniiivry8jmhlgwn9fbx9xp5r9cmzfihlx5cs62xi45";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  recordproto = (stdenv.mkDerivation ((if overrides ? recordproto then overrides.recordproto else x: x) {
    name = "recordproto-1.14.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/recordproto-1.14.2.tar.bz2;
      sha256 = "0w3kgr1zabwf79bpc28dcnj0fpni6r53rpi82ngjbalj5s6m8xx7";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  renderproto = (stdenv.mkDerivation ((if overrides ? renderproto then overrides.renderproto else x: x) {
    name = "renderproto-0.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/renderproto-0.11.1.tar.bz2;
      sha256 = "0dr5xw6s0qmqg0q5pdkb4jkdhaja0vbfqla79qh5j1xjj9dmlwq6";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  resourceproto = (stdenv.mkDerivation ((if overrides ? resourceproto then overrides.resourceproto else x: x) {
    name = "resourceproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/resourceproto-1.2.0.tar.bz2;
      sha256 = "0638iyfiiyjw1hg3139pai0j6m65gkskrvd9684zgc6ydcx00riw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  scrnsaverproto = (stdenv.mkDerivation ((if overrides ? scrnsaverproto then overrides.scrnsaverproto else x: x) {
    name = "scrnsaverproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/scrnsaverproto-1.2.2.tar.bz2;
      sha256 = "0rfdbfwd35d761xkfifcscx56q0n56043ixlmv70r4v4l66hmdwb";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  sessreg = (stdenv.mkDerivation ((if overrides ? sessreg then overrides.sessreg else x: x) {
    name = "sessreg-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/sessreg-1.0.7.tar.bz2;
      sha256 = "0lifgjxdvc6lwyjk90slddnr12fsv88ldy6qhklr5av409cfwd47";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  setxkbmap = (stdenv.mkDerivation ((if overrides ? setxkbmap then overrides.setxkbmap else x: x) {
    name = "setxkbmap-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/setxkbmap-1.3.0.tar.bz2;
      sha256 = "1inygpvlgc6vr5h9laxw9lnvafnccl3fy0g5n9ll28iq3yfmqc1x";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};

  smproxy = (stdenv.mkDerivation ((if overrides ? smproxy then overrides.smproxy else x: x) {
    name = "smproxy-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/smproxy-1.0.5.tar.bz2;
      sha256 = "02fn5wa1gs2jap6sr9j9yk6zsvz82j8l61pf74iyqwa99q4wnb67";
    };
    buildInputs = [pkgconfig libICE libSM libXmu libXt ];
  })) // {inherit libICE libSM libXmu libXt ;};

  twm = (stdenv.mkDerivation ((if overrides ? twm then overrides.twm else x: x) {
    name = "twm-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/twm-1.0.7.tar.bz2;
      sha256 = "0i6dbf5vafi5hm4bcmnj6r412cncjlv9hkkbr6bzlh15qvg56p8g";
    };
    buildInputs = [pkgconfig libICE libSM libX11 libXext libXmu xproto libXt ];
  })) // {inherit libICE libSM libX11 libXext libXmu xproto libXt ;};

  utilmacros = (stdenv.mkDerivation ((if overrides ? utilmacros then overrides.utilmacros else x: x) {
    name = "util-macros-1.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/util-macros-1.17.tar.bz2;
      sha256 = "1vbmrcn5n3wp4pyw0n4c3pyvzlc4yf7jzgngavfdq5zwfbgfsybx";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  videoproto = (stdenv.mkDerivation ((if overrides ? videoproto then overrides.videoproto else x: x) {
    name = "videoproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/videoproto-2.3.1.tar.bz2;
      sha256 = "0nk3i6gwkqq1w8zwn7bxz344pi1dwcjrmf6hr330h7hxjcj6viry";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  windowswmproto = (stdenv.mkDerivation ((if overrides ? windowswmproto then overrides.windowswmproto else x: x) {
    name = "windowswmproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/windowswmproto-1.0.4.tar.bz2;
      sha256 = "0syjxgy4m8l94qrm03nvn5k6bkxc8knnlld1gbllym97nvnv0ny0";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  x11perf = (stdenv.mkDerivation ((if overrides ? x11perf then overrides.x11perf else x: x) {
    name = "x11perf-1.5.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/x11perf-1.5.4.tar.bz2;
      sha256 = "111iwpxhnxjiq44w96zf0kszg5zpgv1g3ayx18v4nhdzl9bqivi4";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  })) // {inherit libX11 libXext libXft libXmu libXrender ;};

  xauth = (stdenv.mkDerivation ((if overrides ? xauth then overrides.xauth else x: x) {
    name = "xauth-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xauth-1.0.7.tar.bz2;
      sha256 = "1382wdfiakgckbw1xxavzh1nm34q21b1zzy96qp7ws66xc48rxw4";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  })) // {inherit libX11 libXau libXext libXmu ;};

  xbacklight = (stdenv.mkDerivation ((if overrides ? xbacklight then overrides.xbacklight else x: x) {
    name = "xbacklight-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xbacklight-1.2.0.tar.bz2;
      sha256 = "199n9qszjiz82nbjz6ychh0xl15igm535mv0830wk4m59w9xclji";
    };
    buildInputs = [pkgconfig libxcb xcbutil ];
  })) // {inherit libxcb xcbutil ;};

  xbitmaps = (stdenv.mkDerivation ((if overrides ? xbitmaps then overrides.xbitmaps else x: x) {
    name = "xbitmaps-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xbitmaps-1.1.1.tar.bz2;
      sha256 = "178ym90kwidia6nas4qr5n5yqh698vv8r02js0r4vg3b6lsb0w9n";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xcbproto = (stdenv.mkDerivation ((if overrides ? xcbproto then overrides.xcbproto else x: x) {
    name = "xcb-proto-1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.8.tar.bz2;
      sha256 = "1c11652h9sjynw3scm1pn5z3a6ci888pq7hij8q5n8qrl33icg93";
    };
    buildInputs = [pkgconfig python ];
  })) // {inherit python ;};

  xcbutil = (stdenv.mkDerivation ((if overrides ? xcbutil then overrides.xcbutil else x: x) {
    name = "xcb-util-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.3.9.tar.bz2;
      sha256 = "1i0qbhqkcdlbbsj7ifkyjsffl61whj24d3zlg5pxf3xj1af2a4f6";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};

  xcbutilimage = (stdenv.mkDerivation ((if overrides ? xcbutilimage then overrides.xcbutilimage else x: x) {
    name = "xcb-util-image-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-image-0.3.9.tar.bz2;
      sha256 = "1pr1l1nkg197gyl9d0fpwmn72jqpxjfgn9y13q4gawg1m873qnnk";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbutil xproto ];
  })) // {inherit gperf m4 libxcb xcbutil xproto ;};

  xcbutilkeysyms = (stdenv.mkDerivation ((if overrides ? xcbutilkeysyms then overrides.xcbutilkeysyms else x: x) {
    name = "xcb-util-keysyms-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.3.9.tar.bz2;
      sha256 = "0vjwk7vrcfnlhiadv445c6skfxmdrg5v4qf81y8s2s5xagqarqbv";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};

  xcbutilrenderutil = (stdenv.mkDerivation ((if overrides ? xcbutilrenderutil then overrides.xcbutilrenderutil else x: x) {
    name = "xcb-util-renderutil-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.8.tar.bz2;
      sha256 = "0lkl9ij9b447c0br2qc5qsynjn09c4fdz7sd6yp7pyi8az2sb2cp";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};

  xcbutilwm = (stdenv.mkDerivation ((if overrides ? xcbutilwm then overrides.xcbutilwm else x: x) {
    name = "xcb-util-wm-0.3.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-wm-0.3.9.tar.bz2;
      sha256 = "0c30fj33gvwzwhyz1dhsfwni0ai16bxpvxb4l6c6s7vvj7drp3q3";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};

  xclock = (stdenv.mkDerivation ((if overrides ? xclock then overrides.xclock else x: x) {
    name = "xclock-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.6.tar.bz2;
      sha256 = "1l1zxr69p0734fnx9rdqw79ahr273hr050sm8xdc0n51n1bnzfr1";
    };
    buildInputs = [pkgconfig libX11 libXaw libXft libxkbfile libXmu libXrender libXt ];
  })) // {inherit libX11 libXaw libXft libxkbfile libXmu libXrender libXt ;};

  xcmiscproto = (stdenv.mkDerivation ((if overrides ? xcmiscproto then overrides.xcmiscproto else x: x) {
    name = "xcmiscproto-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcmiscproto-1.2.2.tar.bz2;
      sha256 = "1pyjv45wivnwap2wvsbrzdvjc5ql8bakkbkrvcv6q9bjjf33ccmi";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xcmsdb = (stdenv.mkDerivation ((if overrides ? xcmsdb then overrides.xcmsdb else x: x) {
    name = "xcmsdb-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcmsdb-1.0.4.tar.bz2;
      sha256 = "03ms731l3kvaldq7ycbd30j6134b61i3gbll4b2gl022wyzbjq74";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xcursorgen = (stdenv.mkDerivation ((if overrides ? xcursorgen then overrides.xcursorgen else x: x) {
    name = "xcursorgen-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcursorgen-1.0.5.tar.bz2;
      sha256 = "10f5wk1326mm45gvgpf4m2p0j80fcd0i4c52zikahb91zah72wdw";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  })) // {inherit libpng libX11 libXcursor ;};

  xcursorthemes = (stdenv.mkDerivation ((if overrides ? xcursorthemes then overrides.xcursorthemes else x: x) {
    name = "xcursor-themes-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xcursor-themes-1.0.3.tar.bz2;
      sha256 = "1is4bak0qkkhv63mfa5l7492r475586y52yzfxyv3psppn662ilr";
    };
    buildInputs = [pkgconfig libXcursor ];
  })) // {inherit libXcursor ;};

  xdm = (stdenv.mkDerivation ((if overrides ? xdm then overrides.xdm else x: x) {
    name = "xdm-1.1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdm-1.1.11.tar.bz2;
      sha256 = "0iqw11977lpr9nk1is4fca84d531vck0mq7jldwl44m0vrnl5nnl";
    };
    buildInputs = [pkgconfig libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
  })) // {inherit libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};

  xdpyinfo = (stdenv.mkDerivation ((if overrides ? xdpyinfo then overrides.xdpyinfo else x: x) {
    name = "xdpyinfo-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xdpyinfo-1.3.0.tar.bz2;
      sha256 = "0gypsvpmay3lsh3b1dg29pjxv95pkrr21d4w6ys02mrbld24kvi3";
    };
    buildInputs = [pkgconfig libdmx libX11 libxcb libXcomposite libXext libXi libXinerama libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  })) // {inherit libdmx libX11 libxcb libXcomposite libXext libXi libXinerama libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};

  xdriinfo = (stdenv.mkDerivation ((if overrides ? xdriinfo then overrides.xdriinfo else x: x) {
    name = "xdriinfo-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xdriinfo-1.0.4.tar.bz2;
      sha256 = "076bjix941znyjmh3j5jjsnhp2gv2iq53d0ks29mvvv87cyy9iim";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  })) // {inherit glproto libX11 ;};

  xev = (stdenv.mkDerivation ((if overrides ? xev then overrides.xev else x: x) {
    name = "xev-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xev-1.2.0.tar.bz2;
      sha256 = "13xk5z7vy87rnn4574z0jfzymdivyc7pl4axim81sx0pmdysg1ip";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr ];
  })) // {inherit libX11 xproto libXrandr ;};

  xextproto = (stdenv.mkDerivation ((if overrides ? xextproto then overrides.xextproto else x: x) {
    name = "xextproto-7.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xextproto-7.2.1.tar.bz2;
      sha256 = "06kdanbnprxvgl56l5h0lqj4b0f1fbb1ndha33mv5wvy802v2lvw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xeyes = (stdenv.mkDerivation ((if overrides ? xeyes then overrides.xeyes else x: x) {
    name = "xeyes-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xeyes-1.1.1.tar.bz2;
      sha256 = "08d5x2kar5kg4yammw6hhk10iva6jmh8cqq176a1z7nm1il9hplp";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXrender libXt ];
  })) // {inherit libX11 libXext libXmu libXrender libXt ;};

  xf86bigfontproto = (stdenv.mkDerivation ((if overrides ? xf86bigfontproto then overrides.xf86bigfontproto else x: x) {
    name = "xf86bigfontproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86bigfontproto-1.2.0.tar.bz2;
      sha256 = "0j0n7sj5xfjpmmgx6n5x556rw21hdd18fwmavp95wps7qki214ms";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86dgaproto = (stdenv.mkDerivation ((if overrides ? xf86dgaproto then overrides.xf86dgaproto else x: x) {
    name = "xf86dgaproto-2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86dgaproto-2.1.tar.bz2;
      sha256 = "0l4hx48207mx0hp09026r6gy9nl3asbq0c75hri19wp1118zcpmc";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86driproto = (stdenv.mkDerivation ((if overrides ? xf86driproto then overrides.xf86driproto else x: x) {
    name = "xf86driproto-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86driproto-2.1.1.tar.bz2;
      sha256 = "07v69m0g2dfzb653jni4x656jlr7l84c1k39j8qc8vfb45r8sjww";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86inputevdev = (stdenv.mkDerivation ((if overrides ? xf86inputevdev then overrides.xf86inputevdev else x: x) {
    name = "xf86-input-evdev-2.7.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.7.3.tar.bz2;
      sha256 = "01557w1kmsaqdsc42pxyypig10l5r5vh9axz9g22hg9cc09r8f7b";
    };
    buildInputs = [pkgconfig inputproto udev xorgserver xproto ];
  })) // {inherit inputproto udev xorgserver xproto ;};

  xf86inputjoystick = (stdenv.mkDerivation ((if overrides ? xf86inputjoystick then overrides.xf86inputjoystick else x: x) {
    name = "xf86-input-joystick-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-joystick-1.6.2.tar.bz2;
      sha256 = "038mfqairyyqvz02rk7v3i070sab1wr0k6fkxvyvxdgkfbnqcfzf";
    };
    buildInputs = [pkgconfig inputproto kbproto xorgserver xproto ];
  })) // {inherit inputproto kbproto xorgserver xproto ;};

  xf86inputkeyboard = (stdenv.mkDerivation ((if overrides ? xf86inputkeyboard then overrides.xf86inputkeyboard else x: x) {
    name = "xf86-input-keyboard-1.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-input-keyboard-1.6.1.tar.bz2;
      sha256 = "1hwc1bjw5mxv186xbrxiky0agfglwqg8fsxqdh4br1vzgxpck7ma";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};

  xf86inputmouse = (stdenv.mkDerivation ((if overrides ? xf86inputmouse then overrides.xf86inputmouse else x: x) {
    name = "xf86-input-mouse-1.7.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-input-mouse-1.7.2.tar.bz2;
      sha256 = "0fs1lwnycyv3d0m6l2wrnlgvbs8qw66d93hwlnmrsswfq5bp6ark";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};

  xf86inputsynaptics = (stdenv.mkDerivation ((if overrides ? xf86inputsynaptics then overrides.xf86inputsynaptics else x: x) {
    name = "xf86-input-synaptics-1.7.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-synaptics-1.7.1.tar.bz2;
      sha256 = "13mmpcwp1d69w6c458a4fdqgwl24bpvrnq3zd6833chz1rk2an6v";
    };
    buildInputs = [pkgconfig inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ];
  })) // {inherit inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ;};

  xf86inputvmmouse = (stdenv.mkDerivation ((if overrides ? xf86inputvmmouse then overrides.xf86inputvmmouse else x: x) {
    name = "xf86-input-vmmouse-13.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-vmmouse-13.0.0.tar.bz2;
      sha256 = "0b31ap9wp7nwpnihz8m7bz3p0hhaipxxhl652nw4v380cq1vdkq4";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputvoid = (stdenv.mkDerivation ((if overrides ? xf86inputvoid then overrides.xf86inputvoid else x: x) {
    name = "xf86-input-void-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-void-1.4.0.tar.bz2;
      sha256 = "01bmk324fq48wydvy1qrnxbw6qz0fjd0i80g0n4cqr1c4mjmif9a";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};

  xf86miscproto = (stdenv.mkDerivation ((if overrides ? xf86miscproto then overrides.xf86miscproto else x: x) {
    name = "xf86miscproto-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xf86miscproto-0.9.3.tar.bz2;
      sha256 = "15dhcdpv61fyj6rhzrhnwri9hlw8rjfy05z1vik118lc99mfrf25";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86videoark = (stdenv.mkDerivation ((if overrides ? xf86videoark then overrides.xf86videoark else x: x) {
    name = "xf86-video-ark-0.7.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ark-0.7.5.tar.bz2;
      sha256 = "07p5vdsj2ckxb6wh02s61akcv4qfg6s1d5ld3jn3lfaayd3f1466";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess xextproto xorgserver xproto ;};

  xf86videoast = (stdenv.mkDerivation ((if overrides ? xf86videoast then overrides.xf86videoast else x: x) {
    name = "xf86-video-ast-0.98.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ast-0.98.0.tar.bz2;
      sha256 = "188nv73w0p5xhfxz2dffli44yzyn1qhhq3qkwc8wva9dhg25n8lh";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoati = (stdenv.mkDerivation ((if overrides ? xf86videoati then overrides.xf86videoati else x: x) {
    name = "xf86-video-ati-7.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-7.1.0.tar.bz2;
      sha256 = "1k8hwszx1zj17z0657dna8q4k7x67adc163z44jiccyb3w2l9bn8";
    };
    buildInputs = [pkgconfig fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videocirrus = (stdenv.mkDerivation ((if overrides ? xf86videocirrus then overrides.xf86videocirrus else x: x) {
    name = "xf86-video-cirrus-1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-cirrus-1.5.2.tar.bz2;
      sha256 = "1mycqgjp18b6adqj2h90vp324xh8ysyi5migfmjc914vbnkf2q9k";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videodummy = (stdenv.mkDerivation ((if overrides ? xf86videodummy then overrides.xf86videodummy else x: x) {
    name = "xf86-video-dummy-0.3.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-dummy-0.3.7.tar.bz2;
      sha256 = "1046p64xap69vlsmsz5rjv0djc970yhvq44fmllmas0mqp5lzy2n";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};

  xf86videofbdev = (stdenv.mkDerivation ((if overrides ? xf86videofbdev then overrides.xf86videofbdev else x: x) {
    name = "xf86-video-fbdev-0.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-fbdev-0.4.4.tar.bz2;
      sha256 = "06ym7yy017lanj730hfkpfk4znx3dsj8jq3qvyzsn8w294kb7m4x";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};

  xf86videogeode = (stdenv.mkDerivation ((if overrides ? xf86videogeode then overrides.xf86videogeode else x: x) {
    name = "xf86-video-geode-2.11.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-geode-2.11.14.tar.bz2;
      sha256 = "1k6gl1kq2fr0gj6sqrg2rypp59f8b8pr46c902m4z4rjr530nxac";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoglide = (stdenv.mkDerivation ((if overrides ? xf86videoglide then overrides.xf86videoglide else x: x) {
    name = "xf86-video-glide-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glide-1.2.1.tar.bz2;
      sha256 = "0vp9izdy7lgx09jfwr4ra9zvrx1hg15a5v2nhx00v31ffkh2aiyp";
    };
    buildInputs = [pkgconfig xextproto xorgserver xproto ];
  })) // {inherit xextproto xorgserver xproto ;};

  xf86videoglint = (stdenv.mkDerivation ((if overrides ? xf86videoglint then overrides.xf86videoglint else x: x) {
    name = "xf86-video-glint-1.2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-glint-1.2.8.tar.bz2;
      sha256 = "08a2aark2yn9irws9c78d9q44dichr03i9zbk61jgr54ncxqhzv5";
    };
    buildInputs = [pkgconfig libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit libpciaccess videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videoi128 = (stdenv.mkDerivation ((if overrides ? xf86videoi128 then overrides.xf86videoi128 else x: x) {
    name = "xf86-video-i128-1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-i128-1.3.6.tar.bz2;
      sha256 = "171b8lbxr56w3isph947dnw7x87hc46v6m3mcxdcz44gk167x0pq";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videointel = (stdenv.mkDerivation ((if overrides ? xf86videointel then overrides.xf86videointel else x: x) {
    name = "xf86-video-intel-2.21.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.21.9.tar.bz2;
      sha256 = "12gigzpgbrz6g2gf4q5nj2sqmjw8fczbh79dlpx898llwk4wnn8k";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto xorgserver xproto libXrender libXvMC ];
  })) // {inherit dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto xorgserver xproto libXrender libXvMC ;};

  xf86videomach64 = (stdenv.mkDerivation ((if overrides ? xf86videomach64 then overrides.xf86videomach64 else x: x) {
    name = "xf86-video-mach64-6.9.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mach64-6.9.4.tar.bz2;
      sha256 = "0pl582vnc6hdxqhf5c0qdyanjqxb4crnhqlmxxml5a60syw0iwcp";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videomga = (stdenv.mkDerivation ((if overrides ? xf86videomga then overrides.xf86videomga else x: x) {
    name = "xf86-video-mga-1.6.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-mga-1.6.2.tar.bz2;
      sha256 = "0v6agqc9lxg8jgrksc1yksmhnv70j1vnhm09i7gg14za1qjwx29z";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videoneomagic = (stdenv.mkDerivation ((if overrides ? xf86videoneomagic then overrides.xf86videoneomagic else x: x) {
    name = "xf86-video-neomagic-1.2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-neomagic-1.2.8.tar.bz2;
      sha256 = "0x48sxs1p3kmwk3pq1j7vl93y59gdmgkq1x5xbnh0yal0angdash";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess xorgserver xproto ;};

  xf86videonewport = (stdenv.mkDerivation ((if overrides ? xf86videonewport then overrides.xf86videonewport else x: x) {
    name = "xf86-video-newport-0.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-newport-0.2.4.tar.bz2;
      sha256 = "1yafmp23jrfdmc094i6a4dsizapsc9v0pl65cpc8w1kvn7343k4i";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};

  xf86videonv = (stdenv.mkDerivation ((if overrides ? xf86videonv then overrides.xf86videonv else x: x) {
    name = "xf86-video-nv-2.1.20";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-nv-2.1.20.tar.bz2;
      sha256 = "1gqh1khc4zalip5hh2nksgs7i3piqq18nncgmsx9qvzi05azd5c3";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoopenchrome = (stdenv.mkDerivation ((if overrides ? xf86videoopenchrome then overrides.xf86videoopenchrome else x: x) {
    name = "xf86-video-openchrome-0.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-openchrome-0.3.3.tar.bz2;
      sha256 = "1v8j4i1r268n4fc5gq54zg1x50j0rhw71f3lba7411mcblg2z7p4";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ];
  })) // {inherit fontsproto glproto libdrm udev libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ;};

  xf86videor128 = (stdenv.mkDerivation ((if overrides ? xf86videor128 then overrides.xf86videor128 else x: x) {
    name = "xf86-video-r128-6.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-r128-6.9.1.tar.bz2;
      sha256 = "0k746kk75h3hg3wmihqlmp14s52fg0svylqay02km7misflbmqwb";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xorgserver xproto ;};

  xf86videosavage = (stdenv.mkDerivation ((if overrides ? xf86videosavage then overrides.xf86videosavage else x: x) {
    name = "xf86-video-savage-2.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-savage-2.3.6.tar.bz2;
      sha256 = "1mk3mpwl97clxhwzl990hj31z8qfh7fd4vs6qbl5i250ykc3x0a8";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videosiliconmotion = (stdenv.mkDerivation ((if overrides ? xf86videosiliconmotion then overrides.xf86videosiliconmotion else x: x) {
    name = "xf86-video-siliconmotion-1.7.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-siliconmotion-1.7.7.tar.bz2;
      sha256 = "1an321kqvsxq0z35acwl99lc8hpdkayw0q180744ypcl8ffvbf47";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess videoproto xextproto xorgserver xproto ;};

  xf86videosis = (stdenv.mkDerivation ((if overrides ? xf86videosis then overrides.xf86videosis else x: x) {
    name = "xf86-video-sis-0.10.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sis-0.10.7.tar.bz2;
      sha256 = "1l0w84x39gq4y9j81dny9r6rma1xkqvxpsavpkd8h7h8panbcbmy";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86videosuncg6 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg6 then overrides.xf86videosuncg6 else x: x) {
    name = "xf86-video-suncg6-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-suncg6-1.1.2.tar.bz2;
      sha256 = "04fgwgk02m4nimlv67rrg1wnyahgymrn6rb2cjj1l8bmzkii4glr";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosunffb = (stdenv.mkDerivation ((if overrides ? xf86videosunffb then overrides.xf86videosunffb else x: x) {
    name = "xf86-video-sunffb-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-sunffb-1.2.2.tar.bz2;
      sha256 = "07z3ngifwg2d4jgq8pms47n5lr2yn0ai72g86xxjnb3k20n5ym7s";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};

  xf86videotdfx = (stdenv.mkDerivation ((if overrides ? xf86videotdfx then overrides.xf86videotdfx else x: x) {
    name = "xf86-video-tdfx-1.4.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tdfx-1.4.5.tar.bz2;
      sha256 = "0nfqf1c8939s21ci1g7gacwzlr4g4nnilahgz7j2bz30zfnzpmbh";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videotga = (stdenv.mkDerivation ((if overrides ? xf86videotga then overrides.xf86videotga else x: x) {
    name = "xf86-video-tga-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-tga-1.2.2.tar.bz2;
      sha256 = "0cb161lvdgi6qnf1sfz722qn38q7kgakcvj7b45ba3i0020828r0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videotrident = (stdenv.mkDerivation ((if overrides ? xf86videotrident then overrides.xf86videotrident else x: x) {
    name = "xf86-video-trident-1.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-trident-1.3.6.tar.bz2;
      sha256 = "0141qbfsm32i0pxjyx5czpa8x8m4lvapsp4amw1qigaa0gry6n3a";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videov4l = (stdenv.mkDerivation ((if overrides ? xf86videov4l then overrides.xf86videov4l else x: x) {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  })) // {inherit randrproto videoproto xorgserver xproto ;};

  xf86videovesa = (stdenv.mkDerivation ((if overrides ? xf86videovesa then overrides.xf86videovesa else x: x) {
    name = "xf86-video-vesa-2.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vesa-2.3.3.tar.bz2;
      sha256 = "1y5fsg0c4bgmh1cfsbnaaf388fppyy02i7mcy9vax78flkjpb2yf";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videovmware = (stdenv.mkDerivation ((if overrides ? xf86videovmware then overrides.xf86videovmware else x: x) {
    name = "xf86-video-vmware-13.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vmware-13.0.1.tar.bz2;
      sha256 = "0ggyz3yl1ly0p9c9lva5z3892vm033z49py3svd2wh92bi0xlbc0";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ;};

  xf86videovoodoo = (stdenv.mkDerivation ((if overrides ? xf86videovoodoo then overrides.xf86videovoodoo else x: x) {
    name = "xf86-video-voodoo-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-voodoo-1.2.5.tar.bz2;
      sha256 = "1s6p7yxmi12q4y05va53rljwyzd6ry492r1pgi7wwq6cznivhgly";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videowsfb = (stdenv.mkDerivation ((if overrides ? xf86videowsfb then overrides.xf86videowsfb else x: x) {
    name = "xf86-video-wsfb-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86-video-wsfb-0.4.0.tar.bz2;
      sha256 = "0hr8397wpd0by1hc47fqqrnaw3qdqd8aqgwgzv38w5k3l3jy6p4p";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};

  xf86vidmodeproto = (stdenv.mkDerivation ((if overrides ? xf86vidmodeproto then overrides.xf86vidmodeproto else x: x) {
    name = "xf86vidmodeproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xf86vidmodeproto-2.3.1.tar.bz2;
      sha256 = "0w47d7gfa8zizh2bshdr2rffvbr4jqjv019mdgyh6cmplyd4kna5";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xfs = (stdenv.mkDerivation ((if overrides ? xfs then overrides.xfs else x: x) {
    name = "xfs-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.3.tar.bz2;
      sha256 = "1dwnf5gncpnjsbh9bdrc665kfnclhzzcpwpfnprvrnq4mlr4mx3v";
    };
    buildInputs = [pkgconfig libXfont xproto xtrans ];
  })) // {inherit libXfont xproto xtrans ;};

  xgamma = (stdenv.mkDerivation ((if overrides ? xgamma then overrides.xgamma else x: x) {
    name = "xgamma-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xgamma-1.0.5.tar.bz2;
      sha256 = "0463sawps86jnxn121ramsz4sicy3az5wa5wsq4rqm8dm3za48p3";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  })) // {inherit libX11 libXxf86vm ;};

  xhost = (stdenv.mkDerivation ((if overrides ? xhost then overrides.xhost else x: x) {
    name = "xhost-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xhost-1.0.5.tar.bz2;
      sha256 = "0l483y6wfrjh37j16b41kpi2nc7ss5rvndafpbaylrs87ygx2w18";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  })) // {inherit libX11 libXau libXmu ;};

  xineramaproto = (stdenv.mkDerivation ((if overrides ? xineramaproto then overrides.xineramaproto else x: x) {
    name = "xineramaproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xineramaproto-1.2.1.tar.bz2;
      sha256 = "0ns8abd27x7gbp4r44z3wc5k9zqxxj8zjnazqpcyr4n17nxp8xcp";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xinit = (stdenv.mkDerivation ((if overrides ? xinit then overrides.xinit else x: x) {
    name = "xinit-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinit-1.3.2.tar.bz2;
      sha256 = "0d821rlqwyn2js7bkzicyp894n9gqv1hahxs285pas1zm3d7z1m1";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xinput = (stdenv.mkDerivation ((if overrides ? xinput then overrides.xinput else x: x) {
    name = "xinput-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xinput-1.6.0.tar.bz2;
      sha256 = "0zl4cdgnzh9shz20yn7hz889v4nkbyqwx0nb7dh6arn7abchgc2a";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi libXinerama libXrandr ];
  })) // {inherit inputproto libX11 libXext libXi libXinerama libXrandr ;};

  xkbcomp = (stdenv.mkDerivation ((if overrides ? xkbcomp then overrides.xkbcomp else x: x) {
    name = "xkbcomp-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkbcomp-1.2.4.tar.bz2;
      sha256 = "0bas1d2wjiy5zy9d0g92d2p9pwv4aapfbfidi7hxy8ax8jmwkl4i";
    };
    buildInputs = [pkgconfig libX11 libxkbfile xproto ];
  })) // {inherit libX11 libxkbfile xproto ;};

  xkbevd = (stdenv.mkDerivation ((if overrides ? xkbevd then overrides.xkbevd else x: x) {
    name = "xkbevd-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkbevd-1.1.3.tar.bz2;
      sha256 = "05h1xcnbalndbrryyqs8wzy9h3wz655vc0ymhlk2q4aik17licjm";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};

  xkbutils = (stdenv.mkDerivation ((if overrides ? xkbutils then overrides.xkbutils else x: x) {
    name = "xkbutils-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkbutils-1.0.3.tar.bz2;
      sha256 = "1ga913pw6chssf2016kjyjl6ar2lj83pa497w97ak2kq603sy2g4";
    };
    buildInputs = [pkgconfig inputproto libX11 libXaw xproto libXt ];
  })) // {inherit inputproto libX11 libXaw xproto libXt ;};

  xkeyboardconfig = (stdenv.mkDerivation ((if overrides ? xkeyboardconfig then overrides.xkeyboardconfig else x: x) {
    name = "xkeyboard-config-2.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-2.8.tar.bz2;
      sha256 = "1bkq415qw4r3dl139mqgal9v585x7kh3km6z1lraz2j8im3ga72f";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  })) // {inherit libX11 xproto ;};

  xkill = (stdenv.mkDerivation ((if overrides ? xkill then overrides.xkill else x: x) {
    name = "xkill-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xkill-1.0.3.tar.bz2;
      sha256 = "1ac110qbb9a4x1dim3vaghvdk3jc708i2p3f4rmag33458khg0xx";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xlsatoms = (stdenv.mkDerivation ((if overrides ? xlsatoms then overrides.xlsatoms else x: x) {
    name = "xlsatoms-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xlsatoms-1.1.1.tar.bz2;
      sha256 = "1y9nfl8s7njxbnci8c20j986xixharasgg40vdw92y593j6dk2rv";
    };
    buildInputs = [pkgconfig libxcb ];
  })) // {inherit libxcb ;};

  xlsclients = (stdenv.mkDerivation ((if overrides ? xlsclients then overrides.xlsclients else x: x) {
    name = "xlsclients-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xlsclients-1.1.2.tar.bz2;
      sha256 = "1l97j15mg4wfzpm81wlpzagfjff7v4fwn7s2z2rpksk3gfcg7r8w";
    };
    buildInputs = [pkgconfig libxcb ];
  })) // {inherit libxcb ;};

  xmessage = (stdenv.mkDerivation ((if overrides ? xmessage then overrides.xmessage else x: x) {
    name = "xmessage-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.4.tar.bz2;
      sha256 = "0s5bjlpxnmh8sxx6nfg9m0nr32r1sr3irr71wsnv76s33i34ppxw";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  })) // {inherit libXaw libXt ;};

  xmodmap = (stdenv.mkDerivation ((if overrides ? xmodmap then overrides.xmodmap else x: x) {
    name = "xmodmap-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xmodmap-1.0.7.tar.bz2;
      sha256 = "1dg47lay4vhrl9mfq3cfc6741a0m2n8wd4ljagd21ix3qklys8pg";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  })) // {inherit libX11 xproto ;};

  xorgcffiles = (stdenv.mkDerivation ((if overrides ? xorgcffiles then overrides.xorgcffiles else x: x) {
    name = "xorg-cf-files-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.4.tar.bz2;
      sha256 = "0s86h66b3w4623m88fg2csp41cnr08qc8i3gkj85k3wpwj1wxs9n";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xorgdocs = (stdenv.mkDerivation ((if overrides ? xorgdocs then overrides.xorgdocs else x: x) {
    name = "xorg-docs-1.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xorg-docs-1.7.tar.bz2;
      sha256 = "0prphdba6kgr1bxk7r07wxxx6x6pqjw6prr5qclypsb5sf5r3cdr";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xorgserver = (stdenv.mkDerivation ((if overrides ? xorgserver then overrides.xorgserver else x: x) {
    name = "xorg-server-1.14.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.14.4.tar.bz2;
      sha256 = "1hsxyqgrw3hrgdl0sw8n4hbhjlindna0z8w4k1anwpw4zfmcz330";
    };
    buildInputs = [pkgconfig renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ];
  })) // {inherit renderproto libdrm openssl libX11 libXau libXaw libXdmcp libXfixes libxkbfile libXmu libXpm libXrender libXres libXt libXv ;};

  xorgsgmldoctools = (stdenv.mkDerivation ((if overrides ? xorgsgmldoctools then overrides.xorgsgmldoctools else x: x) {
    name = "xorg-sgml-doctools-1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xorg-sgml-doctools-1.11.tar.bz2;
      sha256 = "0k5pffyi5bx8dmfn033cyhgd3gf6viqj3x769fqixifwhbgy2777";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xpr = (stdenv.mkDerivation ((if overrides ? xpr then overrides.xpr else x: x) {
    name = "xpr-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xpr-1.0.4.tar.bz2;
      sha256 = "1dbcv26w2yand2qy7b3h5rbvw1mdmdd57jw88v53sgdr3vrqvngy";
    };
    buildInputs = [pkgconfig libX11 libXmu xproto ];
  })) // {inherit libX11 libXmu xproto ;};

  xprop = (stdenv.mkDerivation ((if overrides ? xprop then overrides.xprop else x: x) {
    name = "xprop-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xprop-1.2.1.tar.bz2;
      sha256 = "18zi2any13zlb7f34fzyw6lkiwkd6k2scp3b800a1f4rj0c7m407";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  })) // {inherit libX11 xproto ;};

  xproto = (stdenv.mkDerivation ((if overrides ? xproto then overrides.xproto else x: x) {
    name = "xproto-7.0.23";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xproto-7.0.23.tar.bz2;
      sha256 = "17lkmi12f89qvg4jj5spqzwzc24fmsqq68dv6kpy7r7b944lmq5d";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xrandr = (stdenv.mkDerivation ((if overrides ? xrandr then overrides.xrandr else x: x) {
    name = "xrandr-1.3.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xrandr-1.3.5.tar.bz2;
      sha256 = "03lq1c1q4w5cf2ijs4b34v008lshibha9zv5lw08xpyhk9xgyn8h";
    };
    buildInputs = [pkgconfig libX11 xproto libXrandr libXrender ];
  })) // {inherit libX11 xproto libXrandr libXrender ;};

  xrdb = (stdenv.mkDerivation ((if overrides ? xrdb then overrides.xrdb else x: x) {
    name = "xrdb-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xrdb-1.0.9.tar.bz2;
      sha256 = "1dza5a34nj68fzhlgwf18i5bk0n24ig28yihwpjy7vwn57hh2934";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xrefresh = (stdenv.mkDerivation ((if overrides ? xrefresh then overrides.xrefresh else x: x) {
    name = "xrefresh-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xrefresh-1.0.4.tar.bz2;
      sha256 = "0ywxzwa4kmnnmf8idr8ssgcil9xvbhnk155zpsh2i8ay93mh5586";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xset = (stdenv.mkDerivation ((if overrides ? xset then overrides.xset else x: x) {
    name = "xset-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xset-1.2.2.tar.bz2;
      sha256 = "1s61mvscd0h7y6anljarj7nkii6plhs8ndx1fm8b1f1h00a1qdv1";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu xproto libXxf86misc ];
  })) // {inherit libX11 libXext libXmu xproto libXxf86misc ;};

  xsetroot = (stdenv.mkDerivation ((if overrides ? xsetroot then overrides.xsetroot else x: x) {
    name = "xsetroot-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xsetroot-1.1.0.tar.bz2;
      sha256 = "1bazzsf9sy0q2bj4lxvh1kvyrhmpggzb7jg575i15sksksa3xwc8";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXcursor libXmu ];
  })) // {inherit libX11 xbitmaps libXcursor libXmu ;};

  xtrans = (stdenv.mkDerivation ((if overrides ? xtrans then overrides.xtrans else x: x) {
    name = "xtrans-1.2.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xtrans-1.2.7.tar.bz2;
      sha256 = "19p1bw3qyn0ia1znx6q3gx92rr9rl88ylrfijjclm8vhpa8i30bz";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xvinfo = (stdenv.mkDerivation ((if overrides ? xvinfo then overrides.xvinfo else x: x) {
    name = "xvinfo-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xvinfo-1.1.1.tar.bz2;
      sha256 = "119rd93d7661ll1rfcdssn78l0b97326smziyr2f5wdwj2hlmiv0";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  })) // {inherit libX11 libXv ;};

  xwd = (stdenv.mkDerivation ((if overrides ? xwd then overrides.xwd else x: x) {
    name = "xwd-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xwd-1.0.5.tar.bz2;
      sha256 = "0fkg6msy2zg7rda2rpxb7j6vmrdmqmk72xsxnyhz97196ykjnx82";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  })) // {inherit libX11 xproto ;};

  xwininfo = (stdenv.mkDerivation ((if overrides ? xwininfo then overrides.xwininfo else x: x) {
    name = "xwininfo-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xwininfo-1.1.2.tar.bz2;
      sha256 = "0fmcr5yl03xw7m8p9h1rk67rrj7gp5x16a547xhmg8idw2f6r9lg";
    };
    buildInputs = [pkgconfig libX11 libxcb xproto ];
  })) // {inherit libX11 libxcb xproto ;};

  xwud = (stdenv.mkDerivation ((if overrides ? xwud then overrides.xwud else x: x) {
    name = "xwud-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.7/src/everything/xwud-1.0.4.tar.bz2;
      sha256 = "1ggql6maivah58kwsh3z9x1hvzxm1a8888xx4s78cl77ryfa1cyn";
    };
    buildInputs = [pkgconfig libX11 xproto ];
  })) // {inherit libX11 xproto ;};

}; in xorg
