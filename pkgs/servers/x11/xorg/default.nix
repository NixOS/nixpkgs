# THIS IS A GENERATED FILE.  DO NOT EDIT!
args: with args;

let

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

  applewmproto = (stdenv.mkDerivation ((if overrides ? applewmproto then overrides.applewmproto else x: x) {
    name = "applewmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/applewmproto-1.0.3.tar.bz2;
      sha256 = "0l2d3wmgprs5gl479ba2yw9vj1q3m8rhri82k0vryd9ildzc0f59";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  appres = (stdenv.mkDerivation ((if overrides ? appres then overrides.appres else x: x) {
    name = "appres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/appres-1.0.1.tar.bz2;
      sha256 = "0qmr5sdbj4alzf3p8lxb8348y7zdmsjdp20c8biwx39b40xgizhm";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  })) // {inherit libX11 libXt ;};

  bdftopcf = (stdenv.mkDerivation ((if overrides ? bdftopcf then overrides.bdftopcf else x: x) {
    name = "bdftopcf-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/bdftopcf-1.0.1.tar.bz2;
      sha256 = "1lq5x0kvgwlzdgfhi8sbbchzd1y1nmzdqgq9laysx08p6smlbama";
    };
    buildInputs = [pkgconfig libXfont ];
  })) // {inherit libXfont ;};

  bigreqsproto = (stdenv.mkDerivation ((if overrides ? bigreqsproto then overrides.bigreqsproto else x: x) {
    name = "bigreqsproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/bigreqsproto-1.0.2.tar.bz2;
      sha256 = "1vmda2412s5yvawx2xplrbzcghnmqin54r1l352ycy25lac01nih";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  bitmap = (stdenv.mkDerivation ((if overrides ? bitmap then overrides.bitmap else x: x) {
    name = "bitmap-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/bitmap-1.0.3.tar.bz2;
      sha256 = "0hawhldsa0647a5x2hy5frf6k2wcpwq1n8pf6npgj6dg30snfgw6";
    };
    buildInputs = [pkgconfig libXaw libX11 xbitmaps libXmu libXt ];
  })) // {inherit libXaw libX11 xbitmaps libXmu libXt ;};

  compositeproto = (stdenv.mkDerivation ((if overrides ? compositeproto then overrides.compositeproto else x: x) {
    name = "compositeproto-0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/compositeproto-0.4.tar.bz2;
      sha256 = "00q0wc8skfjy7c9dzngvmi99i29bh68715wrdw7m9dxjcg5d24v0";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  damageproto = (stdenv.mkDerivation ((if overrides ? damageproto then overrides.damageproto else x: x) {
    name = "damageproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/damageproto-1.1.0.tar.bz2;
      sha256 = "07b41ninycfm5sgzpjsa168dnm1g55c2mzzgigvwvs9mr3x889lx";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  dmxproto = (stdenv.mkDerivation ((if overrides ? dmxproto then overrides.dmxproto else x: x) {
    name = "dmxproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/dmxproto-2.2.2.tar.bz2;
      sha256 = "1qpw6lp4925zwmkp48b6wsy84d21872i6x2dr8rzfn7csp4xk9ma";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  dri2proto = (stdenv.mkDerivation ((if overrides ? dri2proto then overrides.dri2proto else x: x) {
    name = "dri2proto-2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri2proto-2.0.tar.bz2;
      sha256 = "1r59dpxinlssq0iangbdxng0cjp88g8nx0w3qh8hdrvzdplsfm0r";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  encodings = (stdenv.mkDerivation ((if overrides ? encodings then overrides.encodings else x: x) {
    name = "encodings-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/encodings-1.0.2.tar.bz2;
      sha256 = "1b2fdxfvqb0gbg4pz8anp9rwnbg2xj3d4b8cbc46rjdvcrxi06bd";
    };
    buildInputs = [pkgconfig mkfontscale ];
  })) // {inherit mkfontscale ;};

  evieext = (stdenv.mkDerivation ((if overrides ? evieext then overrides.evieext else x: x) {
    name = "evieext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/evieext-1.0.2.tar.bz2;
      sha256 = "09fijha8ac0iw7lbc75912jwhm5k19ypm73zj8akf23hjwx1318b";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fixesproto = (stdenv.mkDerivation ((if overrides ? fixesproto then overrides.fixesproto else x: x) {
    name = "fixesproto-4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/fixesproto-4.0.tar.bz2;
      sha256 = "13xhrva17vcg1zdz6kba5g5jzkf43z1ifwfsg1ndnll1rhf9gzmk";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontadobe100dpi = (stdenv.mkDerivation ((if overrides ? fontadobe100dpi then overrides.fontadobe100dpi else x: x) {
    name = "font-adobe-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-adobe-100dpi-1.0.0.tar.bz2;
      sha256 = "06cs5q4hy255i5b64q0cgcapv46kgc315b7jmwjs5j952qx1nv7i";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobe75dpi = (stdenv.mkDerivation ((if overrides ? fontadobe75dpi then overrides.fontadobe75dpi else x: x) {
    name = "font-adobe-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-adobe-75dpi-1.0.0.tar.bz2;
      sha256 = "0fb32yyqf4mf93bn9a0qbzm9zbl3sxkhc0ipy9az7r7mw2z4a9yn";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia100dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia100dpi then overrides.fontadobeutopia100dpi else x: x) {
    name = "font-adobe-utopia-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-adobe-utopia-100dpi-1.0.1.tar.bz2;
      sha256 = "1zmmm430rwgv0cr80ybl6bk9qzr697lwh253qwxv2sf1f2mf2hqr";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopia75dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia75dpi then overrides.fontadobeutopia75dpi else x: x) {
    name = "font-adobe-utopia-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-adobe-utopia-75dpi-1.0.1.tar.bz2;
      sha256 = "12bhr82dsd9iz50kszppghf22fpyjcadrxd0plxpwwmw9ccy5m7b";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontadobeutopiatype1 = (stdenv.mkDerivation ((if overrides ? fontadobeutopiatype1 then overrides.fontadobeutopiatype1 else x: x) {
    name = "font-adobe-utopia-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-adobe-utopia-type1-1.0.1.tar.bz2;
      sha256 = "1p604j44vqfp7iv4a7p38vi6d1qk26grmnkdsz1dapr7zz475ip9";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontalias = (stdenv.mkDerivation ((if overrides ? fontalias then overrides.fontalias else x: x) {
    name = "font-alias-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-alias-1.0.1.tar.bz2;
      sha256 = "1dl99xmdbgwssd4zgnipc4b4l5g9s2qc08wx29bdif946bb61nvp";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontarabicmisc = (stdenv.mkDerivation ((if overrides ? fontarabicmisc then overrides.fontarabicmisc else x: x) {
    name = "font-arabic-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-arabic-misc-1.0.0.tar.bz2;
      sha256 = "155wyy6vsxha3lx9cvw22pscsdc3iljsgyh6zqpyl19qyfixzsch";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontbh100dpi = (stdenv.mkDerivation ((if overrides ? fontbh100dpi then overrides.fontbh100dpi else x: x) {
    name = "font-bh-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-100dpi-1.0.0.tar.bz2;
      sha256 = "0jpfrxwdx24ib784j6k6qbi6zvy6svyva6gda8pj98krfmvi32mf";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbh75dpi = (stdenv.mkDerivation ((if overrides ? fontbh75dpi then overrides.fontbh75dpi else x: x) {
    name = "font-bh-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-75dpi-1.0.0.tar.bz2;
      sha256 = "1gq55j00g7fqnypxy6f0wvhz5l16056sdysmbp3qk4yc82s6g567";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter100dpi then overrides.fontbhlucidatypewriter100dpi else x: x) {
    name = "font-bh-lucidatypewriter-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-lucidatypewriter-100dpi-1.0.0.tar.bz2;
      sha256 = "04vh9mccnh517q42w65k89pz3jd6szim3hazydm7n0wilp5pvm1n";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter75dpi then overrides.fontbhlucidatypewriter75dpi else x: x) {
    name = "font-bh-lucidatypewriter-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-lucidatypewriter-75dpi-1.0.0.tar.bz2;
      sha256 = "0im03ms6bx1947fkdarrdzzm8lq69pz5502n89cccj9sadpz7wjh";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontbhttf = (stdenv.mkDerivation ((if overrides ? fontbhttf then overrides.fontbhttf else x: x) {
    name = "font-bh-ttf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-ttf-1.0.0.tar.bz2;
      sha256 = "0i6nsw1i43ydljws2xzadvbmxs1p50jn9akhinwrh8z4yxr5w6ks";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontbhtype1 = (stdenv.mkDerivation ((if overrides ? fontbhtype1 then overrides.fontbhtype1 else x: x) {
    name = "font-bh-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bh-type1-1.0.0.tar.bz2;
      sha256 = "0nv4qdr8z68iczqic4gj492ln6y1xy04kxx08dhdaaf8y89mb2js";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontbitstream100dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream100dpi then overrides.fontbitstream100dpi else x: x) {
    name = "font-bitstream-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bitstream-100dpi-1.0.0.tar.bz2;
      sha256 = "1lp260dwrrr4ll9rbdq38cnvlxq843q34rxay6hl2bmmsxs5lw0c";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontbitstream75dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream75dpi then overrides.fontbitstream75dpi else x: x) {
    name = "font-bitstream-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bitstream-75dpi-1.0.0.tar.bz2;
      sha256 = "1yqv42gf4ksr5fr0b2szwfc8cczis0pppcsg1wdlwllprb6fmprd";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontbitstreamspeedo = (stdenv.mkDerivation ((if overrides ? fontbitstreamspeedo then overrides.fontbitstreamspeedo else x: x) {
    name = "font-bitstream-speedo-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bitstream-speedo-1.0.0.tar.bz2;
      sha256 = "1rpn2j99cg5dnw3mjzff65darwaz5jwjgi7i0xscq064d9w03b4r";
    };
    buildInputs = [pkgconfig mkfontdir ];
  })) // {inherit mkfontdir ;};

  fontbitstreamtype1 = (stdenv.mkDerivation ((if overrides ? fontbitstreamtype1 then overrides.fontbitstreamtype1 else x: x) {
    name = "font-bitstream-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-bitstream-type1-1.0.0.tar.bz2;
      sha256 = "00yrahjc884mghhbm713c41x7r2kbg1ply515qs3g20nrwnlkkjg";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontcacheproto = (stdenv.mkDerivation ((if overrides ? fontcacheproto then overrides.fontcacheproto else x: x) {
    name = "fontcacheproto-0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/fontcacheproto-0.1.2.tar.bz2;
      sha256 = "1yfrldprqbxv587zd9lvsn2ayfdabzkgzya5cqvjf290kga3w1j8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontcronyxcyrillic = (stdenv.mkDerivation ((if overrides ? fontcronyxcyrillic then overrides.fontcronyxcyrillic else x: x) {
    name = "font-cronyx-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-cronyx-cyrillic-1.0.0.tar.bz2;
      sha256 = "1vl4yk3sdvcqpym4d4r3lxrpyghxgjpq8yx2kdxygjpm6dq4xj86";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontcursormisc = (stdenv.mkDerivation ((if overrides ? fontcursormisc then overrides.fontcursormisc else x: x) {
    name = "font-cursor-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-cursor-misc-1.0.0.tar.bz2;
      sha256 = "1igklmxc0bgbp5a2nbmbwii5d9mh71zsxay2sw0sa6sq2xqy4pcm";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontdaewoomisc = (stdenv.mkDerivation ((if overrides ? fontdaewoomisc then overrides.fontdaewoomisc else x: x) {
    name = "font-daewoo-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-daewoo-misc-1.0.0.tar.bz2;
      sha256 = "09l98sd8wwdhgjdafq8cr6ykki4imh5qi21jwaqkhfil5v4ym67i";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontdecmisc = (stdenv.mkDerivation ((if overrides ? fontdecmisc then overrides.fontdecmisc else x: x) {
    name = "font-dec-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-dec-misc-1.0.0.tar.bz2;
      sha256 = "1fcbnv0zlbzsn68z5as0k3id83ii9k67l6bxiv2ypcfs4l96sf43";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontibmtype1 = (stdenv.mkDerivation ((if overrides ? fontibmtype1 then overrides.fontibmtype1 else x: x) {
    name = "font-ibm-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-ibm-type1-1.0.0.tar.bz2;
      sha256 = "07j6kk7wd0lbnjxn9a4kjahjniiwjyzc8lp1lvw46sahwg193l1h";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontisasmisc = (stdenv.mkDerivation ((if overrides ? fontisasmisc then overrides.fontisasmisc else x: x) {
    name = "font-isas-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-isas-misc-1.0.0.tar.bz2;
      sha256 = "18jfp92s6wmjs107rhdcz4acmzb2anhcb7s8bpd2kwhbrq9i7rlp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontjismisc = (stdenv.mkDerivation ((if overrides ? fontjismisc then overrides.fontjismisc else x: x) {
    name = "font-jis-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-jis-misc-1.0.0.tar.bz2;
      sha256 = "1fn75mqx6xjqffbd01a1wplc8cf7spwsrxv5h2accizw9zyyw89p";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontmicromisc = (stdenv.mkDerivation ((if overrides ? fontmicromisc then overrides.fontmicromisc else x: x) {
    name = "font-micro-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-micro-misc-1.0.0.tar.bz2;
      sha256 = "0wm52zgbly62vsbr5c4wz9rh1vk4y1viyv09r20r6bp175cppc8n";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontmisccyrillic = (stdenv.mkDerivation ((if overrides ? fontmisccyrillic then overrides.fontmisccyrillic else x: x) {
    name = "font-misc-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-misc-cyrillic-1.0.0.tar.bz2;
      sha256 = "1zwh69k7id17jabwia6x43f520lbf8787nf71vs3p78j089sq2vw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontmiscethiopic = (stdenv.mkDerivation ((if overrides ? fontmiscethiopic then overrides.fontmiscethiopic else x: x) {
    name = "font-misc-ethiopic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-misc-ethiopic-1.0.0.tar.bz2;
      sha256 = "0hficywkkzl4dpws9sg47d3m1igpb7m4myw8zabkf1na0648dljq";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontmiscmeltho = (stdenv.mkDerivation ((if overrides ? fontmiscmeltho then overrides.fontmiscmeltho else x: x) {
    name = "font-misc-meltho-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-misc-meltho-1.0.0.tar.bz2;
      sha256 = "091ripcw30cs6032p12gwcy2hg8b1y24irgacwsky1dn4scjpqf7";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
  })) // {inherit mkfontdir mkfontscale ;};

  fontmiscmisc = (stdenv.mkDerivation ((if overrides ? fontmiscmisc then overrides.fontmiscmisc else x: x) {
    name = "font-misc-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-misc-misc-1.0.0.tar.bz2;
      sha256 = "1nqp7zhwmrh6ng8j4i4pscqj2xhh57sdmrkbqgklh5hzmmh2b816";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontmuttmisc = (stdenv.mkDerivation ((if overrides ? fontmuttmisc then overrides.fontmuttmisc else x: x) {
    name = "font-mutt-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-mutt-misc-1.0.0.tar.bz2;
      sha256 = "1zzd3ba1i2ffqh8yyvyqyhcyxa7j474lb8x88b5cxf7js0xih6gj";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontschumachermisc = (stdenv.mkDerivation ((if overrides ? fontschumachermisc then overrides.fontschumachermisc else x: x) {
    name = "font-schumacher-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-schumacher-misc-1.0.0.tar.bz2;
      sha256 = "0ypgas5hjwaad53hfpx2w5s1scybh953vb94rrlmaix4hpw6qkj5";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  })) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};

  fontscreencyrillic = (stdenv.mkDerivation ((if overrides ? fontscreencyrillic then overrides.fontscreencyrillic else x: x) {
    name = "font-screen-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-screen-cyrillic-1.0.1.tar.bz2;
      sha256 = "07y52rm2m17ig6piynk9jgyhdv8a4s7jmn5ssa83a61a607mymyr";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontsonymisc = (stdenv.mkDerivation ((if overrides ? fontsonymisc then overrides.fontsonymisc else x: x) {
    name = "font-sony-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-sony-misc-1.0.0.tar.bz2;
      sha256 = "08rf8m9mqg9h0w67b5k55hs73v2s9lxz7aab0nq7rd90c3kkms8s";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontsproto = (stdenv.mkDerivation ((if overrides ? fontsproto then overrides.fontsproto else x: x) {
    name = "fontsproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/fontsproto-2.0.2.tar.bz2;
      sha256 = "0ywb783l7gwypq5nchfmysra0n6dqv9hc3vsf4ra44da65qm9gc3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontsunmisc = (stdenv.mkDerivation ((if overrides ? fontsunmisc then overrides.fontsunmisc else x: x) {
    name = "font-sun-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-sun-misc-1.0.0.tar.bz2;
      sha256 = "1r99ayxfc1qqcg6zwfkkvbga3qwyf3h3xsh1ymw02zwf9n7jvh83";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontutil = (stdenv.mkDerivation ((if overrides ? fontutil then overrides.fontutil else x: x) {
    name = "font-util-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-util-1.0.1.tar.bz2;
      sha256 = "04h6c24q08d8ljajxzlfwyr1fxfhb88b3w21nfmy6bm3gsqj7304";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  fontwinitzkicyrillic = (stdenv.mkDerivation ((if overrides ? fontwinitzkicyrillic then overrides.fontwinitzkicyrillic else x: x) {
    name = "font-winitzki-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-winitzki-cyrillic-1.0.0.tar.bz2;
      sha256 = "1qzf9f1irn4difbz2s6j8yhn4hdg95j35q89nhss7rpwh5l7z2j7";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  })) // {inherit bdftopcf mkfontdir mkfontscale ;};

  fontxfree86type1 = (stdenv.mkDerivation ((if overrides ? fontxfree86type1 then overrides.fontxfree86type1 else x: x) {
    name = "font-xfree86-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/font-xfree86-type1-1.0.1.tar.bz2;
      sha256 = "0hgksnwch59bxxxpmzlwrm2qqhnpj651m458bv1azn1026wgkncg";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)";
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
    name = "glproto-1.4.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/glproto-1.4.9.tar.bz2;
      sha256 = "18v48zb3jfxlcvhi66zxk7mr4y37vj48qv3vlv9npxghwixzpmv9";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  iceauth = (stdenv.mkDerivation ((if overrides ? iceauth then overrides.iceauth else x: x) {
    name = "iceauth-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/iceauth-1.0.2.tar.bz2;
      sha256 = "1fxmpa9262b1iklxmy3ca72m34x11qixbqsm4b7w98jpvs8iah06";
    };
    buildInputs = [pkgconfig libICE xproto ];
  })) // {inherit libICE xproto ;};

  imake = (stdenv.mkDerivation ((if overrides ? imake then overrides.imake else x: x) {
    name = "imake-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.2.tar.bz2;
      sha256 = "0yxca3hbz4hfk0fm385lbm89061p2nksr5klx2y3x1knmvsgzklp";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  inputproto = (stdenv.mkDerivation ((if overrides ? inputproto then overrides.inputproto else x: x) {
    name = "inputproto-1.4.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/inputproto-1.4.4.tar.bz2;
      sha256 = "1rfz0x03iw18ji6728qnqmi56blqgak89vzs7sgbpfnnjbs8w9v3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  kbproto = (stdenv.mkDerivation ((if overrides ? kbproto then overrides.kbproto else x: x) {
    name = "kbproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/kbproto-1.0.3.tar.bz2;
      sha256 = "1pqrrsag6njdrxpx5sm48gh68w64fv5jpmvp2jkjhynhpdg0003h";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  libAppleWM = (stdenv.mkDerivation ((if overrides ? libAppleWM then overrides.libAppleWM else x: x) {
    name = "libAppleWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libAppleWM-1.0.0.tar.bz2;
      sha256 = "0zj0n0ykv3zy68d23xyf2c58ddn5m78b8j1zcynb93j1g90gzlpc";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  })) // {inherit applewmproto libX11 libXext xextproto ;};

  libFS = (stdenv.mkDerivation ((if overrides ? libFS then overrides.libFS else x: x) {
    name = "libFS-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libFS-1.0.1.tar.bz2;
      sha256 = "1x9cbaildzwi2ih5vylvdfqk7a7j040nq6ndh9vf0s8ynpyjzycv";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  })) // {inherit fontsproto xproto xtrans ;};

  libICE = (stdenv.mkDerivation ((if overrides ? libICE then overrides.libICE else x: x) {
    name = "libICE-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libICE-1.0.4.tar.bz2;
      sha256 = "012ga4q5rxajnn3fd249xnirnvw6lms7jyp9bh9vsp349hpmw18k";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  })) // {inherit xproto xtrans ;};

  libSM = (stdenv.mkDerivation ((if overrides ? libSM then overrides.libSM else x: x) {
    name = "libSM-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libSM-1.1.0.tar.bz2;
      sha256 = "10iap6ydxmk0g5qcfnsf9yc30fhvqshgppm0sca21y0z5qwaqdkm";
    };
    configureFlags = if stdenv.system == "i686-darwin" then "LIBUUID_CFLAGS='' LIBUUID_LIBS=''" else "";
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
  })) // {inherit libICE libuuid xproto xtrans ;};

  libWindowsWM = (stdenv.mkDerivation ((if overrides ? libWindowsWM then overrides.libWindowsWM else x: x) {
    name = "libWindowsWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libWindowsWM-1.0.0.tar.bz2;
      sha256 = "0shnxkg9ghihgyrl3dzhqdcgssa7146dn1j51rzbl89x2xk75n3a";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  })) // {inherit windowswmproto libX11 libXext xextproto ;};

  libX11 = (stdenv.mkDerivation ((if overrides ? libX11 then overrides.libX11 else x: x) {
    name = "libX11-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.2.1.tar.bz2;
      sha256 = "1wyzvwzywqafh9zmqb5v1fca34y11674xns5y57pyq5206jfawni";
    };
    buildInputs = [pkgconfig bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ];
  })) // {inherit bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ;};

  libXScrnSaver = (stdenv.mkDerivation ((if overrides ? libXScrnSaver then overrides.libXScrnSaver else x: x) {
    name = "libXScrnSaver-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXScrnSaver-1.1.3.tar.bz2;
      sha256 = "1269nbcrfyark3h4687pjkcsldsi0ygy1iigmym28nn1jd82942b";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  })) // {inherit scrnsaverproto libX11 libXext xextproto ;};

  libXau = (stdenv.mkDerivation ((if overrides ? libXau then overrides.libXau else x: x) {
    name = "libXau-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXau-1.0.4.tar.bz2;
      sha256 = "0b5jvqp0n9iz3qag4k7g2bwzs7d0vy5sd6rhhd00l30dy2jzzlqh";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  libXaw = (stdenv.mkDerivation ((if overrides ? libXaw then overrides.libXaw else x: x) {
    name = "libXaw-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXaw-1.0.4.tar.bz2;
      sha256 = "1yaslcpj6sd6s8gx2hv60gfjf515gggd8f2jv4zqbp5q9wcapx0i";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ];
  })) // {inherit printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ;};

  libXcomposite = (stdenv.mkDerivation ((if overrides ? libXcomposite then overrides.libXcomposite else x: x) {
    name = "libXcomposite-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXcomposite-0.4.0.tar.bz2;
      sha256 = "043m7jhqzqfb02g29v8k57xxm4vqbw15gln4wja81xni5pl5kdvx";
    };
    buildInputs = [pkgconfig compositeproto fixesproto libX11 libXext libXfixes xproto ];
  })) // {inherit compositeproto fixesproto libX11 libXext libXfixes xproto ;};

  libXcursor = (stdenv.mkDerivation ((if overrides ? libXcursor then overrides.libXcursor else x: x) {
    name = "libXcursor-1.1.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXcursor-1.1.9.tar.bz2;
      sha256 = "1d6j2md25f6g45xjb2sqsqwvdidf9i3n3mb682bcxj3i49ab7zqx";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
  })) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};

  libXdamage = (stdenv.mkDerivation ((if overrides ? libXdamage then overrides.libXdamage else x: x) {
    name = "libXdamage-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXdamage-1.1.1.tar.bz2;
      sha256 = "0bmf5y9wwas5g40inghq7lzcm48z36zip27pmp1s2lirn96pa0h1";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
  })) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};

  libXdmcp = (stdenv.mkDerivation ((if overrides ? libXdmcp then overrides.libXdmcp else x: x) {
    name = "libXdmcp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXdmcp-1.0.2.tar.bz2;
      sha256 = "1a4n1z0vfzw10pcj27g95rjn06c231cg38l44z14b4ar8wc0rrgk";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  libXext = (stdenv.mkDerivation ((if overrides ? libXext then overrides.libXext else x: x) {
    name = "libXext-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXext-1.0.5.tar.bz2;
      sha256 = "15vx6712s53640gv307bpa2pg7ds8wrxx3l5i554id3c8scaz00j";
    };
    buildInputs = [pkgconfig libX11 libXau xextproto xproto ];
  })) // {inherit libX11 libXau xextproto xproto ;};

  libXfixes = (stdenv.mkDerivation ((if overrides ? libXfixes then overrides.libXfixes else x: x) {
    name = "libXfixes-4.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXfixes-4.0.3.tar.bz2;
      sha256 = "1p99m3hdh9m6a59jyn4vgwbppabhppsjdkjkwrfbii1pa0y0jzjl";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  })) // {inherit fixesproto libX11 xextproto xproto ;};

  libXfont = (stdenv.mkDerivation ((if overrides ? libXfont then overrides.libXfont else x: x) {
    name = "libXfont-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXfont-1.3.3.tar.bz2;
      sha256 = "0nhxynfhljfwvpq9f867fvc15r78r363rinr3dhk6qxxljyfcwb1";
    };
    buildInputs = [pkgconfig fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ];
  })) // {inherit fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ;};

  libXfontcache = (stdenv.mkDerivation ((if overrides ? libXfontcache then overrides.libXfontcache else x: x) {
    name = "libXfontcache-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXfontcache-1.0.4.tar.bz2;
      sha256 = "0770yg0b9vqqlsq34nxb7ri3pf0smlhx018vmxidikc1pz7lgrzz";
    };
    buildInputs = [pkgconfig fontcacheproto libX11 libXext xextproto ];
  })) // {inherit fontcacheproto libX11 libXext xextproto ;};

  libXft = (stdenv.mkDerivation ((if overrides ? libXft then overrides.libXft else x: x) {
    name = "libXft-2.1.13";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXft-2.1.13.tar.bz2;
      sha256 = "136yrzxb5xmpd34plhfj4yvla0iish3b7kqv8api8k7ki8jqhxnf";
    };
    buildInputs = [pkgconfig fontconfig freetype libXrender ];
  })) // {inherit fontconfig freetype libXrender ;};

  libXi = (stdenv.mkDerivation ((if overrides ? libXi then overrides.libXi else x: x) {
    name = "libXi-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXi-1.1.3.tar.bz2;
      sha256 = "0gqm2a4bplpidhzknqvr6b1ipadcayyz3z6y794sdl6hjyz5nyn7";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  })) // {inherit inputproto libX11 libXext xextproto xproto ;};

  libXinerama = (stdenv.mkDerivation ((if overrides ? libXinerama then overrides.libXinerama else x: x) {
    name = "libXinerama-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXinerama-1.0.3.tar.bz2;
      sha256 = "068j31apk38dapqfs368h9jzwx2xm6vk0qmmh02w4m31sm65dcq7";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  })) // {inherit libX11 libXext xextproto xineramaproto ;};

  libXmu = (stdenv.mkDerivation ((if overrides ? libXmu then overrides.libXmu else x: x) {
    name = "libXmu-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXmu-1.0.4.tar.bz2;
      sha256 = "1w0qz8m8qq8nvamipzmry99sgxgn3xzjvk4xzbphhk4gxpb00g7q";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXp = (stdenv.mkDerivation ((if overrides ? libXp then overrides.libXp else x: x) {
    name = "libXp-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXp-1.0.0.tar.bz2;
      sha256 = "1blwrr5zhmwwy87j0svmhv3hc13acyn5j14n5rv0anz81iav2r3y";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  })) // {inherit printproto libX11 libXau libXext xextproto ;};

  libXpm = (stdenv.mkDerivation ((if overrides ? libXpm then overrides.libXpm else x: x) {
    name = "libXpm-3.5.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXpm-3.5.7.tar.bz2;
      sha256 = "1aibr6y6hnlgc7m1a1y5s1qx7863praq4pdp0xrpkc75gkk1lw34";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};

  libXrandr = (stdenv.mkDerivation ((if overrides ? libXrandr then overrides.libXrandr else x: x) {
    name = "libXrandr-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXrandr-1.2.3.tar.bz2;
      sha256 = "0ryj1v6127j0639by810jxiaspwsn2l837wl79x6ghy4p0kgxvgq";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
  })) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};

  libXrender = (stdenv.mkDerivation ((if overrides ? libXrender then overrides.libXrender else x: x) {
    name = "libXrender-0.9.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXrender-0.9.4.tar.bz2;
      sha256 = "1v0p63g426x0hii0gynq05ccwihr6dn9azjpls8z4zjfvm1x70jn";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
  })) // {inherit renderproto libX11 xproto ;};

  libXres = (stdenv.mkDerivation ((if overrides ? libXres then overrides.libXres else x: x) {
    name = "libXres-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXres-1.0.3.tar.bz2;
      sha256 = "0c02i8wnwdnzkiaviddc2h7xswg6s58ipw4m204hzv7mfdsvmmd6";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
  })) // {inherit resourceproto libX11 libXext xextproto xproto ;};

  libXt = (stdenv.mkDerivation ((if overrides ? libXt then overrides.libXt else x: x) {
    name = "libXt-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXt-1.0.5.tar.bz2;
      sha256 = "1x4w7qdciwgjj0ccr1xn7v21pf1csi6cs99j8s54414slnnp5i23";
    };
    buildInputs = [pkgconfig kbproto libSM libX11 xproto ];
  })) // {inherit kbproto libSM libX11 xproto ;};

  libXtst = (stdenv.mkDerivation ((if overrides ? libXtst then overrides.libXtst else x: x) {
    name = "libXtst-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXtst-1.0.3.tar.bz2;
      sha256 = "01f9b3386v3dzlvdg0ccpa2wyv0d6b9fbxy149rws17bkhyxva5l";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto ];
  })) // {inherit inputproto recordproto libX11 libXext xextproto ;};

  libXv = (stdenv.mkDerivation ((if overrides ? libXv then overrides.libXv else x: x) {
    name = "libXv-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXv-1.0.4.tar.bz2;
      sha256 = "1j18fif5mv1gsb7nswqw010impwi7aifqm3036bd79jddydw8g2d";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
  })) // {inherit videoproto libX11 libXext xextproto xproto ;};

  libXvMC = (stdenv.mkDerivation ((if overrides ? libXvMC then overrides.libXvMC else x: x) {
    name = "libXvMC-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXvMC-1.0.4.tar.bz2;
      sha256 = "1frshf8nfa81hz4q61qg1pc2sz93dl6nsc78dr39hqfnm1dq45qj";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
  })) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};

  libXxf86dga = (stdenv.mkDerivation ((if overrides ? libXxf86dga then overrides.libXxf86dga else x: x) {
    name = "libXxf86dga-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXxf86dga-1.0.2.tar.bz2;
      sha256 = "09cs62bvnv1wwjqcqyckhj0b0v7wa3dyldlg2icv67qal0q545sr";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};

  libXxf86misc = (stdenv.mkDerivation ((if overrides ? libXxf86misc then overrides.libXxf86misc else x: x) {
    name = "libXxf86misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXxf86misc-1.0.1.tar.bz2;
      sha256 = "128jm6nssp5wfic17rb54ssz6j3hibm77c9xxgm6x85a95yxc8i1";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};

  libXxf86vm = (stdenv.mkDerivation ((if overrides ? libXxf86vm then overrides.libXxf86vm else x: x) {
    name = "libXxf86vm-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libXxf86vm-1.0.2.tar.bz2;
      sha256 = "1pji77kksdjn3n1hi6970dqs58jbdvmxphm6ddlbqkraap3c7crw";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};

  libdmx = (stdenv.mkDerivation ((if overrides ? libdmx then overrides.libdmx else x: x) {
    name = "libdmx-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libdmx-1.0.2.tar.bz2;
      sha256 = "1i5r4spy5s9s5nfxzpxlx06j6xcf865z821cfq2flz1zahdg6gzs";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  })) // {inherit dmxproto libX11 libXext xextproto ;};

  libfontenc = (stdenv.mkDerivation ((if overrides ? libfontenc then overrides.libfontenc else x: x) {
    name = "libfontenc-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libfontenc-1.0.4.tar.bz2;
      sha256 = "1j2qc9xqc2wibc005abvkj8wwn9hk6b5s2qn94ma2ig82wysm4xr";
    };
    buildInputs = [pkgconfig xproto zlib ];
  })) // {inherit xproto zlib ;};

  libpciaccess = (stdenv.mkDerivation ((if overrides ? libpciaccess then overrides.libpciaccess else x: x) {
    name = "libpciaccess-0.10.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.10.5.tar.bz2;
      sha256 = "0pg99b53cp3ypa7w99dsd2l6xdcbhldp8iivrd9r1rcl75d7didn";
    };
    buildInputs = [pkgconfig zlib ];
  })) // {inherit zlib ;};

  libpthreadstubs = (stdenv.mkDerivation ((if overrides ? libpthreadstubs then overrides.libpthreadstubs else x: x) {
    name = "libpthread-stubs-0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.1.tar.bz2;
      sha256 = "0raxl73kmviqinp00bfa025d0j4vmfjjcvfn754mi60mw48swk80";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  libxcb = (stdenv.mkDerivation ((if overrides ? libxcb then overrides.libxcb else x: x) {
    name = "libxcb-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.2.tar.bz2;
      sha256 = "0gyb6fqhl07mfl1rrhqb5195iy11jmx0dmjsqb7flp0cxmcldqag";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
  })) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};

  libxkbfile = (stdenv.mkDerivation ((if overrides ? libxkbfile then overrides.libxkbfile else x: x) {
    name = "libxkbfile-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/libxkbfile-1.0.5.tar.bz2;
      sha256 = "0pwnb3jv4105mj3mpadc23aq3388fcsq5nb1z02nvjy93wkjidha";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  })) // {inherit kbproto libX11 ;};

  lndir = (stdenv.mkDerivation ((if overrides ? lndir then overrides.lndir else x: x) {
    name = "lndir-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/lndir-1.0.1.tar.bz2;
      sha256 = "0a84q8m3x8qbyrhx7r2k7wmhdb5588vcb1r21ifkx8yaaw1360fk";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  luit = (stdenv.mkDerivation ((if overrides ? luit then overrides.luit else x: x) {
    name = "luit-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/luit-1.0.3.tar.bz2;
      sha256 = "1mx5fw4iz62gz2y6z92w0wnl81zvfhah9hzd09zsd2gf5qaz4410";
    };
    buildInputs = [pkgconfig libfontenc libX11 zlib ];
  })) // {inherit libfontenc libX11 zlib ;};

  makedepend = (stdenv.mkDerivation ((if overrides ? makedepend then overrides.makedepend else x: x) {
    name = "makedepend-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/makedepend-1.0.1.tar.bz2;
      sha256 = "1lmi2vagp6svfvkqmhsbafjhchwscii7sfdzr20d90hg46gsslmp";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  mkfontdir = (stdenv.mkDerivation ((if overrides ? mkfontdir then overrides.mkfontdir else x: x) {
    name = "mkfontdir-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/mkfontdir-1.0.4.tar.bz2;
      sha256 = "1qzqrb3pg96gd0mifw74syghajwpkkbda0gzwkl4ww171p3kr6kg";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  mkfontscale = (stdenv.mkDerivation ((if overrides ? mkfontscale then overrides.mkfontscale else x: x) {
    name = "mkfontscale-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/mkfontscale-1.0.5.tar.bz2;
      sha256 = "0l1qxlqb57idiafbzbfhsfjd4pn5vdv4fbizxfwvxhrx2magz7gp";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  })) // {inherit libfontenc freetype xproto zlib ;};

  pixman = (stdenv.mkDerivation ((if overrides ? pixman then overrides.pixman else x: x) {
    name = "pixman-0.15.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/pixman-0.15.2.tar.bz2;
      sha256 = "1wf0cmx8jj5l0d0g0d948a8z2k1yram3dvgd08yxl8v8pdjvadzm";
    };
    buildInputs = [pkgconfig perl ];
  })) // {inherit perl ;};

  printproto = (stdenv.mkDerivation ((if overrides ? printproto then overrides.printproto else x: x) {
    name = "printproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/printproto-1.0.4.tar.bz2;
      sha256 = "1gnkpz8iyl27gyjvy8rhm9v6g5qvz3632pn5djxks577i0qsjngh";
    };
    buildInputs = [pkgconfig libXau ];
  })) // {inherit libXau ;};

  randrproto = (stdenv.mkDerivation ((if overrides ? randrproto then overrides.randrproto else x: x) {
    name = "randrproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/randrproto-1.2.1.tar.bz2;
      sha256 = "0m7n624h2rsxs7m5x03az87x7hlh0gxqphj59q7laqi5iwpx8bqh";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  recordproto = (stdenv.mkDerivation ((if overrides ? recordproto then overrides.recordproto else x: x) {
    name = "recordproto-1.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/recordproto-1.13.2.tar.bz2;
      sha256 = "1yfg15k5fznjvndvld3vw7gcbcmq1p6ic0dybf1a2wzk2j5pmrq4";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  renderproto = (stdenv.mkDerivation ((if overrides ? renderproto then overrides.renderproto else x: x) {
    name = "renderproto-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/renderproto-0.9.3.tar.bz2;
      sha256 = "0nyl5pmgrvw7p6laqgsrk65b633yvrrf8jx0vakqz2p9fyw0i2n9";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  resourceproto = (stdenv.mkDerivation ((if overrides ? resourceproto then overrides.resourceproto else x: x) {
    name = "resourceproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/resourceproto-1.0.2.tar.bz2;
      sha256 = "11rlnn54y15bf39ll7vzn9824l1ib15r7p4v8l0k0j7mxvydccqc";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  scrnsaverproto = (stdenv.mkDerivation ((if overrides ? scrnsaverproto then overrides.scrnsaverproto else x: x) {
    name = "scrnsaverproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/scrnsaverproto-1.1.0.tar.bz2;
      sha256 = "13s7rpygj0zm8lk6r9zw1ivs8wj3g4qrfqw80ifc0ff37kvsn2fv";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  sessreg = (stdenv.mkDerivation ((if overrides ? sessreg then overrides.sessreg else x: x) {
    name = "sessreg-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/sessreg-1.0.4.tar.bz2;
      sha256 = "00lqgsdm74kz7csi9is906gr3nfwz3viaax10ipw32i05r867q93";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};

  setxkbmap = (stdenv.mkDerivation ((if overrides ? setxkbmap then overrides.setxkbmap else x: x) {
    name = "setxkbmap-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/setxkbmap-1.0.4.tar.bz2;
      sha256 = "1b1brw1v98q2rqhr5x7f8mr3clxq62nw5175gpamg5s172916nwv";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};

  smproxy = (stdenv.mkDerivation ((if overrides ? smproxy then overrides.smproxy else x: x) {
    name = "smproxy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/smproxy-1.0.2.tar.bz2;
      sha256 = "1lk79yfdalpn0c7hm57vpr3xg6rib1dr6p2wl634733wy062zlkn";
    };
    buildInputs = [pkgconfig libXmu libXt ];
  })) // {inherit libXmu libXt ;};

  trapproto = (stdenv.mkDerivation ((if overrides ? trapproto then overrides.trapproto else x: x) {
    name = "trapproto-3.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/trapproto-3.4.3.tar.bz2;
      sha256 = "1qd06blxgah1pf49259gm9njpbqqk1gcisbv8p1ssv39pk9s0cpz";
    };
    buildInputs = [pkgconfig libXt ];
  })) // {inherit libXt ;};

  twm = (stdenv.mkDerivation ((if overrides ? twm then overrides.twm else x: x) {
    name = "twm-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/twm-1.0.4.tar.bz2;
      sha256 = "1yp1inyglf818pp4rjh250zva4i2jip79m3vkf90h593mvwqi86s";
    };
    buildInputs = [pkgconfig libICE libSM libX11 libXext libXmu libXt ];
  })) // {inherit libICE libSM libX11 libXext libXmu libXt ;};

  utilmacros = (stdenv.mkDerivation ((if overrides ? utilmacros then overrides.utilmacros else x: x) {
    name = "util-macros-1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/util-macros-1.1.6.tar.bz2;
      sha256 = "0rjc3vsivrwbwlqnrsi57w5bdi7sb86wc5gzd7d1z0f4ylgcqgxh";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  videoproto = (stdenv.mkDerivation ((if overrides ? videoproto then overrides.videoproto else x: x) {
    name = "videoproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/videoproto-2.2.2.tar.bz2;
      sha256 = "033q4jgrwgkdcwj5q8hwf7vpl5sdzm7z9dsgwcphrlqchdw8825b";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  windowswmproto = (stdenv.mkDerivation ((if overrides ? windowswmproto then overrides.windowswmproto else x: x) {
    name = "windowswmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/windowswmproto-1.0.3.tar.bz2;
      sha256 = "0lgih20hvpxzdvzwrw5plfynrkb2b930mnfymfnffbdvjsb283bq";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  x11perf = (stdenv.mkDerivation ((if overrides ? x11perf then overrides.x11perf else x: x) {
    name = "x11perf-1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/x11perf-1.5.tar.bz2;
      sha256 = "0cqjrr1l1mcnbcx3lab73qmjxbvskcgpgfxlimsf3dz0vm9xlaa7";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  })) // {inherit libX11 libXext libXft libXmu libXrender ;};

  xauth = (stdenv.mkDerivation ((if overrides ? xauth then overrides.xauth else x: x) {
    name = "xauth-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xauth-1.0.3.tar.bz2;
      sha256 = "136sbgfirl9hxcg2a40z2xfs4f35z0f7nmxrkrja8km7zm9qpl8z";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  })) // {inherit libX11 libXau libXext libXmu ;};

  xbacklight = (stdenv.mkDerivation ((if overrides ? xbacklight then overrides.xbacklight else x: x) {
    name = "xbacklight-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xbacklight-1.1.tar.bz2;
      sha256 = "1934bnxa3hx0mzihv3bgcid6qrn75an03ci5dzhnjicp2lgh15f7";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  })) // {inherit libX11 libXrandr libXrender ;};

  xbitmaps = (stdenv.mkDerivation ((if overrides ? xbitmaps then overrides.xbitmaps else x: x) {
    name = "xbitmaps-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xbitmaps-1.0.1.tar.bz2;
      sha256 = "0rxqxrnkivn52kk41a9bl1ppy756c5gw5w1rbnw75xvp9rcvx9as";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xcbproto = (stdenv.mkDerivation ((if overrides ? xcbproto then overrides.xcbproto else x: x) {
    name = "xcb-proto-1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.4.tar.bz2;
      sha256 = "1gars8dwbc9ffjs287rpwsvw5isv25r0ij298plfqj59ynvafl1d";
    };
    buildInputs = [pkgconfig python ];
  })) // {inherit python ;};

  xcbutil = (stdenv.mkDerivation ((if overrides ? xcbutil then overrides.xcbutil else x: x) {
    name = "xcb-util-0.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.3.4.tar.bz2;
      sha256 = "09ld81zibmhb64nirc97sys8k59sshqkf8ngqpcyd8azpvlj7dzf";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};

  xclock = (stdenv.mkDerivation ((if overrides ? xclock then overrides.xclock else x: x) {
    name = "xclock-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.3.tar.bz2;
      sha256 = "0zspx5jqp52wgp4c4d9qaxhp0b9p2fzx2ys4rza10apgx5x7gd8h";
    };
    buildInputs = [pkgconfig libXaw libX11 libXft libxkbfile libXrender libXt ];
  })) // {inherit libXaw libX11 libXft libxkbfile libXrender libXt ;};

  xcmiscproto = (stdenv.mkDerivation ((if overrides ? xcmiscproto then overrides.xcmiscproto else x: x) {
    name = "xcmiscproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xcmiscproto-1.1.2.tar.bz2;
      sha256 = "1awjhz3cc06zsds57qnjwgm3y7z5bl4l6akqy6xvfcnnm6b7x05j";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xcmsdb = (stdenv.mkDerivation ((if overrides ? xcmsdb then overrides.xcmsdb else x: x) {
    name = "xcmsdb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xcmsdb-1.0.1.tar.bz2;
      sha256 = "0bp9xw2cmj9d0d18h5fdzcmc7jnjzbn5sb3vnx6qbbpz86gs6xg2";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xcursorgen = (stdenv.mkDerivation ((if overrides ? xcursorgen then overrides.xcursorgen else x: x) {
    name = "xcursorgen-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xcursorgen-1.0.2.tar.bz2;
      sha256 = "0khp7i7w8b5835q7wfdg385x072fhwbnpjqvv558vvxgs8mk42g0";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  })) // {inherit libpng libX11 libXcursor ;};

  xcursorthemes = (stdenv.mkDerivation ((if overrides ? xcursorthemes then overrides.xcursorthemes else x: x) {
    name = "xcursor-themes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xcursor-themes-1.0.1.tar.bz2;
      sha256 = "184ybhyb6wj082rvr83q4jnnx3g7f1i4kpm3s4dwwifh5i0cszaf";
    };
    buildInputs = [pkgconfig libXcursor ];
  })) // {inherit libXcursor ;};

  xdpyinfo = (stdenv.mkDerivation ((if overrides ? xdpyinfo then overrides.xdpyinfo else x: x) {
    name = "xdpyinfo-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xdpyinfo-1.0.3.tar.bz2;
      sha256 = "0qhr7r3q4hs7cjpxh8fjyjia35czbdxzrb7bwm3znkxxa63pd522";
    };
    buildInputs = [pkgconfig libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  })) // {inherit libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};

  xdriinfo = (stdenv.mkDerivation ((if overrides ? xdriinfo then overrides.xdriinfo else x: x) {
    name = "xdriinfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xdriinfo-1.0.2.tar.bz2;
      sha256 = "0rbj9s0jc265wzqz79q9dkqy7626dmby6qdd4266hybcbc4sq0vv";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  })) // {inherit glproto libX11 ;};

  xev = (stdenv.mkDerivation ((if overrides ? xev then overrides.xev else x: x) {
    name = "xev-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xev-1.0.3.tar.bz2;
      sha256 = "0fiim4052r6jgzya9f2zixv2qdmrmf35bxd54yz375zfakhpmb6l";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xextproto = (stdenv.mkDerivation ((if overrides ? xextproto then overrides.xextproto else x: x) {
    name = "xextproto-7.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xextproto-7.0.5.tar.bz2;
      sha256 = "0hmhlmn6jv6ybv6q57s0377bvqrfrshi9z1dgdk7ibfsjqy1ygnk";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xeyes = (stdenv.mkDerivation ((if overrides ? xeyes then overrides.xeyes else x: x) {
    name = "xeyes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xeyes-1.0.1.tar.bz2;
      sha256 = "0ac0m9af193lxpyj11k2sp2xpmlhzzn3xrs6kdyy6c11fgl042ak";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  })) // {inherit libX11 libXext libXmu libXt ;};

  xf86bigfontproto = (stdenv.mkDerivation ((if overrides ? xf86bigfontproto then overrides.xf86bigfontproto else x: x) {
    name = "xf86bigfontproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86bigfontproto-1.1.2.tar.bz2;
      sha256 = "097i2l56kwgcd6033ng8j83xpx9pxlnwx53gvcwaf2bpnaspbd01";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86dga = (stdenv.mkDerivation ((if overrides ? xf86dga then overrides.xf86dga else x: x) {
    name = "xf86dga-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86dga-1.0.2.tar.bz2;
      sha256 = "0mqqrifbbfj2bh6hd187kmfzfn1rxgghmhsy9i6s5rcn6yw361k5";
    };
    buildInputs = [pkgconfig libX11 libXaw libXmu libXt libXxf86dga ];
  })) // {inherit libX11 libXaw libXmu libXt libXxf86dga ;};

  xf86dgaproto = (stdenv.mkDerivation ((if overrides ? xf86dgaproto then overrides.xf86dgaproto else x: x) {
    name = "xf86dgaproto-2.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86dgaproto-2.0.3.tar.bz2;
      sha256 = "00mhjvbgkgr08d8drjavrvxyvnma5rddnmpxc5y74cmh12ix9i2s";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86driproto = (stdenv.mkDerivation ((if overrides ? xf86driproto then overrides.xf86driproto else x: x) {
    name = "xf86driproto-2.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86driproto-2.0.4.tar.bz2;
      sha256 = "1nprqyd72f9hkmf4mdpmc9c9incps9p3y3jwx4pm0qw5ximsczgm";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86inputacecad = (stdenv.mkDerivation ((if overrides ? xf86inputacecad then overrides.xf86inputacecad else x: x) {
    name = "xf86-input-acecad-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-acecad-1.2.2.tar.bz2;
      sha256 = "0vpj6ll76iw2qmpyqdh318ixhyn30x9s5xnnimjcwyfmgryvnglm";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputaiptek = (stdenv.mkDerivation ((if overrides ? xf86inputaiptek then overrides.xf86inputaiptek else x: x) {
    name = "xf86-input-aiptek-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-aiptek-1.1.1.tar.bz2;
      sha256 = "0xsxm003yxlpzlvrh964jpb1d890fgcr9z3ihhxk74sv4yq1d491";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputevdev = (stdenv.mkDerivation ((if overrides ? xf86inputevdev then overrides.xf86inputevdev else x: x) {
    name = "xf86-input-evdev-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.2.2.tar.bz2;
      sha256 = "156ragzgb67wpkc5vz2mczgiardp91h2njzcsxxv89vcx0cn2q33";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};

  xf86inputjoystick = (stdenv.mkDerivation ((if overrides ? xf86inputjoystick then overrides.xf86inputjoystick else x: x) {
    name = "xf86-input-joystick-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-joystick-1.3.2.tar.bz2;
      sha256 = "0jqxjka9gsp90js6273gn01jmkjg9dvw1y94a9fcgpjl1a727bbc";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  })) // {inherit inputproto kbproto randrproto xorgserver xproto ;};

  xf86inputkeyboard = (stdenv.mkDerivation ((if overrides ? xf86inputkeyboard then overrides.xf86inputkeyboard else x: x) {
    name = "xf86-input-keyboard-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-keyboard-1.3.1.tar.bz2;
      sha256 = "0hmyyg4rxlm9y0jma324hiqrv1zb14zvqm9kx8nm38mmvwalflbv";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  })) // {inherit inputproto kbproto randrproto xorgserver xproto ;};

  xf86inputmouse = (stdenv.mkDerivation ((if overrides ? xf86inputmouse then overrides.xf86inputmouse else x: x) {
    name = "xf86-input-mouse-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-mouse-1.3.0.tar.bz2;
      sha256 = "1v4xzx6ng72vl2jakdz1kjm5k7n78p2qpkhlay3c55b76qzjajq5";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputsynaptics = (stdenv.mkDerivation ((if overrides ? xf86inputsynaptics then overrides.xf86inputsynaptics else x: x) {
    name = "xf86-input-synaptics-0.15.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-synaptics-0.15.0.tar.bz2;
      sha256 = "12swi6sprhpy3k0wx2f6b0rdmgy2571r08zip1gga7d1fp1q3m77";
    };
    buildInputs = [pkgconfig inputproto randrproto libX11 xorgserver xproto ];
  })) // {inherit inputproto randrproto libX11 xorgserver xproto ;};

  xf86inputvmmouse = (stdenv.mkDerivation ((if overrides ? xf86inputvmmouse then overrides.xf86inputvmmouse else x: x) {
    name = "xf86-input-vmmouse-12.5.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-vmmouse-12.5.1.tar.bz2;
      sha256 = "1yzwgc5cac60zmhsw1npgn81sl06qda80bd0p6nixw1qf6h8nq33";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86inputvoid = (stdenv.mkDerivation ((if overrides ? xf86inputvoid then overrides.xf86inputvoid else x: x) {
    name = "xf86-input-void-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-input-void-1.1.1.tar.bz2;
      sha256 = "0kxw5l0r4vp4xhfyb781lr9fmkjgv27yibhd3gaxjgvs4vb65q6x";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};

  xf86miscproto = (stdenv.mkDerivation ((if overrides ? xf86miscproto then overrides.xf86miscproto else x: x) {
    name = "xf86miscproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86miscproto-0.9.2.tar.bz2;
      sha256 = "1rnnv8vi5z457wl5j184qw1z3ai3mvbwssdshm3ysgf736zlraxa";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xf86videoapm = (stdenv.mkDerivation ((if overrides ? xf86videoapm then overrides.xf86videoapm else x: x) {
    name = "xf86-video-apm-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-apm-1.2.0.tar.bz2;
      sha256 = "11b119a07w947hasvpmpzwmnfchv58qqc329d9lklvifi47h5zph";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoark = (stdenv.mkDerivation ((if overrides ? xf86videoark then overrides.xf86videoark else x: x) {
    name = "xf86-video-ark-0.7.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-ark-0.7.0.tar.bz2;
      sha256 = "153mynydgb1sa9xn0dvm5ynbsilkl2x9aj3dbz0kggps8lqffrcf";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videoast = (stdenv.mkDerivation ((if overrides ? xf86videoast then overrides.xf86videoast else x: x) {
    name = "xf86-video-ast-0.85.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-ast-0.85.0.tar.bz2;
      sha256 = "0a2v91v61zn31ih0fizmsd3mz7f767xk7bbs0df8jvc6wj2gy64h";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoati = (stdenv.mkDerivation ((if overrides ? xf86videoati then overrides.xf86videoati else x: x) {
    name = "xf86-video-ati-6.12.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-ati-6.12.2.tar.bz2;
      sha256 = "0l17mv7ljw9cnvfblms62vnjkpd26gf5dqgdpfzvkxqrfyhvpvhv";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86videochips = (stdenv.mkDerivation ((if overrides ? xf86videochips then overrides.xf86videochips else x: x) {
    name = "xf86-video-chips-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-chips-1.2.0.tar.bz2;
      sha256 = "16ag3n052rj275q10sf7j9dz1nxq43szlf5pd3x6mqrvn94qrwq5";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videocirrus = (stdenv.mkDerivation ((if overrides ? xf86videocirrus then overrides.xf86videocirrus else x: x) {
    name = "xf86-video-cirrus-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-cirrus-1.2.1.tar.bz2;
      sha256 = "175vg2gi149awz6jfnj1d51yq3s3ka2pbn75ysnmzpr6cgb9xjg7";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videodummy = (stdenv.mkDerivation ((if overrides ? xf86videodummy then overrides.xf86videodummy else x: x) {
    name = "xf86-video-dummy-0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-dummy-0.3.0.tar.bz2;
      sha256 = "0y52605g48wqpp138is2wfckdgk4w7v5x7hm7fv4nczhnzhbsjss";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};

  xf86videofbdev = (stdenv.mkDerivation ((if overrides ? xf86videofbdev then overrides.xf86videofbdev else x: x) {
    name = "xf86-video-fbdev-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-fbdev-0.4.0.tar.bz2;
      sha256 = "179mmh0dzsq1y5i9y7sqr162r9wamslmaa5rya1knc9axgd2b9xv";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};

  xf86videogeode = (stdenv.mkDerivation ((if overrides ? xf86videogeode then overrides.xf86videogeode else x: x) {
    name = "xf86-video-geode-2.10.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-geode-2.10.1.tar.bz2;
      sha256 = "0l66m0cc2ywwsgbx844gfdywc141gdjzyvpknavw3qh2whcghvlv";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videoglide = (stdenv.mkDerivation ((if overrides ? xf86videoglide then overrides.xf86videoglide else x: x) {
    name = "xf86-video-glide-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-glide-1.0.1.tar.bz2;
      sha256 = "1cv4bwgbv37c0b1nm45pkmfjz07aj01qym2yw1r39z6qxja6hqrb";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};

  xf86videoglint = (stdenv.mkDerivation ((if overrides ? xf86videoglint then overrides.xf86videoglint else x: x) {
    name = "xf86-video-glint-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-glint-1.2.1.tar.bz2;
      sha256 = "1nhwpv37h5790j3a08frwpy9m9p77376393w06i4h1bx2b9805qn";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};

  xf86videoi128 = (stdenv.mkDerivation ((if overrides ? xf86videoi128 then overrides.xf86videoi128 else x: x) {
    name = "xf86-video-i128-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-i128-1.3.1.tar.bz2;
      sha256 = "0xcspy2r8fy8daq47m1w3jrg92210x5m6gyjs1scvsslari27fs9";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoi740 = (stdenv.mkDerivation ((if overrides ? xf86videoi740 then overrides.xf86videoi740 else x: x) {
    name = "xf86-video-i740-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-i740-1.2.0.tar.bz2;
      sha256 = "0vs831gnbfvlyqlxrmanjvdfy653460zzgr03hy07vsv8vpgdj2r";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoimpact = (stdenv.mkDerivation ((if overrides ? xf86videoimpact then overrides.xf86videoimpact else x: x) {
    name = "xf86-video-impact-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-impact-0.2.0.tar.bz2;
      sha256 = "08h007qrz4k7pi6gcwfa5h35yfc6c18c6dwfxc32bx0vnhis2a0m";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};

  xf86videointel = (stdenv.mkDerivation ((if overrides ? xf86videointel then overrides.xf86videointel else x: x) {
    name = "xf86-video-intel-2.7.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.7.1.tar.bz2;
      sha256 = "0hjziri3rkq7dbcqx70knbx9bips44ya8m1jfhpi7h4w4ia0sp15";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm libpciaccess randrproto renderproto libX11 libXext xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ];
  })) // {inherit fontsproto glproto libdrm libpciaccess randrproto renderproto libX11 libXext xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ;};

  xf86videomach64 = (stdenv.mkDerivation ((if overrides ? xf86videomach64 then overrides.xf86videomach64 else x: x) {
    name = "xf86-video-mach64-6.8.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-mach64-6.8.0.tar.bz2;
      sha256 = "18g1hk9nq0zlinhw4vz3i9lhh9nql0w5x5lh1bh5j5rmipw1d9pv";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};

  xf86videomga = (stdenv.mkDerivation ((if overrides ? xf86videomga then overrides.xf86videomga else x: x) {
    name = "xf86-video-mga-1.4.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-mga-1.4.9.tar.bz2;
      sha256 = "1h7xs340q9vzdb6ck2z9c9fnxx3nfpxk58k7444n9w2j60rd4zfm";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videoneomagic = (stdenv.mkDerivation ((if overrides ? xf86videoneomagic then overrides.xf86videoneomagic else x: x) {
    name = "xf86-video-neomagic-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-neomagic-1.2.1.tar.bz2;
      sha256 = "19g08nw8crbhkcm50i4n0vwkdhrazwilfp3kdkvp8qarg19qvqwn";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videonewport = (stdenv.mkDerivation ((if overrides ? xf86videonewport then overrides.xf86videonewport else x: x) {
    name = "xf86-video-newport-0.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-newport-0.2.1.tar.bz2;
      sha256 = "026fn4c760rr03i2r9pq824k31nxq5nq0xq582bgh3k9a9a8bb36";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};

  xf86videonv = (stdenv.mkDerivation ((if overrides ? xf86videonv then overrides.xf86videonv else x: x) {
    name = "xf86-video-nv-2.1.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-nv-2.1.12.tar.bz2;
      sha256 = "07h1aih3gy9vpfqhs2wi1xjjk8jkijc31p3a7kfnjhvc5ys2nvgm";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videoopenchrome = (stdenv.mkDerivation ((if overrides ? xf86videoopenchrome then overrides.xf86videoopenchrome else x: x) {
    name = "xf86-video-openchrome-0.2.903";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-openchrome-0.2.903.tar.bz2;
      sha256 = "043lvcvdkhyb5jp2m0ggd0r0gxndjwh2qnj8wbx2hr2wdf6qbr5p";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ;};

  xf86videor128 = (stdenv.mkDerivation ((if overrides ? xf86videor128 then overrides.xf86videor128 else x: x) {
    name = "xf86-video-r128-6.8.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-r128-6.8.0.tar.bz2;
      sha256 = "0ysnarxh4qz9hjk9zcgzb01w9whfgaq86a71prr9577f9xqwm2an";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};

  xf86videorendition = (stdenv.mkDerivation ((if overrides ? xf86videorendition then overrides.xf86videorendition else x: x) {
    name = "xf86-video-rendition-4.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-rendition-4.2.0.tar.bz2;
      sha256 = "05dfm9zlqnm89xmnx98rf3yrqi0i6frk23hpk6kk8xfq0zvn4yxm";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videos3 = (stdenv.mkDerivation ((if overrides ? xf86videos3 then overrides.xf86videos3 else x: x) {
    name = "xf86-video-s3-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-s3-0.6.0.tar.bz2;
      sha256 = "0ry0ys83vzwkg9rwg2yc0zflkmkiz54kny33spfmyh0gidjf81zd";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videos3virge = (stdenv.mkDerivation ((if overrides ? xf86videos3virge then overrides.xf86videos3virge else x: x) {
    name = "xf86-video-s3virge-1.10.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-s3virge-1.10.1.tar.bz2;
      sha256 = "12lp988y1gqgs3imj44vjm8wf9y7grqk4ww8rxbwjwzg45b1354h";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videosavage = (stdenv.mkDerivation ((if overrides ? xf86videosavage then overrides.xf86videosavage else x: x) {
    name = "xf86-video-savage-2.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-savage-2.2.1.tar.bz2;
      sha256 = "0zm3v0v2qbwldns6lvvhn4mhdvvf91hrwk0wqlk27xxs1yp5rydd";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videosiliconmotion = (stdenv.mkDerivation ((if overrides ? xf86videosiliconmotion then overrides.xf86videosiliconmotion else x: x) {
    name = "xf86-video-siliconmotion-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-siliconmotion-1.6.0.tar.bz2;
      sha256 = "0lvy05jhj2csrn36hvffzzll63bk706mgf090mvs1fddqswh2lyc";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videosis = (stdenv.mkDerivation ((if overrides ? xf86videosis then overrides.xf86videosis else x: x) {
    name = "xf86-video-sis-0.10.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-sis-0.10.0.tar.bz2;
      sha256 = "0h2b1qk65mzahwir12b20rq16ayivhlsvq3n0r8c5726bpgdrh5w";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};

  xf86videosisusb = (stdenv.mkDerivation ((if overrides ? xf86videosisusb then overrides.xf86videosisusb else x: x) {
    name = "xf86-video-sisusb-0.9.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-sisusb-0.9.0.tar.bz2;
      sha256 = "02lk6x8xf53p69kdzjwxkb9szi1n16znji9mwpibhd9vgndrrdvn";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ;};

  xf86videosunbw2 = (stdenv.mkDerivation ((if overrides ? xf86videosunbw2 then overrides.xf86videosunbw2 else x: x) {
    name = "xf86-video-sunbw2-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-sunbw2-1.1.0.tar.bz2;
      sha256 = "0dl16ccbzzy0dchxzv4g7qjc59a2875c4lb68yn733xd87lp846p";
    };
    buildInputs = [pkgconfig randrproto xorgserver xproto ];
  })) // {inherit randrproto xorgserver xproto ;};

  xf86videosuncg14 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg14 then overrides.xf86videosuncg14 else x: x) {
    name = "xf86-video-suncg14-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-suncg14-1.1.0.tar.bz2;
      sha256 = "09q5wjay9mn9msskawv4i5in3chqwv1a0qp4z54xn9g7f04jpjhy";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosuncg3 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg3 then overrides.xf86videosuncg3 else x: x) {
    name = "xf86-video-suncg3-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-suncg3-1.1.0.tar.bz2;
      sha256 = "1ybxqf8z8q3r12s6pm1ygv0wffp9h7c6d4am8qnqgsnzrk4fnr1m";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosuncg6 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg6 then overrides.xf86videosuncg6 else x: x) {
    name = "xf86-video-suncg6-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-suncg6-1.1.0.tar.bz2;
      sha256 = "0jqr6xjs6i8lb40qyiqnyrfzmy9ch53jhjr0w20m5vspkjvz7cfn";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosunffb = (stdenv.mkDerivation ((if overrides ? xf86videosunffb then overrides.xf86videosunffb else x: x) {
    name = "xf86-video-sunffb-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-sunffb-1.2.0.tar.bz2;
      sha256 = "14lj0myf4dbd8c02qwgli6lj7rwlhv2q2d3krsqdd94r4gygiwjr";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ;};

  xf86videosunleo = (stdenv.mkDerivation ((if overrides ? xf86videosunleo then overrides.xf86videosunleo else x: x) {
    name = "xf86-video-sunleo-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-sunleo-1.2.0.tar.bz2;
      sha256 = "01kffjbshmwix2cdb95j0cx2qmrss6yfjj7y5qssw83h36bvw5dk";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videosuntcx = (stdenv.mkDerivation ((if overrides ? xf86videosuntcx then overrides.xf86videosuntcx else x: x) {
    name = "xf86-video-suntcx-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-suntcx-1.1.0.tar.bz2;
      sha256 = "1kq1gg273x460rin8gh5spl7yhyv23b4795by46zcimph4wnm63j";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};

  xf86videotdfx = (stdenv.mkDerivation ((if overrides ? xf86videotdfx then overrides.xf86videotdfx else x: x) {
    name = "xf86-video-tdfx-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-tdfx-1.4.0.tar.bz2;
      sha256 = "1bfy02461j3r48b1xf5vbpkgncha33bi0fr43z79xr7j4k9hdgn3";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86videotga = (stdenv.mkDerivation ((if overrides ? xf86videotga then overrides.xf86videotga else x: x) {
    name = "xf86-video-tga-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-tga-1.2.0.tar.bz2;
      sha256 = "19mfy468brrp75gy3y0bnyq1jmqdllq9z6kicpj8nc911snqqbx9";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videotrident = (stdenv.mkDerivation ((if overrides ? xf86videotrident then overrides.xf86videotrident else x: x) {
    name = "xf86-video-trident-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-trident-1.3.0.tar.bz2;
      sha256 = "1dfxscqv03b65p6jq2lzzyq3ihyx26i85rqh3wn3rsgn8sgnrxm4";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videotseng = (stdenv.mkDerivation ((if overrides ? xf86videotseng then overrides.xf86videotseng else x: x) {
    name = "xf86-video-tseng-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-tseng-1.2.0.tar.bz2;
      sha256 = "1qxi325a4cr8bjhnw6c3pb960kxcl1k0q39kmh090cil148dk40h";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};

  xf86videov4l = (stdenv.mkDerivation ((if overrides ? xf86videov4l then overrides.xf86videov4l else x: x) {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  })) // {inherit randrproto videoproto xorgserver xproto ;};

  xf86videovermilion = (stdenv.mkDerivation ((if overrides ? xf86videovermilion then overrides.xf86videovermilion else x: x) {
    name = "xf86-video-vermilion-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-vermilion-1.0.1.tar.bz2;
      sha256 = "12qdk0p2r0pbmsl8fkgwhfh7szvb20yjaay88jlvb89rsbc4rssg";
    };
    buildInputs = [pkgconfig fontsproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto renderproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videovesa = (stdenv.mkDerivation ((if overrides ? xf86videovesa then overrides.xf86videovesa else x: x) {
    name = "xf86-video-vesa-2.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vesa-2.2.0.tar.bz2;
      sha256 = "09h2x02h05skg9mhknhla2xpzz1igym4gimiswrj0wil4myhfglb";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};

  xf86videovmware = (stdenv.mkDerivation ((if overrides ? xf86videovmware then overrides.xf86videovmware else x: x) {
    name = "xf86-video-vmware-10.16.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-vmware-10.16.5.tar.bz2;
      sha256 = "0rj32zsn8p61vxg01rzgvnjby4xpjg6cmxiy11v61cq6v2zrlkiy";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ;};

  xf86videovoodoo = (stdenv.mkDerivation ((if overrides ? xf86videovoodoo then overrides.xf86videovoodoo else x: x) {
    name = "xf86-video-voodoo-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-voodoo-1.2.0.tar.bz2;
      sha256 = "132bgkj2jans4psp0pw4326dgwj7dx9prqwb1z07019hskasd6xp";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};

  xf86videowsfb = (stdenv.mkDerivation ((if overrides ? xf86videowsfb then overrides.xf86videowsfb else x: x) {
    name = "xf86-video-wsfb-0.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-wsfb-0.2.1.tar.bz2;
      sha256 = "0j6ij0yzz7car00x8h3xpmz2s86apvkvk0lcl9hzaffr2ym5iqrr";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};

  xf86videoxgi = (stdenv.mkDerivation ((if overrides ? xf86videoxgi then overrides.xf86videoxgi else x: x) {
    name = "xf86-video-xgi-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-xgi-1.5.0.tar.bz2;
      sha256 = "154ilsc7vaphfh5ab5iy27pwdswbynsshkblji2c0h49xqr39cjz";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};

  xf86videoxgixp = (stdenv.mkDerivation ((if overrides ? xf86videoxgixp then overrides.xf86videoxgixp else x: x) {
    name = "xf86-video-xgixp-1.7.99.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86-video-xgixp-1.7.99.3.tar.bz2;
      sha256 = "1n5v9wcdfp3k3r1xhicg2cw0xr73y3wciagpif7apl7awf76b88k";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};

  xf86vidmodeproto = (stdenv.mkDerivation ((if overrides ? xf86vidmodeproto then overrides.xf86vidmodeproto else x: x) {
    name = "xf86vidmodeproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xf86vidmodeproto-2.2.2.tar.bz2;
      sha256 = "0vnrqhzrsyjh77zgrxlgx53r34dij15crpl9369wb7n71jcjy587";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xfs = (stdenv.mkDerivation ((if overrides ? xfs then overrides.xfs else x: x) {
    name = "xfs-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.0.8.tar.bz2;
      sha256 = "10plnkkblkzrvnxszkvpbpm1fwjvrqkgjipsrp0jymdp7l5h9d9l";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  })) // {inherit libFS libXfont xtrans ;};

  xgamma = (stdenv.mkDerivation ((if overrides ? xgamma then overrides.xgamma else x: x) {
    name = "xgamma-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xgamma-1.0.2.tar.bz2;
      sha256 = "07plrky99vwp13463zbp2fqmyfqkvmxc2ra8iypfy2n61wimngax";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  })) // {inherit libX11 libXxf86vm ;};

  xhost = (stdenv.mkDerivation ((if overrides ? xhost then overrides.xhost else x: x) {
    name = "xhost-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xhost-1.0.2.tar.bz2;
      sha256 = "1dhdm6dz2jcnb08qlrjn2g1mzv3gfbyq6yqg9kjmh3r3kp22razd";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  })) // {inherit libX11 libXau libXmu ;};

  xineramaproto = (stdenv.mkDerivation ((if overrides ? xineramaproto then overrides.xineramaproto else x: x) {
    name = "xineramaproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xineramaproto-1.1.2.tar.bz2;
      sha256 = "0409qj8wdl1c3jchrqvdkl63s8r08gni4xhlxngkpz5wmwf2p9p8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xinput = (stdenv.mkDerivation ((if overrides ? xinput then overrides.xinput else x: x) {
    name = "xinput-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xinput-1.3.0.tar.bz2;
      sha256 = "0i9fh3flmigv7smfg879969kckw0c1h4ab0n3h9mdwmbi18kw31k";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi ];
  })) // {inherit inputproto libX11 libXext libXi ;};

  xkbcomp = (stdenv.mkDerivation ((if overrides ? xkbcomp then overrides.xkbcomp else x: x) {
    name = "xkbcomp-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xkbcomp-1.0.5.tar.bz2;
      sha256 = "1h809xl9kpx0r9ynvjfk7wy6rx8pgl1i14qh29r150wf73h06i10";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};

  xkbevd = (stdenv.mkDerivation ((if overrides ? xkbevd then overrides.xkbevd else x: x) {
    name = "xkbevd-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xkbevd-1.0.2.tar.bz2;
      sha256 = "0azpl6mcvsi718630vv0slls8avixvlsfd7nj614kagrxhbf6y2b";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};

  xkbutils = (stdenv.mkDerivation ((if overrides ? xkbutils then overrides.xkbutils else x: x) {
    name = "xkbutils-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xkbutils-1.0.1.tar.bz2;
      sha256 = "0mjq2yfd1kp3gasc08k6r0q16k4asdsafsxw3259fr5pipnp7bda";
    };
    buildInputs = [pkgconfig libXaw libX11 libxkbfile ];
  })) // {inherit libXaw libX11 libxkbfile ;};

  xkill = (stdenv.mkDerivation ((if overrides ? xkill then overrides.xkill else x: x) {
    name = "xkill-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xkill-1.0.1.tar.bz2;
      sha256 = "1pm92hpq1vnj3zjl12x8d9g6a9nyfyz3ahvvicni7qjadsn1m8bp";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xlsatoms = (stdenv.mkDerivation ((if overrides ? xlsatoms then overrides.xlsatoms else x: x) {
    name = "xlsatoms-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xlsatoms-1.0.1.tar.bz2;
      sha256 = "0nnm2ss1v93wz4jmlvhgxfsrxkx39g9km2jp2nagqdyv1id5fva5";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xlsclients = (stdenv.mkDerivation ((if overrides ? xlsclients then overrides.xlsclients else x: x) {
    name = "xlsclients-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xlsclients-1.0.1.tar.bz2;
      sha256 = "160nk39dj9h5laxd0gbq7jl47y4ikpjf6kl4wlzm469mvk37334q";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xmessage = (stdenv.mkDerivation ((if overrides ? xmessage then overrides.xmessage else x: x) {
    name = "xmessage-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xmessage-1.0.2.tar.bz2;
      sha256 = "1hy3n227iyrm323hnrdld8knj9h82fz6s7x6bw899axcjdp03d02";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  })) // {inherit libXaw libXt ;};

  xmodmap = (stdenv.mkDerivation ((if overrides ? xmodmap then overrides.xmodmap else x: x) {
    name = "xmodmap-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xmodmap-1.0.3.tar.bz2;
      sha256 = "0zql66q2l8wbldfrzz53vlxpv7p62yhfj6lc2cn24n18g4jcggy3";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xorgcffiles = (stdenv.mkDerivation ((if overrides ? xorgcffiles then overrides.xorgcffiles else x: x) {
    name = "xorg-cf-files-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.2.tar.bz2;
      sha256 = "15wmz9whf0j9irz5scqyyic4ardr53r6k15x2wcnxmfkqap16ip3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xorgdocs = (stdenv.mkDerivation ((if overrides ? xorgdocs then overrides.xorgdocs else x: x) {
    name = "xorg-docs-1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xorg-docs-1.4.tar.bz2;
      sha256 = "09a9va5nljg0cahajadpkkqbhm0r6nl2z12yv7fyd5p31kjngz7z";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xorgserver = (stdenv.mkDerivation ((if overrides ? xorgserver then overrides.xorgserver else x: x) {
    name = "xorg-server-1.5.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.5.3.tar.bz2;
      sha256 = "1fymhb0v83hmbka1sdg9z2vfkjagskawaxajks0n6xxyai7ig056";
    };
    buildInputs = [pkgconfig renderproto bigreqsproto compositeproto damageproto dbus libdmx dmxproto dri2proto evieext fixesproto fontcacheproto libfontenc fontsproto freetype mesa glproto hal inputproto kbproto libdrm mkfontdir mkfontscale openssl libpciaccess perl pixman printproto randrproto recordproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXv libXxf86misc libXxf86vm ];
  })) // {inherit renderproto bigreqsproto compositeproto damageproto dbus libdmx dmxproto dri2proto evieext fixesproto fontcacheproto libfontenc fontsproto freetype mesa glproto hal inputproto kbproto libdrm mkfontdir mkfontscale openssl libpciaccess perl pixman printproto randrproto recordproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXv libXxf86misc libXxf86vm ;};

  xorgsgmldoctools = (stdenv.mkDerivation ((if overrides ? xorgsgmldoctools then overrides.xorgsgmldoctools else x: x) {
    name = "xorg-sgml-doctools-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xorg-sgml-doctools-1.2.tar.bz2;
      sha256 = "1snvlijv7ycdis0m7zhl6q6ibg2z6as3mdb17dlza0p0w3r7ivsd";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xpr = (stdenv.mkDerivation ((if overrides ? xpr then overrides.xpr else x: x) {
    name = "xpr-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xpr-1.0.2.tar.bz2;
      sha256 = "1pwa4dcs7zw4iw52p23swnnq1idipfiadhpih6k47nhwdn4sj9f3";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xprop = (stdenv.mkDerivation ((if overrides ? xprop then overrides.xprop else x: x) {
    name = "xprop-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xprop-1.0.4.tar.bz2;
      sha256 = "0wnpbigsl5frbh2xnjzdxmvlz47lda5qlg85pnhrr4asgnx7r96s";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xproto = (stdenv.mkDerivation ((if overrides ? xproto then overrides.xproto else x: x) {
    name = "xproto-7.0.15";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xproto-7.0.15.tar.bz2;
      sha256 = "1vkbqy2vs0jf1z043fyjw1345rmh16lxzvgrd9p43mwl7syd137x";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xrandr = (stdenv.mkDerivation ((if overrides ? xrandr then overrides.xrandr else x: x) {
    name = "xrandr-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xrandr-1.2.3.tar.bz2;
      sha256 = "01r22ngikdsfkv1sxc2f8a0lcr5c08krsvq9kqknd21b79zvf1mb";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  })) // {inherit libX11 libXrandr libXrender ;};

  xrdb = (stdenv.mkDerivation ((if overrides ? xrdb then overrides.xrdb else x: x) {
    name = "xrdb-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xrdb-1.0.5.tar.bz2;
      sha256 = "1ah00m82pc8yv5knp8szqnlip450pw3lg60vzlw05wahja9hhkf2";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};

  xrefresh = (stdenv.mkDerivation ((if overrides ? xrefresh then overrides.xrefresh else x: x) {
    name = "xrefresh-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xrefresh-1.0.2.tar.bz2;
      sha256 = "1x9jdgwbd1ying44apk718h1ycbfx411p81mjzr51cn057yk2a2j";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xset = (stdenv.mkDerivation ((if overrides ? xset then overrides.xset else x: x) {
    name = "xset-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xset-1.0.4.tar.bz2;
      sha256 = "1bdxs24pf7g73n55a967fr96f9i5ilci5nzh32wr5axy6sxp8gkc";
    };
    buildInputs = [pkgconfig libX11 libXext libXfontcache libXmu libXp libXxf86misc ];
  })) // {inherit libX11 libXext libXfontcache libXmu libXp libXxf86misc ;};

  xsetmode = (stdenv.mkDerivation ((if overrides ? xsetmode then overrides.xsetmode else x: x) {
    name = "xsetmode-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xsetmode-1.0.0.tar.bz2;
      sha256 = "1am0mylym97m79n54jvlc45njxdchv1mvqdwmpkcd499jb6lg2wq";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  })) // {inherit libX11 libXi ;};

  xsetroot = (stdenv.mkDerivation ((if overrides ? xsetroot then overrides.xsetroot else x: x) {
    name = "xsetroot-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xsetroot-1.0.2.tar.bz2;
      sha256 = "079mld5c05dx2xwhncc94xhrkp4n9388xdncx3x7km1h90gpb6jg";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXmu ];
  })) // {inherit libX11 xbitmaps libXmu ;};

  xtrans = (stdenv.mkDerivation ((if overrides ? xtrans then overrides.xtrans else x: x) {
    name = "xtrans-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xtrans-1.2.1.tar.bz2;
      sha256 = "1gb4vyh6b4lybacvipjyqfqj1jxl4bav9mmngjdwl955ks6imwlz";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};

  xvinfo = (stdenv.mkDerivation ((if overrides ? xvinfo then overrides.xvinfo else x: x) {
    name = "xvinfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xvinfo-1.0.2.tar.bz2;
      sha256 = "0l7i9h3r0lzb6kmmcp751i92xml84rhzmz04i5lgj8y759hjlvhj";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  })) // {inherit libX11 libXv ;};

  xwd = (stdenv.mkDerivation ((if overrides ? xwd then overrides.xwd else x: x) {
    name = "xwd-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xwd-1.0.2.tar.bz2;
      sha256 = "0qbz63lwdp7c8x0rbafamlja7pk3ahhmcim5cnd7m5f123h792db";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

  xwininfo = (stdenv.mkDerivation ((if overrides ? xwininfo then overrides.xwininfo else x: x) {
    name = "xwininfo-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xwininfo-1.0.4.tar.bz2;
      sha256 = "1r4f898f6xydg02n1m37qgibh49bffn0fwdxwww37k9jhrw556nz";
    };
    buildInputs = [pkgconfig libX11 libXext ];
  })) // {inherit libX11 libXext ;};

  xwud = (stdenv.mkDerivation ((if overrides ? xwud then overrides.xwud else x: x) {
    name = "xwud-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.4/src/everything/xwud-1.0.1.tar.bz2;
      sha256 = "0v1kjdn5y7dh3fcp46z1m90i9d3xx1k1y4rdr6nj77j7nhwjvpnj";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};

}; in xorg
