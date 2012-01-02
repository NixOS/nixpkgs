# THIS IS A GENERATED FILE.  DO NOT EDIT!
args: with args;

let

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

  applewmproto = (stdenv.mkDerivation ((if overrides ? applewmproto then overrides.applewmproto else x: x) {
    name = "applewmproto-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/applewmproto-1.4.1.tar.bz2;
      sha256 = "06fyixmx36qac2qqwmra3l9xr570rankm9kzmk0mgqyhgldrw1h8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  bdftopcf = (stdenv.mkDerivation ((if overrides ? bdftopcf then overrides.bdftopcf else x: x) {
    name = "bdftopcf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/bdftopcf-1.0.3.tar.bz2;
      sha256 = "02hx981f7jfwylxj21s91yvv4h597nqqzz3vd6ar81zyn84b944w";
    };
    buildInputs = [pkgconfig libXfont ];
  })) // {inherit libXfont ;};
    
  bigreqsproto = (stdenv.mkDerivation ((if overrides ? bigreqsproto then overrides.bigreqsproto else x: x) {
    name = "bigreqsproto-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/bigreqsproto-1.1.1.tar.bz2;
      sha256 = "16phzxa55lr749rghpaa699h1lcpndmw7izxzgl1bljq5f3qafqw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  compositeproto = (stdenv.mkDerivation ((if overrides ? compositeproto then overrides.compositeproto else x: x) {
    name = "compositeproto-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/compositeproto-0.4.2.tar.bz2;
      sha256 = "1z0crmf669hirw4s7972mmp8xig80kfndja9h559haqbpvq5k4q4";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  damageproto = (stdenv.mkDerivation ((if overrides ? damageproto then overrides.damageproto else x: x) {
    name = "damageproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/damageproto-1.2.1.tar.bz2;
      sha256 = "0nzwr5pv9hg7c21n995pdiv0zqhs91yz3r8rn3aska4ykcp12z2w";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  dmxproto = (stdenv.mkDerivation ((if overrides ? dmxproto then overrides.dmxproto else x: x) {
    name = "dmxproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dmxproto-2.3.1.tar.bz2;
      sha256 = "02b5x9dkgajizm8dqyx2w6hmqx3v25l67mgf35nj6sz0lgk52877";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  dri2proto = (stdenv.mkDerivation ((if overrides ? dri2proto then overrides.dri2proto else x: x) {
    name = "dri2proto-2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/dri2proto-2.3.tar.bz2;
      sha256 = "0xz6nf5rrn1fvply5mq7dd1w89r73mggylp9lpzzwdfvl291h55j";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  encodings = (stdenv.mkDerivation ((if overrides ? encodings then overrides.encodings else x: x) {
    name = "encodings-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/encodings-1.0.4.tar.bz2;
      sha256 = "0ffmaw80vmfwdgvdkp6495xgsqszb6s0iira5j0j6pd4i0lk3mnf";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fixesproto = (stdenv.mkDerivation ((if overrides ? fixesproto then overrides.fixesproto else x: x) {
    name = "fixesproto-4.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/fixesproto-4.1.2.tar.bz2;
      sha256 = "0mzq8kh1v1w2mrl4y82qzgv8jzlr3n4jmss56h3r1h9knp6byk6y";
    };
    buildInputs = [pkgconfig xextproto ];
  })) // {inherit xextproto ;};
    
  fontadobe100dpi = (stdenv.mkDerivation ((if overrides ? fontadobe100dpi then overrides.fontadobe100dpi else x: x) {
    name = "font-adobe-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-adobe-100dpi-1.0.3.tar.bz2;
      sha256 = "0m60f5bd0caambrk8ksknb5dks7wzsg7g7xaf0j21jxmx8rq9h5j";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobe75dpi = (stdenv.mkDerivation ((if overrides ? fontadobe75dpi then overrides.fontadobe75dpi else x: x) {
    name = "font-adobe-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-adobe-75dpi-1.0.3.tar.bz2;
      sha256 = "02advcv9lyxpvrjv8bjh1b797lzg6jvhipclz49z8r8y98g4l0n6";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopia100dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia100dpi then overrides.fontadobeutopia100dpi else x: x) {
    name = "font-adobe-utopia-100dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-adobe-utopia-100dpi-1.0.4.tar.bz2;
      sha256 = "19dd9znam1ah72jmdh7i6ny2ss2r6m21z9v0l43xvikw48zmwvyi";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopia75dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia75dpi then overrides.fontadobeutopia75dpi else x: x) {
    name = "font-adobe-utopia-75dpi-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-adobe-utopia-75dpi-1.0.4.tar.bz2;
      sha256 = "152wigpph5wvl4k9m3l4mchxxisgsnzlx033mn5iqrpkc6f72cl7";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopiatype1 = (stdenv.mkDerivation ((if overrides ? fontadobeutopiatype1 then overrides.fontadobeutopiatype1 else x: x) {
    name = "font-adobe-utopia-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-adobe-utopia-type1-1.0.4.tar.bz2;
      sha256 = "0xw0pdnzj5jljsbbhakc6q9ha2qnca1jr81zk7w70yl9bw83b54p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontalias = (stdenv.mkDerivation ((if overrides ? fontalias then overrides.fontalias else x: x) {
    name = "font-alias-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-alias-1.0.3.tar.bz2;
      sha256 = "16ic8wfwwr3jicaml7b5a0sk6plcgc1kg84w02881yhwmqm3nicb";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontarabicmisc = (stdenv.mkDerivation ((if overrides ? fontarabicmisc then overrides.fontarabicmisc else x: x) {
    name = "font-arabic-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-arabic-misc-1.0.3.tar.bz2;
      sha256 = "1x246dfnxnmflzf0qzy62k8jdpkb6jkgspcjgbk8jcq9lw99npah";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbh100dpi = (stdenv.mkDerivation ((if overrides ? fontbh100dpi then overrides.fontbh100dpi else x: x) {
    name = "font-bh-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-100dpi-1.0.3.tar.bz2;
      sha256 = "10cl4gm38dw68jzln99ijix730y7cbx8np096gmpjjwff1i73h13";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbh75dpi = (stdenv.mkDerivation ((if overrides ? fontbh75dpi then overrides.fontbh75dpi else x: x) {
    name = "font-bh-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-75dpi-1.0.3.tar.bz2;
      sha256 = "073jmhf0sr2j1l8da97pzsqj805f7mf9r2gy92j4diljmi8sm1il";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter100dpi then overrides.fontbhlucidatypewriter100dpi else x: x) {
    name = "font-bh-lucidatypewriter-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2;
      sha256 = "1fqzckxdzjv4802iad2fdrkpaxl4w0hhs9lxlkyraq2kq9ik7a32";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter75dpi then overrides.fontbhlucidatypewriter75dpi else x: x) {
    name = "font-bh-lucidatypewriter-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2;
      sha256 = "0cfbxdp5m12cm7jsh3my0lym9328cgm7fa9faz2hqj05wbxnmhaa";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhttf = (stdenv.mkDerivation ((if overrides ? fontbhttf then overrides.fontbhttf else x: x) {
    name = "font-bh-ttf-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-ttf-1.0.3.tar.bz2;
      sha256 = "0pyjmc0ha288d4i4j0si4dh3ncf3jiwwjljvddrb0k8v4xiyljqv";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontbhtype1 = (stdenv.mkDerivation ((if overrides ? fontbhtype1 then overrides.fontbhtype1 else x: x) {
    name = "font-bh-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bh-type1-1.0.3.tar.bz2;
      sha256 = "1hb3iav089albp4sdgnlh50k47cdjif9p4axm0kkjvs8jyi5a53n";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontbitstream100dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream100dpi then overrides.fontbitstream100dpi else x: x) {
    name = "font-bitstream-100dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bitstream-100dpi-1.0.3.tar.bz2;
      sha256 = "1kmn9jbck3vghz6rj3bhc3h0w6gh0qiaqm90cjkqsz1x9r2dgq7b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbitstream75dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream75dpi then overrides.fontbitstream75dpi else x: x) {
    name = "font-bitstream-75dpi-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bitstream-75dpi-1.0.3.tar.bz2;
      sha256 = "13plbifkvfvdfym6gjbgy9wx2xbdxi9hfrl1k22xayy02135wgxs";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbitstreamtype1 = (stdenv.mkDerivation ((if overrides ? fontbitstreamtype1 then overrides.fontbitstreamtype1 else x: x) {
    name = "font-bitstream-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-bitstream-type1-1.0.3.tar.bz2;
      sha256 = "1256z0jhcf5gbh1d03593qdwnag708rxqa032izmfb5dmmlhbsn6";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontcronyxcyrillic = (stdenv.mkDerivation ((if overrides ? fontcronyxcyrillic then overrides.fontcronyxcyrillic else x: x) {
    name = "font-cronyx-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-cronyx-cyrillic-1.0.3.tar.bz2;
      sha256 = "0ai1v4n61k8j9x2a1knvfbl2xjxk3xxmqaq3p9vpqrspc69k31kf";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontcursormisc = (stdenv.mkDerivation ((if overrides ? fontcursormisc then overrides.fontcursormisc else x: x) {
    name = "font-cursor-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-cursor-misc-1.0.3.tar.bz2;
      sha256 = "0dd6vfiagjc4zmvlskrbjz85jfqhf060cpys8j0y1qpcbsrkwdhp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontdaewoomisc = (stdenv.mkDerivation ((if overrides ? fontdaewoomisc then overrides.fontdaewoomisc else x: x) {
    name = "font-daewoo-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-daewoo-misc-1.0.3.tar.bz2;
      sha256 = "1s2bbhizzgbbbn5wqs3vw53n619cclxksljvm759h9p1prqdwrdw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontdecmisc = (stdenv.mkDerivation ((if overrides ? fontdecmisc then overrides.fontdecmisc else x: x) {
    name = "font-dec-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-dec-misc-1.0.3.tar.bz2;
      sha256 = "0yzza0l4zwyy7accr1s8ab7fjqkpwggqydbm2vc19scdby5xz7g1";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontibmtype1 = (stdenv.mkDerivation ((if overrides ? fontibmtype1 then overrides.fontibmtype1 else x: x) {
    name = "font-ibm-type1-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-ibm-type1-1.0.3.tar.bz2;
      sha256 = "1pyjll4adch3z5cg663s6vhi02k8m6488f0mrasg81ssvg9jinzx";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontisasmisc = (stdenv.mkDerivation ((if overrides ? fontisasmisc then overrides.fontisasmisc else x: x) {
    name = "font-isas-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-isas-misc-1.0.3.tar.bz2;
      sha256 = "0rx8q02rkx673a7skkpnvfkg28i8gmqzgf25s9yi0lar915sn92q";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontjismisc = (stdenv.mkDerivation ((if overrides ? fontjismisc then overrides.fontjismisc else x: x) {
    name = "font-jis-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-jis-misc-1.0.3.tar.bz2;
      sha256 = "0rdc3xdz12pnv951538q6wilx8mrdndpkphpbblszsv7nc8cw61b";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmicromisc = (stdenv.mkDerivation ((if overrides ? fontmicromisc then overrides.fontmicromisc else x: x) {
    name = "font-micro-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-micro-misc-1.0.3.tar.bz2;
      sha256 = "1dldxlh54zq1yzfnrh83j5vm0k4ijprrs5yl18gm3n9j1z0q2cws";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmisccyrillic = (stdenv.mkDerivation ((if overrides ? fontmisccyrillic then overrides.fontmisccyrillic else x: x) {
    name = "font-misc-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-misc-cyrillic-1.0.3.tar.bz2;
      sha256 = "0q2ybxs8wvylvw95j6x9i800rismsmx4b587alwbfqiw6biy63z4";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmiscethiopic = (stdenv.mkDerivation ((if overrides ? fontmiscethiopic then overrides.fontmiscethiopic else x: x) {
    name = "font-misc-ethiopic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-misc-ethiopic-1.0.3.tar.bz2;
      sha256 = "19cq7iq0pfad0nc2v28n681fdq3fcw1l1hzaq0wpkgpx7bc1zjsk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmeltho = (stdenv.mkDerivation ((if overrides ? fontmiscmeltho then overrides.fontmiscmeltho else x: x) {
    name = "font-misc-meltho-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-misc-meltho-1.0.3.tar.bz2;
      sha256 = "148793fqwzrc3bmh2vlw5fdiwjc2n7vs25cic35gfp452czk489p";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmisc = (stdenv.mkDerivation ((if overrides ? fontmiscmisc then overrides.fontmiscmisc else x: x) {
    name = "font-misc-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-misc-misc-1.1.2.tar.bz2;
      sha256 = "150pq6n8n984fah34n3k133kggn9v0c5k07igv29sxp1wi07krxq";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontmuttmisc = (stdenv.mkDerivation ((if overrides ? fontmuttmisc then overrides.fontmuttmisc else x: x) {
    name = "font-mutt-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-mutt-misc-1.0.3.tar.bz2;
      sha256 = "13qghgr1zzpv64m0p42195k1kc77pksiv059fdvijz1n6kdplpxx";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontschumachermisc = (stdenv.mkDerivation ((if overrides ? fontschumachermisc then overrides.fontschumachermisc else x: x) {
    name = "font-schumacher-misc-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-schumacher-misc-1.1.2.tar.bz2;
      sha256 = "0nkym3n48b4v36y4s927bbkjnsmicajarnf6vlp7wxp0as304i74";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontscreencyrillic = (stdenv.mkDerivation ((if overrides ? fontscreencyrillic then overrides.fontscreencyrillic else x: x) {
    name = "font-screen-cyrillic-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-screen-cyrillic-1.0.4.tar.bz2;
      sha256 = "0yayf1qlv7irf58nngddz2f1q04qkpr5jwp4aja2j5gyvzl32hl2";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontsonymisc = (stdenv.mkDerivation ((if overrides ? fontsonymisc then overrides.fontsonymisc else x: x) {
    name = "font-sony-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-sony-misc-1.0.3.tar.bz2;
      sha256 = "1xfgcx4gsgik5mkgkca31fj3w72jw9iw76qyrajrsz1lp8ka6hr0";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontsproto = (stdenv.mkDerivation ((if overrides ? fontsproto then overrides.fontsproto else x: x) {
    name = "fontsproto-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/fontsproto-2.1.1.tar.bz2;
      sha256 = "1g1rsvj0lb7744x6fj18d989ymf7zgry3v3fzipnnzljwa0vr6lw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontsunmisc = (stdenv.mkDerivation ((if overrides ? fontsunmisc then overrides.fontsunmisc else x: x) {
    name = "font-sun-misc-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-sun-misc-1.0.3.tar.bz2;
      sha256 = "1q6jcqrffg9q5f5raivzwx9ffvf7r11g6g0b125na1bhpz5ly7s8";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontutil = (stdenv.mkDerivation ((if overrides ? fontutil then overrides.fontutil else x: x) {
    name = "font-util-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-util-1.2.0.tar.bz2;
      sha256 = "04lp7xlrcqfyrsnvdgyqbanlnzr13lhn28v0kr2nzpvcmqbwdfnv";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontwinitzkicyrillic = (stdenv.mkDerivation ((if overrides ? fontwinitzkicyrillic then overrides.fontwinitzkicyrillic else x: x) {
    name = "font-winitzki-cyrillic-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-winitzki-cyrillic-1.0.3.tar.bz2;
      sha256 = "181n1bgq8vxfxqicmy1jpm1hnr6gwn1kdhl6hr4frjigs1ikpldb";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontxfree86type1 = (stdenv.mkDerivation ((if overrides ? fontxfree86type1 then overrides.fontxfree86type1 else x: x) {
    name = "font-xfree86-type1-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/font-xfree86-type1-1.0.4.tar.bz2;
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
    name = "glproto-1.4.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/glproto-1.4.12.tar.bz2;
      sha256 = "1pjpnj78hski4krvsbf55pkhhsrahvlb825dwl804q0b36fpmgj8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  iceauth = (stdenv.mkDerivation ((if overrides ? iceauth then overrides.iceauth else x: x) {
    name = "iceauth-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/iceauth-1.0.4.tar.bz2;
      sha256 = "13ck97rz53l490aba3xpgv4psgk4rywh1vi6slg1n4zhai2zvrhf";
    };
    buildInputs = [pkgconfig libICE xproto ];
  })) // {inherit libICE xproto ;};
    
  imake = (stdenv.mkDerivation ((if overrides ? imake then overrides.imake else x: x) {
    name = "imake-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.4.tar.bz2;
      sha256 = "1zj6y59yip40hrdvvljjmnsfqddzxpxmbmd8842010rhkvq7zcmc";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  inputproto = (stdenv.mkDerivation ((if overrides ? inputproto then overrides.inputproto else x: x) {
    name = "inputproto-2.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/inputproto-2.0.1.tar.bz2;
      sha256 = "0i2a28bnvv68i6z8qx09iw95c1wchqc2migx1s7764pqipc3srk3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  kbproto = (stdenv.mkDerivation ((if overrides ? kbproto then overrides.kbproto else x: x) {
    name = "kbproto-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/kbproto-1.0.5.tar.bz2;
      sha256 = "17glym611bbkca371ihpcnx9ydp4asay4psqq267j00pbr94zfhf";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  libAppleWM = (stdenv.mkDerivation ((if overrides ? libAppleWM then overrides.libAppleWM else x: x) {
    name = "libAppleWM-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libAppleWM-1.4.0.tar.bz2;
      sha256 = "10hw7rvwc2b0v3v6mc6vaq8xs6vim4bg43rnhspf4p26mlb2dsf8";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  })) // {inherit applewmproto libX11 libXext xextproto ;};
    
  libFS = (stdenv.mkDerivation ((if overrides ? libFS then overrides.libFS else x: x) {
    name = "libFS-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libFS-1.0.3.tar.bz2;
      sha256 = "0694iyc1rdz0fqnalgzpgzmxfaklrdk0jz769fsn1bv88mszjymb";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  })) // {inherit fontsproto xproto xtrans ;};
    
  libICE = (stdenv.mkDerivation ((if overrides ? libICE then overrides.libICE else x: x) {
    name = "libICE-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libICE-1.0.7.tar.bz2;
      sha256 = "00drapw7n793nqy23m76vxj5yzlgx7prmprkhzp3qiqs2lpnkcd8";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  })) // {inherit xproto xtrans ;};
    
  libSM = (stdenv.mkDerivation ((if overrides ? libSM then overrides.libSM else x: x) {
    name = "libSM-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libSM-1.2.0.tar.bz2;
      sha256 = "1jspgbd9g1d20kl18nnbzv37f1kpfybjff2xn08dmgv7f0dxzn0c";
    };
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
  })) // {inherit libICE libuuid xproto xtrans ;};
    
  libWindowsWM = (stdenv.mkDerivation ((if overrides ? libWindowsWM then overrides.libWindowsWM else x: x) {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libWindowsWM-1.0.1.tar.bz2;
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  })) // {inherit windowswmproto libX11 libXext xextproto ;};
    
  libX11 = (stdenv.mkDerivation ((if overrides ? libX11 then overrides.libX11 else x: x) {
    name = "libX11-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.4.1.tar.bz2;
      sha256 = "1qiwyqaf9vfn52nwp7nxlbixld3r9jyzsarnkwk0ynk4k3vy1x3h";
    };
    buildInputs = [pkgconfig inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ];
  })) // {inherit inputproto kbproto libxcb xextproto xf86bigfontproto xproto xtrans ;};
    
  libXScrnSaver = (stdenv.mkDerivation ((if overrides ? libXScrnSaver then overrides.libXScrnSaver else x: x) {
    name = "libXScrnSaver-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXScrnSaver-1.2.1.tar.bz2;
      sha256 = "16i59gac2sixgi692w4lvq5cp8hkl6rc375bh0ib51gsyvi6cfnf";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  })) // {inherit scrnsaverproto libX11 libXext xextproto ;};
    
  libXau = (stdenv.mkDerivation ((if overrides ? libXau then overrides.libXau else x: x) {
    name = "libXau-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXau-1.0.6.tar.bz2;
      sha256 = "1z3h07wj2kg2hnzj4gd9pc3rkj4n0mfw6f9skg9w1hfwzrgl317f";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  libXaw = (stdenv.mkDerivation ((if overrides ? libXaw then overrides.libXaw else x: x) {
    name = "libXaw-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXaw-1.0.9.tar.bz2;
      sha256 = "0dxh5ldcmzl6afq0a9172ryah1341g0zysm8vk2lmqkqdda7ffd8";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXmu libXpm xproto libXt ];
  })) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};
    
  libXcomposite = (stdenv.mkDerivation ((if overrides ? libXcomposite then overrides.libXcomposite else x: x) {
    name = "libXcomposite-0.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXcomposite-0.4.3.tar.bz2;
      sha256 = "1b8sniijb85v4my6v30ma9yqnwl4hkclci9l1hqxnipfyhl4sa9j";
    };
    buildInputs = [pkgconfig compositeproto libX11 libXfixes xproto ];
  })) // {inherit compositeproto libX11 libXfixes xproto ;};
    
  libXcursor = (stdenv.mkDerivation ((if overrides ? libXcursor then overrides.libXcursor else x: x) {
    name = "libXcursor-1.1.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXcursor-1.1.11.tar.bz2;
      sha256 = "1zpn5dx66l5ql9qv0yz41qlbap4imkkvi0p6j2a6zh72g52zfvm0";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
  })) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};
    
  libXdamage = (stdenv.mkDerivation ((if overrides ? libXdamage then overrides.libXdamage else x: x) {
    name = "libXdamage-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXdamage-1.1.3.tar.bz2;
      sha256 = "1a678bwap74sqczbr2z4y4fvbr35km3inkm8bi1igjyk4v46jqdw";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
  })) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};
    
  libXdmcp = (stdenv.mkDerivation ((if overrides ? libXdmcp then overrides.libXdmcp else x: x) {
    name = "libXdmcp-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXdmcp-1.1.0.tar.bz2;
      sha256 = "0wh0q4ih9p3nsxsjjj9a3d03nhiyjggpl7gbavdzsfia36iyk85q";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  libXext = (stdenv.mkDerivation ((if overrides ? libXext then overrides.libXext else x: x) {
    name = "libXext-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXext-1.2.0.tar.bz2;
      sha256 = "1xvgvrbg9lc812zi44hsyr461hiiwy05alckq847ki213qhkxvaa";
    };
    buildInputs = [pkgconfig libX11 xextproto xproto ];
  })) // {inherit libX11 xextproto xproto ;};
    
  libXfixes = (stdenv.mkDerivation ((if overrides ? libXfixes then overrides.libXfixes else x: x) {
    name = "libXfixes-4.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXfixes-4.0.5.tar.bz2;
      sha256 = "0x4drdxrslxf4vgcfyba0f0fbxg98c8x5dfrl7azakhf8qhd0v1f";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  })) // {inherit fixesproto libX11 xextproto xproto ;};
    
  libXfont = (stdenv.mkDerivation ((if overrides ? libXfont then overrides.libXfont else x: x) {
    name = "libXfont-1.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXfont-1.4.3.tar.bz2;
      sha256 = "1k79f8vcibd114ydndvna8axx39bsdaj351f16901lh155jlb4pp";
    };
    buildInputs = [pkgconfig libfontenc fontsproto freetype xproto xtrans zlib ];
  })) // {inherit libfontenc fontsproto freetype xproto xtrans zlib ;};
    
  libXft = (stdenv.mkDerivation ((if overrides ? libXft then overrides.libXft else x: x) {
    name = "libXft-2.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXft-2.2.0.tar.bz2;
      sha256 = "1cprbz7xnxkb7axblw8sdaw9ibkngmz60d0ypk1drhd0dpjmls68";
    };
    buildInputs = [pkgconfig fontconfig freetype xproto libXrender ];
  })) // {inherit fontconfig freetype xproto libXrender ;};
    
  libXi = (stdenv.mkDerivation ((if overrides ? libXi then overrides.libXi else x: x) {
    name = "libXi-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXi-1.4.1.tar.bz2;
      sha256 = "19i92if8anv5pg2mwyy93jcllk1mgxx5gchi8zkjlk7r604ir7sr";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  })) // {inherit inputproto libX11 libXext xextproto xproto ;};
    
  libXinerama = (stdenv.mkDerivation ((if overrides ? libXinerama then overrides.libXinerama else x: x) {
    name = "libXinerama-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXinerama-1.1.1.tar.bz2;
      sha256 = "17vpsscracg1hza0avrczm9fc7xx3229qhicy101mw6cx2hb9qmv";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  })) // {inherit libX11 libXext xextproto xineramaproto ;};
    
  libXmu = (stdenv.mkDerivation ((if overrides ? libXmu then overrides.libXmu else x: x) {
    name = "libXmu-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXmu-1.1.0.tar.bz2;
      sha256 = "1b9nkml1mk8yi76bv23cikbfrd7hlp48h710yqgcrpkh7cq1za8g";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXp = (stdenv.mkDerivation ((if overrides ? libXp then overrides.libXp else x: x) {
    name = "libXp-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.1.tar.bz2;
      sha256 = "1lj3cjg9ygbmclxvayy5v88kkndpy9jq6y68p13dc5jn01hg5lbi";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  })) // {inherit printproto libX11 libXau libXext xextproto ;};
    
  libXpm = (stdenv.mkDerivation ((if overrides ? libXpm then overrides.libXpm else x: x) {
    name = "libXpm-3.5.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXpm-3.5.9.tar.bz2;
      sha256 = "07k2zpiadck1p986pgksfm5zfdm6h5vjy6p0hv59h1dbkh103pca";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXrandr = (stdenv.mkDerivation ((if overrides ? libXrandr then overrides.libXrandr else x: x) {
    name = "libXrandr-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXrandr-1.3.1.tar.bz2;
      sha256 = "0qf6aywqk2mgd5hw0nr24xxp5k015aa11sax5yycn14wch4agfv2";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
  })) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};
    
  libXrender = (stdenv.mkDerivation ((if overrides ? libXrender then overrides.libXrender else x: x) {
    name = "libXrender-0.9.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXrender-0.9.6.tar.bz2;
      sha256 = "0s567qgys8m6782lbrpvpscm8fkk2jm2717g7s3hm7hhcgib2n3z";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
  })) // {inherit renderproto libX11 xproto ;};
    
  libXres = (stdenv.mkDerivation ((if overrides ? libXres then overrides.libXres else x: x) {
    name = "libXres-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXres-1.0.5.tar.bz2;
      sha256 = "0nd032jn3im6ar71xm1wgcmb4pa76c73nl8lavdkih609d30y2x0";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
  })) // {inherit resourceproto libX11 libXext xextproto xproto ;};
    
  libXt = (stdenv.mkDerivation ((if overrides ? libXt then overrides.libXt else x: x) {
    name = "libXt-1.0.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXt-1.0.9.tar.bz2;
      sha256 = "00bbms32fkzrxhdm9kybb2404ad6f3d6v4qgl83py7w09dcipfga";
    };
    buildInputs = [pkgconfig libICE kbproto libSM libX11 xproto ];
  })) // {inherit libICE kbproto libSM libX11 xproto ;};
    
  libXtst = (stdenv.mkDerivation ((if overrides ? libXtst then overrides.libXtst else x: x) {
    name = "libXtst-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXtst-1.2.0.tar.bz2;
      sha256 = "022lx3c57pkkw11j2k5s1f5idf53li5qg291766bvxi1nl90jbks";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto libXi ];
  })) // {inherit inputproto recordproto libX11 libXext xextproto libXi ;};
    
  libXv = (stdenv.mkDerivation ((if overrides ? libXv then overrides.libXv else x: x) {
    name = "libXv-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXv-1.0.6.tar.bz2;
      sha256 = "1vpmr9wnbz990ivarsp5rcmdg483fd2nk695plzlzx5h9dcqw3z2";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
  })) // {inherit videoproto libX11 libXext xextproto xproto ;};
    
  libXvMC = (stdenv.mkDerivation ((if overrides ? libXvMC then overrides.libXvMC else x: x) {
    name = "libXvMC-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXvMC-1.0.6.tar.bz2;
      sha256 = "14ik1kgpnds213dsa16i8cf5qg3hc7vccy9jz4a4ml8zqzlq1nix";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
  })) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};
    
  libXxf86dga = (stdenv.mkDerivation ((if overrides ? libXxf86dga then overrides.libXxf86dga else x: x) {
    name = "libXxf86dga-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXxf86dga-1.1.2.tar.bz2;
      sha256 = "01jsc0jg7mjngfbh3j942595pwbyxf2m9kljy3zb6gyfcbsm59hv";
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
    name = "libXxf86vm-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libXxf86vm-1.1.1.tar.bz2;
      sha256 = "17i342h7a2nqfz4lpk8cay0vc0h4i7nxdc6xli9r7mggk8iykji1";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};
    
  libdmx = (stdenv.mkDerivation ((if overrides ? libdmx then overrides.libdmx else x: x) {
    name = "libdmx-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libdmx-1.1.1.tar.bz2;
      sha256 = "066yndshwq2nzkd0z0w96wq37rnhb23s6vq50bg4kiqb8y3nxpm6";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  })) // {inherit dmxproto libX11 libXext xextproto ;};
    
  libfontenc = (stdenv.mkDerivation ((if overrides ? libfontenc then overrides.libfontenc else x: x) {
    name = "libfontenc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libfontenc-1.1.0.tar.bz2;
      sha256 = "1gww1cbi17q15lh2ws6qzspp807issbyk5wlzjmgw6pn880ip2il";
    };
    buildInputs = [pkgconfig xproto zlib ];
  })) // {inherit xproto zlib ;};
    
  libpciaccess = (stdenv.mkDerivation ((if overrides ? libpciaccess then overrides.libpciaccess else x: x) {
    name = "libpciaccess-0.12.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.12.1.tar.bz2;
      sha256 = "0i3kdmvl1mcjrkhklpli45sqsy4pvipm6swifbcyxx4cwkqdfiyc";
    };
    buildInputs = [pkgconfig zlib ];
  })) // {inherit zlib ;};
    
  libpthreadstubs = (stdenv.mkDerivation ((if overrides ? libpthreadstubs then overrides.libpthreadstubs else x: x) {
    name = "libpthread-stubs-0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libpthread-stubs-0.3.tar.bz2;
      sha256 = "16bjv3in19l84hbri41iayvvg4ls9gv1ma0x0qlbmwy67i7dbdim";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  libxcb = (stdenv.mkDerivation ((if overrides ? libxcb then overrides.libxcb else x: x) {
    name = "libxcb-1.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libxcb-1.7.tar.bz2;
      sha256 = "1pr40wa3i1f0iwx83c8alcycy9sfzd2y1qlc63kr8q56w8sxqxp7";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
  })) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};
    
  libxkbfile = (stdenv.mkDerivation ((if overrides ? libxkbfile then overrides.libxkbfile else x: x) {
    name = "libxkbfile-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/libxkbfile-1.0.7.tar.bz2;
      sha256 = "1r9a1xnn57431hfp1am2r5h23pa1zh646482li3vd5ivfc53fzk6";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  })) // {inherit kbproto libX11 ;};
    
  lndir = (stdenv.mkDerivation ((if overrides ? lndir then overrides.lndir else x: x) {
    name = "lndir-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.2.tar.bz2;
      sha256 = "1d988z0ywy2k53s7i43ff0j5qac1cpy9j0gjwmiprq66w8rh24z5";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  luit = (stdenv.mkDerivation ((if overrides ? luit then overrides.luit else x: x) {
    name = "luit-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/luit-1.1.0.tar.bz2;
      sha256 = "1l83b5yknh4svqzwsppvmm2q9l0mvsfwm16ik7q3yss8m5zgvypi";
    };
    buildInputs = [pkgconfig libfontenc zlib ];
  })) // {inherit libfontenc zlib ;};
    
  makedepend = (stdenv.mkDerivation ((if overrides ? makedepend then overrides.makedepend else x: x) {
    name = "makedepend-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/makedepend-1.0.3.tar.bz2;
      sha256 = "0dxpz376bvphjg8q0nqrcf4y0dbni0c6jj5y16qymr37wlq1s99s";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  mkfontdir = (stdenv.mkDerivation ((if overrides ? mkfontdir then overrides.mkfontdir else x: x) {
    name = "mkfontdir-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/mkfontdir-1.0.6.tar.bz2;
      sha256 = "0nf8p0zsndd9qmrw70h2wdq7sz6j066q73lpp262dlpq21inrmam";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  mkfontscale = (stdenv.mkDerivation ((if overrides ? mkfontscale then overrides.mkfontscale else x: x) {
    name = "mkfontscale-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/mkfontscale-1.0.8.tar.bz2;
      sha256 = "1yah41gr5hlihbjm5l1kykdqj1p5rx6y4vrqraxbzvkrrn37gdbf";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  })) // {inherit libfontenc freetype xproto zlib ;};
    
  pixman = (stdenv.mkDerivation ((if overrides ? pixman then overrides.pixman else x: x) {
    name = "pixman-0.20.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/pixman-0.20.2.tar.bz2;
      sha256 = "1agl6f63y2wiqr6n9slzhisnilcg8byafp2l8wmw713bk8k6yc9h";
    };
    buildInputs = [pkgconfig perl ];
  })) // {inherit perl ;};
    
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
    name = "randrproto-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/randrproto-1.3.2.tar.bz2;
      sha256 = "0wfwcq85wbm0g5r0snc7prgki1wi3kxrxhcxinyr54n45ihh03fr";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  recordproto = (stdenv.mkDerivation ((if overrides ? recordproto then overrides.recordproto else x: x) {
    name = "recordproto-1.14.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/recordproto-1.14.1.tar.bz2;
      sha256 = "1389fc3r8h8xqix11y9ngw7a13i1mvw68jkhicgvq676sd1v0zmj";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  renderproto = (stdenv.mkDerivation ((if overrides ? renderproto then overrides.renderproto else x: x) {
    name = "renderproto-0.11.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/renderproto-0.11.1.tar.bz2;
      sha256 = "0dr5xw6s0qmqg0q5pdkb4jkdhaja0vbfqla79qh5j1xjj9dmlwq6";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  resourceproto = (stdenv.mkDerivation ((if overrides ? resourceproto then overrides.resourceproto else x: x) {
    name = "resourceproto-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/resourceproto-1.1.1.tar.bz2;
      sha256 = "1imqlkvn4mfjsflwvqx8dj0n7i7frdpzkdafq001r25ak6782yc5";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  scrnsaverproto = (stdenv.mkDerivation ((if overrides ? scrnsaverproto then overrides.scrnsaverproto else x: x) {
    name = "scrnsaverproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/scrnsaverproto-1.2.1.tar.bz2;
      sha256 = "1w94c1an7cy9v68289xbqszaj6g5qx5a29qx67fwsvqkmhygglps";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  sessreg = (stdenv.mkDerivation ((if overrides ? sessreg then overrides.sessreg else x: x) {
    name = "sessreg-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/sessreg-1.0.6.tar.bz2;
      sha256 = "143ivrs2pbkid4wr1hri9221z4gi9dlkq7x60jarcz9bhiq1dwvk";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  setxkbmap = (stdenv.mkDerivation ((if overrides ? setxkbmap then overrides.setxkbmap else x: x) {
    name = "setxkbmap-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/setxkbmap-1.2.0.tar.bz2;
      sha256 = "0fdfvc0fqdp11ly5iywrsi4w7rln4dq02b0b91yjmjm83fzr35cr";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  smproxy = (stdenv.mkDerivation ((if overrides ? smproxy then overrides.smproxy else x: x) {
    name = "smproxy-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/smproxy-1.0.4.tar.bz2;
      sha256 = "0wj4z4ars9j4k5pysl42jpx4zclrz3ifwgqxrcdlmb3l5xvyb4ip";
    };
    buildInputs = [pkgconfig libSM libXmu libXt ];
  })) // {inherit libSM libXmu libXt ;};
    
  twm = (stdenv.mkDerivation ((if overrides ? twm then overrides.twm else x: x) {
    name = "twm-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/twm-1.0.6.tar.bz2;
      sha256 = "1scly9kv3kx8zh8bfljsdd32dsb4j05xzn8c5x270xcshzbwmp77";
    };
    buildInputs = [pkgconfig libICE libSM libX11 libXext libXmu libXt ];
  })) // {inherit libICE libSM libX11 libXext libXmu libXt ;};
    
  utilmacros = (stdenv.mkDerivation ((if overrides ? utilmacros then overrides.utilmacros else x: x) {
    name = "util-macros-1.11.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/util-macros-1.11.0.tar.bz2;
      sha256 = "1kya7z5rad93zmc0ij7jhl3shh1k37szmjg1rv75lizqlib4slz8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  videoproto = (stdenv.mkDerivation ((if overrides ? videoproto then overrides.videoproto else x: x) {
    name = "videoproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/videoproto-2.3.1.tar.bz2;
      sha256 = "0nk3i6gwkqq1w8zwn7bxz344pi1dwcjrmf6hr330h7hxjcj6viry";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  windowswmproto = (stdenv.mkDerivation ((if overrides ? windowswmproto then overrides.windowswmproto else x: x) {
    name = "windowswmproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/windowswmproto-1.0.4.tar.bz2;
      sha256 = "0syjxgy4m8l94qrm03nvn5k6bkxc8knnlld1gbllym97nvnv0ny0";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  x11perf = (stdenv.mkDerivation ((if overrides ? x11perf then overrides.x11perf else x: x) {
    name = "x11perf-1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/x11perf-1.5.3.tar.bz2;
      sha256 = "1g91ksfrvj59hvxvfj1xb730aqscg5wdnc3grrab1wz7mxap6k9r";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  })) // {inherit libX11 libXext libXft libXmu libXrender ;};
    
  xauth = (stdenv.mkDerivation ((if overrides ? xauth then overrides.xauth else x: x) {
    name = "xauth-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xauth-1.0.5.tar.bz2;
      sha256 = "0v3lmm3qil8shgm7731pl0wd32kpq7w73w5d4mjq1bqxzw09a4vd";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  })) // {inherit libX11 libXau libXext libXmu ;};
    
  xbacklight = (stdenv.mkDerivation ((if overrides ? xbacklight then overrides.xbacklight else x: x) {
    name = "xbacklight-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xbacklight-1.1.2.tar.bz2;
      sha256 = "02b5jfys2msla2yvg5s0knzyxg2104r25czkwd49i8g8kp804bxg";
    };
    buildInputs = [pkgconfig libX11 libXrandr ];
  })) // {inherit libX11 libXrandr ;};
    
  xbitmaps = (stdenv.mkDerivation ((if overrides ? xbitmaps then overrides.xbitmaps else x: x) {
    name = "xbitmaps-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xbitmaps-1.1.1.tar.bz2;
      sha256 = "178ym90kwidia6nas4qr5n5yqh698vv8r02js0r4vg3b6lsb0w9n";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xcbproto = (stdenv.mkDerivation ((if overrides ? xcbproto then overrides.xcbproto else x: x) {
    name = "xcb-proto-1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xcb-proto-1.6.tar.bz2;
      sha256 = "18jwkgd2ayvd0zzwawnbh86b4xqjq29mgsq44h06yj8jkcaw2azm";
    };
    buildInputs = [pkgconfig python ];
  })) // {inherit python ;};
    
  xcbutil = (stdenv.mkDerivation ((if overrides ? xcbutil then overrides.xcbutil else x: x) {
    name = "xcb-util-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-0.3.8.tar.bz2;
      sha256 = "1fa7njhg7dsqbrkwrzbkfszdp1dmggvlsrb05qshkg2h8wldkvn1";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};
    
  xcbutilimage = (stdenv.mkDerivation ((if overrides ? xcbutilimage then overrides.xcbutilimage else x: x) {
    name = "xcb-util-image-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-image-0.3.8.tar.bz2;
      sha256 = "1nd67105lb8qfa7r2lli5sxnipi1p1wnbwa04l9k30kfq8l0afa0";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xcbutil xproto ];
  })) // {inherit gperf m4 libxcb xcbutil xproto ;};
    
  xcbutilkeysyms = (stdenv.mkDerivation ((if overrides ? xcbutilkeysyms then overrides.xcbutilkeysyms else x: x) {
    name = "xcb-util-keysyms-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-keysyms-0.3.8.tar.bz2;
      sha256 = "08b1d19gaqv3agpkvh5mgcir11vjy89ywdknva0cb073mzvk4gci";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};
    
  xcbutilrenderutil = (stdenv.mkDerivation ((if overrides ? xcbutilrenderutil then overrides.xcbutilrenderutil else x: x) {
    name = "xcb-util-renderutil-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-renderutil-0.3.8.tar.bz2;
      sha256 = "0lkl9ij9b447c0br2qc5qsynjn09c4fdz7sd6yp7pyi8az2sb2cp";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};
    
  xcbutilwm = (stdenv.mkDerivation ((if overrides ? xcbutilwm then overrides.xcbutilwm else x: x) {
    name = "xcb-util-wm-0.3.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xcb/xcb-util-wm-0.3.8.tar.bz2;
      sha256 = "01shwv13rfcxycrsla6c5xlrk1qska7kvvj10n7jcibx9jzanmy5";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};
    
  xclock = (stdenv.mkDerivation ((if overrides ? xclock then overrides.xclock else x: x) {
    name = "xclock-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.5.tar.bz2;
      sha256 = "16jcmsmhz503mqv7wz7daqqhm11phsws0g7fryzlz0gk4jg1daak";
    };
    buildInputs = [pkgconfig libX11 libXaw libXft libxkbfile libXmu libXrender libXt ];
  })) // {inherit libX11 libXaw libXft libxkbfile libXmu libXrender libXt ;};
    
  xcmiscproto = (stdenv.mkDerivation ((if overrides ? xcmiscproto then overrides.xcmiscproto else x: x) {
    name = "xcmiscproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xcmiscproto-1.2.1.tar.bz2;
      sha256 = "05acy1axzkrq6z9xlbmz1kg66lbgfqzky8v4qfdl16gv5gi2f3kk";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xcmsdb = (stdenv.mkDerivation ((if overrides ? xcmsdb then overrides.xcmsdb else x: x) {
    name = "xcmsdb-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xcmsdb-1.0.3.tar.bz2;
      sha256 = "102s9lsghdp5n3bsg4chlkhrk0jh0kxvg2g0pyi1zmzfy5hd0dxj";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xcursorgen = (stdenv.mkDerivation ((if overrides ? xcursorgen then overrides.xcursorgen else x: x) {
    name = "xcursorgen-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xcursorgen-1.0.4.tar.bz2;
      sha256 = "07azdw6w18hdgrd6z3nawrhn1m18nyp24cz54ih91vpz8hpxnany";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  })) // {inherit libpng libX11 libXcursor ;};
    
  xcursorthemes = (stdenv.mkDerivation ((if overrides ? xcursorthemes then overrides.xcursorthemes else x: x) {
    name = "xcursor-themes-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xcursor-themes-1.0.3.tar.bz2;
      sha256 = "1is4bak0qkkhv63mfa5l7492r475586y52yzfxyv3psppn662ilr";
    };
    buildInputs = [pkgconfig libXcursor ];
  })) // {inherit libXcursor ;};
    
  xdm = (stdenv.mkDerivation ((if overrides ? xdm then overrides.xdm else x: x) {
    name = "xdm-1.1.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xdm-1.1.10.tar.bz2;
      sha256 = "0zzrlkmppy6mma49db2x1il47rhjqkg9rs91ryl7xyv5iqbgg1ql";
    };
    buildInputs = [pkgconfig libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
  })) // {inherit libX11 libXau libXaw libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};
    
  xdpyinfo = (stdenv.mkDerivation ((if overrides ? xdpyinfo then overrides.xdpyinfo else x: x) {
    name = "xdpyinfo-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xdpyinfo-1.2.0.tar.bz2;
      sha256 = "1kmmfawcjxgmp06jb3w7d0pxbrcxrrgfx3m1lbwj3gygir4ssnzy";
    };
    buildInputs = [pkgconfig libdmx libX11 libXcomposite libXext libXi libXinerama libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  })) // {inherit libdmx libX11 libXcomposite libXext libXi libXinerama libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};
    
  xdriinfo = (stdenv.mkDerivation ((if overrides ? xdriinfo then overrides.xdriinfo else x: x) {
    name = "xdriinfo-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xdriinfo-1.0.4.tar.bz2;
      sha256 = "076bjix941znyjmh3j5jjsnhp2gv2iq53d0ks29mvvv87cyy9iim";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  })) // {inherit glproto libX11 ;};
    
  xev = (stdenv.mkDerivation ((if overrides ? xev then overrides.xev else x: x) {
    name = "xev-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xev-1.1.0.tar.bz2;
      sha256 = "1ih1rxf2b6bpsggvbx4ibyx70bzgcyjl98l1894d0smjxmlc4n9q";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xextproto = (stdenv.mkDerivation ((if overrides ? xextproto then overrides.xextproto else x: x) {
    name = "xextproto-7.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xextproto-7.1.2.tar.bz2;
      sha256 = "16ci2mc9g85fsb7lgml349rbgf97v7l9688by71agv682bhjky7n";
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
      url = mirror://xorg/X11R7.6/src/everything/xf86bigfontproto-1.2.0.tar.bz2;
      sha256 = "0j0n7sj5xfjpmmgx6n5x556rw21hdd18fwmavp95wps7qki214ms";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86dgaproto = (stdenv.mkDerivation ((if overrides ? xf86dgaproto then overrides.xf86dgaproto else x: x) {
    name = "xf86dgaproto-2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86dgaproto-2.1.tar.bz2;
      sha256 = "0l4hx48207mx0hp09026r6gy9nl3asbq0c75hri19wp1118zcpmc";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86driproto = (stdenv.mkDerivation ((if overrides ? xf86driproto then overrides.xf86driproto else x: x) {
    name = "xf86driproto-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xf86driproto-2.1.1.tar.bz2;
      sha256 = "07v69m0g2dfzb653jni4x656jlr7l84c1k39j8qc8vfb45r8sjww";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86inputacecad = (stdenv.mkDerivation ((if overrides ? xf86inputacecad then overrides.xf86inputacecad else x: x) {
    name = "xf86-input-acecad-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-acecad-1.4.0.tar.bz2;
      sha256 = "0mnmvffxwgcvsa208vffsqlai7lldjc46rdk6j0j4q00df5isd28";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputaiptek = (stdenv.mkDerivation ((if overrides ? xf86inputaiptek then overrides.xf86inputaiptek else x: x) {
    name = "xf86-input-aiptek-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-aiptek-1.3.1.tar.bz2;
      sha256 = "16pby473s65lfd2v60fwayzfhf1n6x696lrx720zwb2p22rlsna3";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputevdev = (stdenv.mkDerivation ((if overrides ? xf86inputevdev then overrides.xf86inputevdev else x: x) {
    name = "xf86-input-evdev-2.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.6.0.tar.bz2;
      sha256 = "1b2kcxm7bc255ym56dpl1fw3km44f5ny3hwn65sa90w13acz7rxh";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};
    
  xf86inputjoystick = (stdenv.mkDerivation ((if overrides ? xf86inputjoystick then overrides.xf86inputjoystick else x: x) {
    name = "xf86-input-joystick-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-joystick-1.5.0.tar.bz2;
      sha256 = "1ac2lap4npylyzg0pi0zy0n48wvicgz9kw0z9ih9ylk9sz2ii0bi";
    };
    buildInputs = [pkgconfig inputproto kbproto xorgserver xproto ];
  })) // {inherit inputproto kbproto xorgserver xproto ;};
    
  xf86inputkeyboard = (stdenv.mkDerivation ((if overrides ? xf86inputkeyboard then overrides.xf86inputkeyboard else x: x) {
    name = "xf86-input-keyboard-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-keyboard-1.5.0.tar.bz2;
      sha256 = "1c4ww4yj23shqwhc52r512qsy5baf1sxsb7jj7pfnralj07520r3";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};
    
  xf86inputmouse = (stdenv.mkDerivation ((if overrides ? xf86inputmouse then overrides.xf86inputmouse else x: x) {
    name = "xf86-input-mouse-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-mouse-1.6.0.tar.bz2;
      sha256 = "1nzvlbhvdyki3h1s4x2i3ps1immf3wfns6az2i3669v8a5g29bn7";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};
    
  xf86inputsynaptics = (stdenv.mkDerivation ((if overrides ? xf86inputsynaptics then overrides.xf86inputsynaptics else x: x) {
    name = "xf86-input-synaptics-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-synaptics-1.3.0.tar.bz2;
      sha256 = "1mwgb85qjyzx2yfi7jhgvd435zdyqxyq9aqwlsldmlpkqi8358rh";
    };
    buildInputs = [pkgconfig inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ];
  })) // {inherit inputproto randrproto recordproto libX11 libXi xorgserver xproto libXtst ;};
    
  xf86inputvmmouse = (stdenv.mkDerivation ((if overrides ? xf86inputvmmouse then overrides.xf86inputvmmouse else x: x) {
    name = "xf86-input-vmmouse-12.6.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-vmmouse-12.6.10.tar.bz2;
      sha256 = "0409lkwk1ws8vw4axxilwmcs8qxj8lq5dma2i2iz49q6hrd9sdm6";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvoid = (stdenv.mkDerivation ((if overrides ? xf86inputvoid then overrides.xf86inputvoid else x: x) {
    name = "xf86-input-void-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-input-void-1.3.1.tar.bz2;
      sha256 = "0x662i756p0nqmfv76ppm28ir2sbvcm32r71ycd9bxc3mj29g9mb";
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
    
  xf86videoapm = (stdenv.mkDerivation ((if overrides ? xf86videoapm then overrides.xf86videoapm else x: x) {
    name = "xf86-video-apm-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-apm-1.2.3.tar.bz2;
      sha256 = "1nih9ayiw13aa1s8j6gr99b207215if055c6yvsrssnpvccflij0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoark = (stdenv.mkDerivation ((if overrides ? xf86videoark then overrides.xf86videoark else x: x) {
    name = "xf86-video-ark-0.7.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-ark-0.7.3.tar.bz2;
      sha256 = "164gyaaddjjma0xqys0knid2rsd0c7jlab02c8wh3bk4bib9l51r";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoast = (stdenv.mkDerivation ((if overrides ? xf86videoast then overrides.xf86videoast else x: x) {
    name = "xf86-video-ast-0.91.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-ast-0.91.10.tar.bz2;
      sha256 = "05fcp0svdd4skkfgag1rrram6v3xzgasf582dihpyrwlz28186vy";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoati = (stdenv.mkDerivation ((if overrides ? xf86videoati then overrides.xf86videoati else x: x) {
    name = "xf86-video-ati-6.14.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-6.14.2.tar.bz2;
      sha256 = "1p18lfw7ii8k1vam75wv9a2piwf6n2988dh56i4b98zf4av78y81";
    };
    buildInputs = [pkgconfig fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm udev libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videochips = (stdenv.mkDerivation ((if overrides ? xf86videochips then overrides.xf86videochips else x: x) {
    name = "xf86-video-chips-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-chips-1.2.3.tar.bz2;
      sha256 = "07fb03cxdlis2rjphz2pl59cjhldrhqric8p0gi4wkgq0s72fq85";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocirrus = (stdenv.mkDerivation ((if overrides ? xf86videocirrus then overrides.xf86videocirrus else x: x) {
    name = "xf86-video-cirrus-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-cirrus-1.3.2.tar.bz2;
      sha256 = "06na525xy5d6xf5g13bjsk9cyxly5arzgrk9j8dmxfll5jj9i6jj";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videodummy = (stdenv.mkDerivation ((if overrides ? xf86videodummy then overrides.xf86videodummy else x: x) {
    name = "xf86-video-dummy-0.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-dummy-0.3.4.tar.bz2;
      sha256 = "1p0vhxvx25d8fp59i72664smhd0z5zw0i2kipk0879xk1vsxz13y";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};
    
  xf86videofbdev = (stdenv.mkDerivation ((if overrides ? xf86videofbdev then overrides.xf86videofbdev else x: x) {
    name = "xf86-video-fbdev-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-fbdev-0.4.2.tar.bz2;
      sha256 = "1mc23w0bfmak5216411xh58nrs93jlxmi6l412hmqzhxnjs73clk";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videogeode = (stdenv.mkDerivation ((if overrides ? xf86videogeode then overrides.xf86videogeode else x: x) {
    name = "xf86-video-geode-2.11.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-geode-2.11.10.tar.bz2;
      sha256 = "1zdb3y5df1dcqlvijg8hxcd6520a5c69jk52yz7ww194ka2c8icf";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoglide = (stdenv.mkDerivation ((if overrides ? xf86videoglide then overrides.xf86videoglide else x: x) {
    name = "xf86-video-glide-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-glide-1.1.0.tar.bz2;
      sha256 = "1wf35ai8z3qqk2a97rp72jzvm28ylw2wj2hllrsn29p7jpznh5aw";
    };
    buildInputs = [pkgconfig xextproto xorgserver xproto ];
  })) // {inherit xextproto xorgserver xproto ;};
    
  xf86videoglint = (stdenv.mkDerivation ((if overrides ? xf86videoglint then overrides.xf86videoglint else x: x) {
    name = "xf86-video-glint-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-glint-1.2.5.tar.bz2;
      sha256 = "0jw1kkyja8hvvhrr3ldl1r5vpqfhn1xmqkpgd2jrkc5p59rz4xan";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};
    
  xf86videoi128 = (stdenv.mkDerivation ((if overrides ? xf86videoi128 then overrides.xf86videoi128 else x: x) {
    name = "xf86-video-i128-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-i128-1.3.4.tar.bz2;
      sha256 = "1kwb4ifxwm77s1ks19csmq2ymgs36bxqwvwv24ssvxb9znki76xn";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi740 = (stdenv.mkDerivation ((if overrides ? xf86videoi740 then overrides.xf86videoi740 else x: x) {
    name = "xf86-video-i740-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-i740-1.3.2.tar.bz2;
      sha256 = "0hzr5fz6d5jk9jxh9plfgvgias3w7xzyg1n4gx0hs2lc7mm9qm28";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videointel = (stdenv.mkDerivation ((if overrides ? xf86videointel then overrides.xf86videointel else x: x) {
    name = "xf86-video-intel-2.14.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.14.0.tar.bz2;
      sha256 = "1pq7nm6whc2nmrizf774q042580cfms6yp6yd5p52q59g6jkg371";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ];
  })) // {inherit dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ;};
    
  xf86videointel_2_14_901 = (stdenv.mkDerivation ((if overrides ? xf86videointel_2_14_901 then overrides.xf86videointel_2_14_901 else x: x) {
    name = "xf86-video-intel-2.14.901";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.14.901.tar.bz2;
      sha256 = "1hm3zn96ahmirvx1iv87sk7fl7g8a6h1j7560gyw7y5b3l1zmg5r";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ];
  })) // {inherit dri2proto fontsproto libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ;};
    
  xf86videointel_2_17_0 = (stdenv.mkDerivation ((if overrides ? xf86videointel_2_17_0 then overrides.xf86videointel_2_17_0 else x: x) {
    name = "xf86-video-intel-2.17.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.17.0.tar.bz2;
      sha256 = "11s3vjp0lrfmb4bv848fd5bajj77j3rf451lm0qyylnclbr5114b";
    };
    buildInputs = [pkgconfig dri2proto fontsproto libdrm udev libpciaccess pixman randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXrender libXvMC ];
  })) // {inherit dri2proto fontsproto libdrm udev libpciaccess pixman randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXrender libXvMC ;};
    
  xf86videomach64 = (stdenv.mkDerivation ((if overrides ? xf86videomach64 then overrides.xf86videomach64 else x: x) {
    name = "xf86-video-mach64-6.8.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-mach64-6.8.2.tar.bz2;
      sha256 = "07b7dkb6xc10pvf483dg52r2klpikmw339i5ln9ig913601r84dr";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videomga = (stdenv.mkDerivation ((if overrides ? xf86videomga then overrides.xf86videomga else x: x) {
    name = "xf86-video-mga-1.4.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-mga-1.4.13.tar.bz2;
      sha256 = "1xnzxmp9cfpi6q7fx2r74iwyb33wkdrqcf38dhwydbaaxigvsmxn";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videoneomagic = (stdenv.mkDerivation ((if overrides ? xf86videoneomagic then overrides.xf86videoneomagic else x: x) {
    name = "xf86-video-neomagic-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-neomagic-1.2.5.tar.bz2;
      sha256 = "0jshn5k1byq0msl1ymip3m2xycrd8jkk6nzm5dx2av5xlj1rxdn0";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonewport = (stdenv.mkDerivation ((if overrides ? xf86videonewport then overrides.xf86videonewport else x: x) {
    name = "xf86-video-newport-0.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-newport-0.2.3.tar.bz2;
      sha256 = "0w02rz49gipnfl33vak3zgis8bh9i0v5ykyj8qh9vzddjm7ypjp6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videonv = (stdenv.mkDerivation ((if overrides ? xf86videonv then overrides.xf86videonv else x: x) {
    name = "xf86-video-nv-2.1.18";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-nv-2.1.18.tar.bz2;
      sha256 = "05glbi9jc7j9nm4sf4qvl3z87s48ibm3i283lqz85kbphg62dxvc";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoopenchrome = (stdenv.mkDerivation ((if overrides ? xf86videoopenchrome then overrides.xf86videoopenchrome else x: x) {
    name = "xf86-video-openchrome-0.2.904";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-openchrome-0.2.904.tar.bz2;
      sha256 = "1sksddn0pc3izvab5ppxhprs1xzk5ijwqz5ylivx1cb5hg2gggf7";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videor128 = (stdenv.mkDerivation ((if overrides ? xf86videor128 then overrides.xf86videor128 else x: x) {
    name = "xf86-video-r128-6.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-r128-6.8.1.tar.bz2;
      sha256 = "1jlybabm3k09hhlzx1xilndqngk3xgdck66n94sr02w5hg622zji";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videorendition = (stdenv.mkDerivation ((if overrides ? xf86videorendition then overrides.xf86videorendition else x: x) {
    name = "xf86-video-rendition-4.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-rendition-4.2.4.tar.bz2;
      sha256 = "1a9anxgqs7wc8d7jb5nw6dgmynw0sxiwp9p90h4w19y315kqx6rv";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videos3 = (stdenv.mkDerivation ((if overrides ? xf86videos3 then overrides.xf86videos3 else x: x) {
    name = "xf86-video-s3-0.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-s3-0.6.3.tar.bz2;
      sha256 = "0i2i1080cw3pxy1pm43bskb80n7wql0cxpyd2s61v0didsm6b7zd";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videos3virge = (stdenv.mkDerivation ((if overrides ? xf86videos3virge then overrides.xf86videos3virge else x: x) {
    name = "xf86-video-s3virge-1.10.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-s3virge-1.10.4.tar.bz2;
      sha256 = "1f3zjs6a3j2a8lfdilijggpwbg9cs88qksrvzvd71ggxf5p0vl0w";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosavage = (stdenv.mkDerivation ((if overrides ? xf86videosavage then overrides.xf86videosavage else x: x) {
    name = "xf86-video-savage-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-savage-2.3.1.tar.bz2;
      sha256 = "1ays1l4phyjcdikc9d1zwgswivcrb1grkh7klv5klvqahbfxqjib";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosiliconmotion = (stdenv.mkDerivation ((if overrides ? xf86videosiliconmotion then overrides.xf86videosiliconmotion else x: x) {
    name = "xf86-video-siliconmotion-1.7.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-siliconmotion-1.7.4.tar.bz2;
      sha256 = "1mq4dsg2f77wxl0n4fnm6a5p3lajyhra6rxx29z52p5b1x412xdl";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosis = (stdenv.mkDerivation ((if overrides ? xf86videosis then overrides.xf86videosis else x: x) {
    name = "xf86-video-sis-0.10.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-sis-0.10.3.tar.bz2;
      sha256 = "0dy7a7iil35nz1xlazrcq0sp474p6wy0f1pa5y0spbfj5zib6fcv";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ;};
    
  xf86videosisusb = (stdenv.mkDerivation ((if overrides ? xf86videosisusb then overrides.xf86videosisusb else x: x) {
    name = "xf86-video-sisusb-0.9.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-sisusb-0.9.4.tar.bz2;
      sha256 = "0b5afc1dqj8h34fldl35hzf7wphj1x76czkd461bfarnvyljgfrb";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ;};
    
  xf86videosuncg14 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg14 then overrides.xf86videosuncg14 else x: x) {
    name = "xf86-video-suncg14-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-suncg14-1.1.1.tar.bz2;
      sha256 = "1n108xbwg803v2sk51galx66ph8wdb0ym84fx45h0jrr41wh0hyb";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg3 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg3 then overrides.xf86videosuncg3 else x: x) {
    name = "xf86-video-suncg3-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-suncg3-1.1.1.tar.bz2;
      sha256 = "06c4hzmd5cfzbw79yrv3knss80hllciamz734ij1pbzj6j6fjvym";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg6 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg6 then overrides.xf86videosuncg6 else x: x) {
    name = "xf86-video-suncg6-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-suncg6-1.1.1.tar.bz2;
      sha256 = "07w0hm63fiy5l3cpcjsl0ig8z84z9r36xm0cmnpiv3g75dy6q8fi";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosunffb = (stdenv.mkDerivation ((if overrides ? xf86videosunffb then overrides.xf86videosunffb else x: x) {
    name = "xf86-video-sunffb-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-sunffb-1.2.1.tar.bz2;
      sha256 = "04byax4sc1fn183vyyq0q11q730k16h2by4ggjky7s36wgv7ldzx";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videosunleo = (stdenv.mkDerivation ((if overrides ? xf86videosunleo then overrides.xf86videosunleo else x: x) {
    name = "xf86-video-sunleo-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-sunleo-1.2.0.tar.bz2;
      sha256 = "01kffjbshmwix2cdb95j0cx2qmrss6yfjj7y5qssw83h36bvw5dk";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuntcx = (stdenv.mkDerivation ((if overrides ? xf86videosuntcx then overrides.xf86videosuntcx else x: x) {
    name = "xf86-video-suntcx-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-suntcx-1.1.1.tar.bz2;
      sha256 = "07lqah5sizhwjpzr4vcpwgvbl86fwz4k0c3skp63sq58ng21acal";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videotdfx = (stdenv.mkDerivation ((if overrides ? xf86videotdfx then overrides.xf86videotdfx else x: x) {
    name = "xf86-video-tdfx-1.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-tdfx-1.4.3.tar.bz2;
      sha256 = "0cxz1rsc87cnf0ba1zfwhk0lhfas92ysc9b13q6x21m31b53bn9s";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videotga = (stdenv.mkDerivation ((if overrides ? xf86videotga then overrides.xf86videotga else x: x) {
    name = "xf86-video-tga-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-tga-1.2.1.tar.bz2;
      sha256 = "0mdqrn02zzkdnmhg4vh9djaawg6b2p82g5qbj66z8b30yr77b93h";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotrident = (stdenv.mkDerivation ((if overrides ? xf86videotrident then overrides.xf86videotrident else x: x) {
    name = "xf86-video-trident-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-trident-1.3.4.tar.bz2;
      sha256 = "1a4wybqwd617mg8lzn1xvi5m0iibimxpvyqsr31mhb7gw0qidrjq";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotseng = (stdenv.mkDerivation ((if overrides ? xf86videotseng then overrides.xf86videotseng else x: x) {
    name = "xf86-video-tseng-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-tseng-1.2.4.tar.bz2;
      sha256 = "0gfiwx2p51k3k78qic8y9y0d3d6nhhbmzfvzmw5hx3ba9kxmvpfh";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videov4l = (stdenv.mkDerivation ((if overrides ? xf86videov4l then overrides.xf86videov4l else x: x) {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  })) // {inherit randrproto videoproto xorgserver xproto ;};
    
  xf86videovesa = (stdenv.mkDerivation ((if overrides ? xf86videovesa then overrides.xf86videovesa else x: x) {
    name = "xf86-video-vesa-2.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-vesa-2.3.0.tar.bz2;
      sha256 = "0yhdj39d8rfv2n4i52dg7cg1rsrclagn7rjs3pc3jdajjh75mn4f";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovmware = (stdenv.mkDerivation ((if overrides ? xf86videovmware then overrides.xf86videovmware else x: x) {
    name = "xf86-video-vmware-11.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-vmware-11.0.3.tar.bz2;
      sha256 = "18rqkzr1dvzgdr2khlhhpai69z28rnrfl8jiw9hnahbyv2r7qjmj";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xineramaproto xorgserver xproto ;};
    
  xf86videovoodoo = (stdenv.mkDerivation ((if overrides ? xf86videovoodoo then overrides.xf86videovoodoo else x: x) {
    name = "xf86-video-voodoo-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-voodoo-1.2.4.tar.bz2;
      sha256 = "0ha748yz92yzn6hp2rhin3il8f4j2rs4vkgdvqkagnv1ryxkh0ph";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videowsfb = (stdenv.mkDerivation ((if overrides ? xf86videowsfb then overrides.xf86videowsfb else x: x) {
    name = "xf86-video-wsfb-0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-wsfb-0.3.0.tar.bz2;
      sha256 = "17lqhir0adcccfkrzz2sr8cpv5vkakk0w7xfc22vv7c6jz9vdgbq";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};
    
  xf86videoxgi = (stdenv.mkDerivation ((if overrides ? xf86videoxgi then overrides.xf86videoxgi else x: x) {
    name = "xf86-video-xgi-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-xgi-1.6.0.tar.bz2;
      sha256 = "05wl9a51pik5swkzpyhh4y2gf6m3hd458r4142p5w39bbkmhcd78";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};
    
  xf86videoxgixp = (stdenv.mkDerivation ((if overrides ? xf86videoxgixp then overrides.xf86videoxgixp else x: x) {
    name = "xf86-video-xgixp-1.8.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xf86-video-xgixp-1.8.0.tar.bz2;
      sha256 = "06np5s3f3451vmjwpxbn8hb7d4dhsxff2af8qy8jlc24rinnv9is";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86vidmodeproto = (stdenv.mkDerivation ((if overrides ? xf86vidmodeproto then overrides.xf86vidmodeproto else x: x) {
    name = "xf86vidmodeproto-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xf86vidmodeproto-2.3.1.tar.bz2;
      sha256 = "0w47d7gfa8zizh2bshdr2rffvbr4jqjv019mdgyh6cmplyd4kna5";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xfs = (stdenv.mkDerivation ((if overrides ? xfs then overrides.xfs else x: x) {
    name = "xfs-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.1.tar.bz2;
      sha256 = "1yxm87az3xghngcsd50zz6mdgi9j6vm8pw90sjqzshwq7hx7d0qc";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  })) // {inherit libFS libXfont xtrans ;};
    
  xgamma = (stdenv.mkDerivation ((if overrides ? xgamma then overrides.xgamma else x: x) {
    name = "xgamma-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xgamma-1.0.4.tar.bz2;
      sha256 = "05lfx9517why64b3n14drid7vn1d2g2ymg22034vqq50h9437j3x";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  })) // {inherit libX11 libXxf86vm ;};
    
  xhost = (stdenv.mkDerivation ((if overrides ? xhost then overrides.xhost else x: x) {
    name = "xhost-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xhost-1.0.4.tar.bz2;
      sha256 = "15558q9hgmw6vbwc2sgjkfpzw342lxci9w8vcbrmi8mpmrnc00jy";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  })) // {inherit libX11 libXau libXmu ;};
    
  xineramaproto = (stdenv.mkDerivation ((if overrides ? xineramaproto then overrides.xineramaproto else x: x) {
    name = "xineramaproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xineramaproto-1.2.1.tar.bz2;
      sha256 = "0ns8abd27x7gbp4r44z3wc5k9zqxxj8zjnazqpcyr4n17nxp8xcp";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xinit = (stdenv.mkDerivation ((if overrides ? xinit then overrides.xinit else x: x) {
    name = "xinit-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinit-1.3.0.tar.bz2;
      sha256 = "0k70bw6x2zgvmd0l7xyzbps18pbzfz26yzjva1vcz9s239pf6xms";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xinput = (stdenv.mkDerivation ((if overrides ? xinput then overrides.xinput else x: x) {
    name = "xinput-1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xinput-1.5.3.tar.bz2;
      sha256 = "0xjwi1sjmvmmzgcvzvz4q8wn0gs7x3aivknx77yfxnndrqqy3bba";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi ];
  })) // {inherit inputproto libX11 libXext libXi ;};
    
  xkbcomp = (stdenv.mkDerivation ((if overrides ? xkbcomp then overrides.xkbcomp else x: x) {
    name = "xkbcomp-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xkbcomp-1.2.1.tar.bz2;
      sha256 = "1sv51rliqs6wygrp2hc79a5pgn6ly0bbr4sa8a8x00j4j4kjaqdp";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  xkbevd = (stdenv.mkDerivation ((if overrides ? xkbevd then overrides.xkbevd else x: x) {
    name = "xkbevd-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xkbevd-1.1.2.tar.bz2;
      sha256 = "0qzbh1wb2fg0wsyfqr4j15443caa1xfcxwdf1gzb4gpbkxn98qnd";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  xkbutils = (stdenv.mkDerivation ((if overrides ? xkbutils then overrides.xkbutils else x: x) {
    name = "xkbutils-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xkbutils-1.0.3.tar.bz2;
      sha256 = "1ga913pw6chssf2016kjyjl6ar2lj83pa497w97ak2kq603sy2g4";
    };
    buildInputs = [pkgconfig inputproto libX11 libXaw xproto libXt ];
  })) // {inherit inputproto libX11 libXaw xproto libXt ;};
    
  xkill = (stdenv.mkDerivation ((if overrides ? xkill then overrides.xkill else x: x) {
    name = "xkill-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xkill-1.0.3.tar.bz2;
      sha256 = "1ac110qbb9a4x1dim3vaghvdk3jc708i2p3f4rmag33458khg0xx";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xlsatoms = (stdenv.mkDerivation ((if overrides ? xlsatoms then overrides.xlsatoms else x: x) {
    name = "xlsatoms-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xlsatoms-1.1.0.tar.bz2;
      sha256 = "03fbknvq7rixfgpv5945s7r82jz2xc06a0n09w1p22hl4pd7l0aa";
    };
    buildInputs = [pkgconfig libxcb ];
  })) // {inherit libxcb ;};
    
  xlsclients = (stdenv.mkDerivation ((if overrides ? xlsclients then overrides.xlsclients else x: x) {
    name = "xlsclients-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsclients-1.1.2.tar.bz2;
      sha256 = "1l97j15mg4wfzpm81wlpzagfjff7v4fwn7s2z2rpksk3gfcg7r8w";
    };
    buildInputs = [pkgconfig libxcb ];
  })) // {inherit libxcb ;};
    
  xmessage = (stdenv.mkDerivation ((if overrides ? xmessage then overrides.xmessage else x: x) {
    name = "xmessage-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.3.tar.bz2;
      sha256 = "0nrxidff0pcd1ampfzj91ai74j6mx613j5kqk3j0c4xdshx5v8yg";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  })) // {inherit libXaw libXt ;};
    
  xmodmap = (stdenv.mkDerivation ((if overrides ? xmodmap then overrides.xmodmap else x: x) {
    name = "xmodmap-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xmodmap-1.0.5.tar.bz2;
      sha256 = "00il5y6q2m90f62cqzgc0ni5qg3y946gf98jj325kx8cgfhyf7j2";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
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
    name = "xorg-docs-1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xorg-docs-1.6.tar.bz2;
      sha256 = "0clxy41642jx77mmw5j2fnwa88ms1a7z1z8xpzrgs45bhv21pcpn";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xorgserver = (stdenv.mkDerivation ((if overrides ? xorgserver then overrides.xorgserver else x: x) {
    name = "xorg-server-1.9.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.9.5.tar.bz2;
      sha256 = "1p19w1s840jb1ah6na0c9k23gbh9wwz1il272irqy3jggh4pbirz";
    };
    buildInputs = [pkgconfig bigreqsproto damageproto fixesproto fontsproto inputproto kbproto libdrm openssl libpciaccess perl randrproto renderproto libX11 libXau libXaw xcmiscproto libXdmcp xextproto libXfixes libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXv ];
  })) // {inherit bigreqsproto damageproto fixesproto fontsproto inputproto kbproto libdrm openssl libpciaccess perl randrproto renderproto libX11 libXau libXaw xcmiscproto libXdmcp xextproto libXfixes libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXv ;};
    
  xorgsgmldoctools = (stdenv.mkDerivation ((if overrides ? xorgsgmldoctools then overrides.xorgsgmldoctools else x: x) {
    name = "xorg-sgml-doctools-1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xorg-sgml-doctools-1.6.tar.bz2;
      sha256 = "0smfsman09dqqw6h638w44lgp2kng2jwk53sb74i7r53x1v09llq";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xpr = (stdenv.mkDerivation ((if overrides ? xpr then overrides.xpr else x: x) {
    name = "xpr-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xpr-1.0.3.tar.bz2;
      sha256 = "0zckkd45lzbikmdn29r12faby8g5prjkacc1z8aw87pq9sqdcy18";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xprop = (stdenv.mkDerivation ((if overrides ? xprop then overrides.xprop else x: x) {
    name = "xprop-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xprop-1.2.0.tar.bz2;
      sha256 = "173bpq7x2amr77xy28f9m4nfdwr340wj3jw9hkbbznq35c48ql2k";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xproto = (stdenv.mkDerivation ((if overrides ? xproto then overrides.xproto else x: x) {
    name = "xproto-7.0.20";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xproto-7.0.20.tar.bz2;
      sha256 = "0alyxrd8wmdvdqm1v3q4x5brv4prj0gxf59pp9h5wycvgpj7zs1z";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xrandr = (stdenv.mkDerivation ((if overrides ? xrandr then overrides.xrandr else x: x) {
    name = "xrandr-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xrandr-1.3.4.tar.bz2;
      sha256 = "1nsadgvn57b9way7v0s4yk2729rwqj1m5fbilmd38lfcws928jjy";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  })) // {inherit libX11 libXrandr libXrender ;};
    
  xrdb = (stdenv.mkDerivation ((if overrides ? xrdb then overrides.xrdb else x: x) {
    name = "xrdb-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrdb-1.0.8.tar.bz2;
      sha256 = "1r2k50qnflj40iandhxhvnrvnhy4qliz5kymlh682455gjmlgn7z";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xrefresh = (stdenv.mkDerivation ((if overrides ? xrefresh then overrides.xrefresh else x: x) {
    name = "xrefresh-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xrefresh-1.0.4.tar.bz2;
      sha256 = "0ywxzwa4kmnnmf8idr8ssgcil9xvbhnk155zpsh2i8ay93mh5586";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xset = (stdenv.mkDerivation ((if overrides ? xset then overrides.xset else x: x) {
    name = "xset-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xset-1.2.1.tar.bz2;
      sha256 = "18cja8b9xrilpshz0z8bkmpjm6pjb20w71xf41jgm70h4dymz6gc";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXxf86misc ];
  })) // {inherit libX11 libXext libXmu libXxf86misc ;};
    
  xsetroot = (stdenv.mkDerivation ((if overrides ? xsetroot then overrides.xsetroot else x: x) {
    name = "xsetroot-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xsetroot-1.1.0.tar.bz2;
      sha256 = "1bazzsf9sy0q2bj4lxvh1kvyrhmpggzb7jg575i15sksksa3xwc8";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXcursor libXmu ];
  })) // {inherit libX11 xbitmaps libXcursor libXmu ;};
    
  xtrans = (stdenv.mkDerivation ((if overrides ? xtrans then overrides.xtrans else x: x) {
    name = "xtrans-1.2.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xtrans-1.2.6.tar.bz2;
      sha256 = "1im5kj6y8j8m9i5lf1c33dkag6sb7g1zmi0niydqrfyx0lvsgyf5";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xvinfo = (stdenv.mkDerivation ((if overrides ? xvinfo then overrides.xvinfo else x: x) {
    name = "xvinfo-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xvinfo-1.1.1.tar.bz2;
      sha256 = "119rd93d7661ll1rfcdssn78l0b97326smziyr2f5wdwj2hlmiv0";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  })) // {inherit libX11 libXv ;};
    
  xwd = (stdenv.mkDerivation ((if overrides ? xwd then overrides.xwd else x: x) {
    name = "xwd-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xwd-1.0.4.tar.bz2;
      sha256 = "07mh72j794hwq5rnqkmdd4wj27mqmdc3da4jkwpva2hsj64wi9mp";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xwininfo = (stdenv.mkDerivation ((if overrides ? xwininfo then overrides.xwininfo else x: x) {
    name = "xwininfo-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xwininfo-1.1.1.tar.bz2;
      sha256 = "0g9ll8hv0k5cjz4l5kdv64xzmalf9mpwjzcy8nx6myvh92z5fnk4";
    };
    buildInputs = [pkgconfig libX11 libxcb xproto ];
  })) // {inherit libX11 libxcb xproto ;};
    
  xwud = (stdenv.mkDerivation ((if overrides ? xwud then overrides.xwud else x: x) {
    name = "xwud-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.6/src/everything/xwud-1.0.3.tar.bz2;
      sha256 = "0hrc6gbipg7cximgkaxixlha9m2fph31dpzhzdfw7g63bkhfmzc8";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
}; in xorg
