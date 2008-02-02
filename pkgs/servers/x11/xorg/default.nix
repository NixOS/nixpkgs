# This is a generated file.  Do not edit!
args: with args;

rec {

  applewmproto = (stdenv.mkDerivation {
    name = "applewmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/applewmproto-1.0.3.tar.bz2;
      sha256 = "0l2d3wmgprs5gl479ba2yw9vj1q3m8rhri82k0vryd9ildzc0f59";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  appres = (stdenv.mkDerivation {
    name = "appres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/appres-1.0.1.tar.bz2;
      sha256 = "0qmr5sdbj4alzf3p8lxb8348y7zdmsjdp20c8biwx39b40xgizhm";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  }) // {inherit libX11 libXt ;};
    
  bdftopcf = (stdenv.mkDerivation {
    name = "bdftopcf-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/bdftopcf-1.0.1.tar.bz2;
      sha256 = "1lq5x0kvgwlzdgfhi8sbbchzd1y1nmzdqgq9laysx08p6smlbama";
    };
    buildInputs = [pkgconfig libXfont ];
  }) // {inherit libXfont ;};
    
  beforelight = (stdenv.mkDerivation {
    name = "beforelight-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/beforelight-1.0.2.tar.bz2;
      sha256 = "19s7n2rpq44mrqd3gd6nh4wql4dg41w02j6r9zh9yxwkkiaigqh0";
    };
    buildInputs = [pkgconfig libX11 libXaw libXScrnSaver libXt ];
  }) // {inherit libX11 libXaw libXScrnSaver libXt ;};
    
  bigreqsproto = (stdenv.mkDerivation {
    name = "bigreqsproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/bigreqsproto-1.0.2.tar.bz2;
      sha256 = "1vmda2412s5yvawx2xplrbzcghnmqin54r1l352ycy25lac01nih";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  bitmap = (stdenv.mkDerivation {
    name = "bitmap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/bitmap-1.0.2.tar.bz2;
      sha256 = "1g0l9ip2yabz056aq58ijnf2xfnga9d15pmd7hpg82a3mhkrjwc3";
    };
    buildInputs = [pkgconfig libXaw libX11 xbitmaps libXmu libXt ];
  }) // {inherit libXaw libX11 xbitmaps libXmu libXt ;};
    
  compositeproto = (stdenv.mkDerivation {
    name = "compositeproto-0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/compositeproto-0.4.tar.bz2;
      sha256 = "00q0wc8skfjy7c9dzngvmi99i29bh68715wrdw7m9dxjcg5d24v0";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  damageproto = (stdenv.mkDerivation {
    name = "damageproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/damageproto-1.1.0.tar.bz2;
      sha256 = "07b41ninycfm5sgzpjsa168dnm1g55c2mzzgigvwvs9mr3x889lx";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  dmxproto = (stdenv.mkDerivation {
    name = "dmxproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/dmxproto-2.2.2.tar.bz2;
      sha256 = "1qpw6lp4925zwmkp48b6wsy84d21872i6x2dr8rzfn7csp4xk9ma";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  editres = (stdenv.mkDerivation {
    name = "editres-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/editres-1.0.2.tar.bz2;
      sha256 = "1pv7q44kzipjn735lhrbiyg3kmx3jhsfkjb3yfjshggg9q9vr3wp";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  encodings = (stdenv.mkDerivation {
    name = "encodings-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/encodings-1.0.2.tar.bz2;
      sha256 = "1b2fdxfvqb0gbg4pz8anp9rwnbg2xj3d4b8cbc46rjdvcrxi06bd";
    };
    buildInputs = [pkgconfig mkfontscale ];
  }) // {inherit mkfontscale ;};
    
  evieext = (stdenv.mkDerivation {
    name = "evieext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/evieext-1.0.2.tar.bz2;
      sha256 = "09fijha8ac0iw7lbc75912jwhm5k19ypm73zj8akf23hjwx1318b";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fixesproto = (stdenv.mkDerivation {
    name = "fixesproto-4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fixesproto-4.0.tar.bz2;
      sha256 = "13xhrva17vcg1zdz6kba5g5jzkf43z1ifwfsg1ndnll1rhf9gzmk";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontadobe100dpi = (stdenv.mkDerivation {
    name = "font-adobe-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-adobe-100dpi-1.0.0.tar.bz2;
      sha256 = "06cs5q4hy255i5b64q0cgcapv46kgc315b7jmwjs5j952qx1nv7i";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobe75dpi = (stdenv.mkDerivation {
    name = "font-adobe-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-adobe-75dpi-1.0.0.tar.bz2;
      sha256 = "0fb32yyqf4mf93bn9a0qbzm9zbl3sxkhc0ipy9az7r7mw2z4a9yn";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopia100dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-adobe-utopia-100dpi-1.0.1.tar.bz2;
      sha256 = "1zmmm430rwgv0cr80ybl6bk9qzr697lwh253qwxv2sf1f2mf2hqr";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopia75dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-adobe-utopia-75dpi-1.0.1.tar.bz2;
      sha256 = "12bhr82dsd9iz50kszppghf22fpyjcadrxd0plxpwwmw9ccy5m7b";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopiatype1 = (stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-adobe-utopia-type1-1.0.1.tar.bz2;
      sha256 = "1p604j44vqfp7iv4a7p38vi6d1qk26grmnkdsz1dapr7zz475ip9";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontalias = (stdenv.mkDerivation {
    name = "font-alias-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-alias-1.0.1.tar.bz2;
      sha256 = "1dl99xmdbgwssd4zgnipc4b4l5g9s2qc08wx29bdif946bb61nvp";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontarabicmisc = (stdenv.mkDerivation {
    name = "font-arabic-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-arabic-misc-1.0.0.tar.bz2;
      sha256 = "155wyy6vsxha3lx9cvw22pscsdc3iljsgyh6zqpyl19qyfixzsch";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbh100dpi = (stdenv.mkDerivation {
    name = "font-bh-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-100dpi-1.0.0.tar.bz2;
      sha256 = "0jpfrxwdx24ib784j6k6qbi6zvy6svyva6gda8pj98krfmvi32mf";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbh75dpi = (stdenv.mkDerivation {
    name = "font-bh-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-75dpi-1.0.0.tar.bz2;
      sha256 = "1gq55j00g7fqnypxy6f0wvhz5l16056sdysmbp3qk4yc82s6g567";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-lucidatypewriter-100dpi-1.0.0.tar.bz2;
      sha256 = "04vh9mccnh517q42w65k89pz3jd6szim3hazydm7n0wilp5pvm1n";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-lucidatypewriter-75dpi-1.0.0.tar.bz2;
      sha256 = "0im03ms6bx1947fkdarrdzzm8lq69pz5502n89cccj9sadpz7wjh";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhttf = (stdenv.mkDerivation {
    name = "font-bh-ttf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-ttf-1.0.0.tar.bz2;
      sha256 = "0i6nsw1i43ydljws2xzadvbmxs1p50jn9akhinwrh8z4yxr5w6ks";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontbhtype1 = (stdenv.mkDerivation {
    name = "font-bh-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bh-type1-1.0.0.tar.bz2;
      sha256 = "0nv4qdr8z68iczqic4gj492ln6y1xy04kxx08dhdaaf8y89mb2js";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontbitstream100dpi = (stdenv.mkDerivation {
    name = "font-bitstream-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bitstream-100dpi-1.0.0.tar.bz2;
      sha256 = "1lp260dwrrr4ll9rbdq38cnvlxq843q34rxay6hl2bmmsxs5lw0c";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbitstream75dpi = (stdenv.mkDerivation {
    name = "font-bitstream-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bitstream-75dpi-1.0.0.tar.bz2;
      sha256 = "1yqv42gf4ksr5fr0b2szwfc8cczis0pppcsg1wdlwllprb6fmprd";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbitstreamspeedo = (stdenv.mkDerivation {
    name = "font-bitstream-speedo-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bitstream-speedo-1.0.0.tar.bz2;
      sha256 = "1rpn2j99cg5dnw3mjzff65darwaz5jwjgi7i0xscq064d9w03b4r";
    };
    buildInputs = [pkgconfig mkfontdir ];
  }) // {inherit mkfontdir ;};
    
  fontbitstreamtype1 = (stdenv.mkDerivation {
    name = "font-bitstream-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-bitstream-type1-1.0.0.tar.bz2;
      sha256 = "00yrahjc884mghhbm713c41x7r2kbg1ply515qs3g20nrwnlkkjg";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontcacheproto = (stdenv.mkDerivation {
    name = "fontcacheproto-0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fontcacheproto-0.1.2.tar.bz2;
      sha256 = "1yfrldprqbxv587zd9lvsn2ayfdabzkgzya5cqvjf290kga3w1j8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontcronyxcyrillic = (stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-cronyx-cyrillic-1.0.0.tar.bz2;
      sha256 = "1vl4yk3sdvcqpym4d4r3lxrpyghxgjpq8yx2kdxygjpm6dq4xj86";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontcursormisc = (stdenv.mkDerivation {
    name = "font-cursor-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-cursor-misc-1.0.0.tar.bz2;
      sha256 = "1igklmxc0bgbp5a2nbmbwii5d9mh71zsxay2sw0sa6sq2xqy4pcm";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontdaewoomisc = (stdenv.mkDerivation {
    name = "font-daewoo-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-daewoo-misc-1.0.0.tar.bz2;
      sha256 = "09l98sd8wwdhgjdafq8cr6ykki4imh5qi21jwaqkhfil5v4ym67i";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontdecmisc = (stdenv.mkDerivation {
    name = "font-dec-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-dec-misc-1.0.0.tar.bz2;
      sha256 = "1fcbnv0zlbzsn68z5as0k3id83ii9k67l6bxiv2ypcfs4l96sf43";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontibmtype1 = (stdenv.mkDerivation {
    name = "font-ibm-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-ibm-type1-1.0.0.tar.bz2;
      sha256 = "07j6kk7wd0lbnjxn9a4kjahjniiwjyzc8lp1lvw46sahwg193l1h";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontisasmisc = (stdenv.mkDerivation {
    name = "font-isas-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-isas-misc-1.0.0.tar.bz2;
      sha256 = "18jfp92s6wmjs107rhdcz4acmzb2anhcb7s8bpd2kwhbrq9i7rlp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontjismisc = (stdenv.mkDerivation {
    name = "font-jis-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-jis-misc-1.0.0.tar.bz2;
      sha256 = "1fn75mqx6xjqffbd01a1wplc8cf7spwsrxv5h2accizw9zyyw89p";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmicromisc = (stdenv.mkDerivation {
    name = "font-micro-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-micro-misc-1.0.0.tar.bz2;
      sha256 = "0wm52zgbly62vsbr5c4wz9rh1vk4y1viyv09r20r6bp175cppc8n";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmisccyrillic = (stdenv.mkDerivation {
    name = "font-misc-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-misc-cyrillic-1.0.0.tar.bz2;
      sha256 = "1zwh69k7id17jabwia6x43f520lbf8787nf71vs3p78j089sq2vw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmiscethiopic = (stdenv.mkDerivation {
    name = "font-misc-ethiopic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-misc-ethiopic-1.0.0.tar.bz2;
      sha256 = "0hficywkkzl4dpws9sg47d3m1igpb7m4myw8zabkf1na0648dljq";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmeltho = (stdenv.mkDerivation {
    name = "font-misc-meltho-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-misc-meltho-1.0.0.tar.bz2;
      sha256 = "091ripcw30cs6032p12gwcy2hg8b1y24irgacwsky1dn4scjpqf7";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmisc = (stdenv.mkDerivation {
    name = "font-misc-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-misc-misc-1.0.0.tar.bz2;
      sha256 = "1nqp7zhwmrh6ng8j4i4pscqj2xhh57sdmrkbqgklh5hzmmh2b816";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; postInstall = "ln -s ${fontalias}/lib/X11/fonts/misc/fonts.alias $out/lib/X11/fonts/misc/fonts.alias"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontmuttmisc = (stdenv.mkDerivation {
    name = "font-mutt-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-mutt-misc-1.0.0.tar.bz2;
      sha256 = "1zzd3ba1i2ffqh8yyvyqyhcyxa7j474lb8x88b5cxf7js0xih6gj";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontschumachermisc = (stdenv.mkDerivation {
    name = "font-schumacher-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-schumacher-misc-1.0.0.tar.bz2;
      sha256 = "0ypgas5hjwaad53hfpx2w5s1scybh953vb94rrlmaix4hpw6qkj5";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontscreencyrillic = (stdenv.mkDerivation {
    name = "font-screen-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-screen-cyrillic-1.0.1.tar.bz2;
      sha256 = "07y52rm2m17ig6piynk9jgyhdv8a4s7jmn5ssa83a61a607mymyr";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontsonymisc = (stdenv.mkDerivation {
    name = "font-sony-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-sony-misc-1.0.0.tar.bz2;
      sha256 = "08rf8m9mqg9h0w67b5k55hs73v2s9lxz7aab0nq7rd90c3kkms8s";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontsproto = (stdenv.mkDerivation {
    name = "fontsproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fontsproto-2.0.2.tar.bz2;
      sha256 = "0ywb783l7gwypq5nchfmysra0n6dqv9hc3vsf4ra44da65qm9gc3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontsunmisc = (stdenv.mkDerivation {
    name = "font-sun-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-sun-misc-1.0.0.tar.bz2;
      sha256 = "1r99ayxfc1qqcg6zwfkkvbga3qwyf3h3xsh1ymw02zwf9n7jvh83";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fonttosfnt = (stdenv.mkDerivation {
    name = "fonttosfnt-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fonttosfnt-1.0.3.tar.bz2;
      sha256 = "0hsjzpj3hcmcm3qqlk7sz6c5x5zrdb002f2ndjmrg829x94h2awx";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto ];
  }) // {inherit libfontenc freetype xproto ;};
    
  fontutil = (stdenv.mkDerivation {
    name = "font-util-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-util-1.0.1.tar.bz2;
      sha256 = "04h6c24q08d8ljajxzlfwyr1fxfhb88b3w21nfmy6bm3gsqj7304";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontwinitzkicyrillic = (stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-winitzki-cyrillic-1.0.0.tar.bz2;
      sha256 = "1qzf9f1irn4difbz2s6j8yhn4hdg95j35q89nhss7rpwh5l7z2j7";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontxfree86type1 = (stdenv.mkDerivation {
    name = "font-xfree86-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/font-xfree86-type1-1.0.0.tar.bz2;
      sha256 = "0kaaz2vyff4x679d0mv1y0lc1gabml2mj7ncfgzsknhv3nwx6xpg";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fslsfonts = (stdenv.mkDerivation {
    name = "fslsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fslsfonts-1.0.1.tar.bz2;
      sha256 = "0bm6cgif31ghc04phxbiz5w2c5179gl9y9169s95cs7k4mm01srz";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  fstobdf = (stdenv.mkDerivation {
    name = "fstobdf-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/fstobdf-1.0.2.tar.bz2;
      sha256 = "08mcwxn8fgsa4ryv0qnn9dny28xl9rigi6mqv5nh75ndaar4a3k9";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  gccmakedep = (stdenv.mkDerivation {
    name = "gccmakedep-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/gccmakedep-1.0.2.tar.bz2;
      sha256 = "04dfamx3fvkvqfgs6xy2a6yqbxjrj4777ylxp38g60hhbdl4jg86";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  glproto = (stdenv.mkDerivation {
    name = "glproto-1.4.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/glproto-1.4.8.tar.bz2;
      sha256 = "0g05ixvi0nbpzgzhm0gpw6892jca23p6zij6pfvqidjk710q8p9g";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  iceauth = (stdenv.mkDerivation {
    name = "iceauth-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/iceauth-1.0.2.tar.bz2;
      sha256 = "1fxmpa9262b1iklxmy3ca72m34x11qixbqsm4b7w98jpvs8iah06";
    };
    buildInputs = [pkgconfig libICE xproto ];
  }) // {inherit libICE xproto ;};
    
  ico = (stdenv.mkDerivation {
    name = "ico-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/ico-1.0.2.tar.bz2;
      sha256 = "19ca471c4yscqi0babvp4zpfnz66lxcbgrwx3fwjkk1bibhrcbnv";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  imake = (stdenv.mkDerivation {
    name = "imake-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/imake-1.0.2.tar.bz2;
      sha256 = "0yxca3hbz4hfk0fm385lbm89061p2nksr5klx2y3x1knmvsgzklp";
    };
    buildInputs = [pkgconfig xproto ]; inherit xorgcffiles; x11BuildHook = ./imake.sh; patches = [./imake.patch]; 
  }) // {inherit xproto ;};
    
  inputproto = (stdenv.mkDerivation {
    name = "inputproto-1.4.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/inputproto-1.4.2.1.tar.bz2;
      sha256 = "1vgkmz6hdcj3r6pgbynkwlh5rg9mqjdvjqkql6wm4z6y6xqbfvcv";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  kbproto = (stdenv.mkDerivation {
    name = "kbproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/kbproto-1.0.3.tar.bz2;
      sha256 = "1pqrrsag6njdrxpx5sm48gh68w64fv5jpmvp2jkjhynhpdg0003h";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  lbxproxy = (stdenv.mkDerivation {
    name = "lbxproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/lbxproxy-1.0.1.tar.bz2;
      sha256 = "1hh1rb2cmfvsdd41n0k3wd2sz1cr7mm639ws57pd5994cyc5grz2";
    };
    buildInputs = [pkgconfig bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ];
  }) // {inherit bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ;};
    
  libAppleWM = (stdenv.mkDerivation {
    name = "libAppleWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libAppleWM-1.0.0.tar.bz2;
      sha256 = "0zj0n0ykv3zy68d23xyf2c58ddn5m78b8j1zcynb93j1g90gzlpc";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  }) // {inherit applewmproto libX11 libXext xextproto ;};
    
  libFS = (stdenv.mkDerivation {
    name = "libFS-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libFS-1.0.0.tar.bz2;
      sha256 = "1ppxrhqa2lx5am054iz1ckinwp2bsq585fjlq6rym8qq1vxgj61g";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  }) // {inherit fontsproto xproto xtrans ;};
    
  libICE = (stdenv.mkDerivation {
    name = "libICE-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libICE-1.0.4.tar.bz2;
      sha256 = "012ga4q5rxajnn3fd249xnirnvw6lms7jyp9bh9vsp349hpmw18k";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  }) // {inherit xproto xtrans ;};
    
  libSM = (stdenv.mkDerivation {
    name = "libSM-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libSM-1.0.3.tar.bz2;
      sha256 = "017cbndj3c4cr8x3phl5k0063ylhzxvjjdj8scn4bzpgawsjvx2p";
    };
    buildInputs = [pkgconfig libICE xproto xtrans ];
  }) // {inherit libICE xproto xtrans ;};
    
  libWindowsWM = (stdenv.mkDerivation {
    name = "libWindowsWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libWindowsWM-1.0.0.tar.bz2;
      sha256 = "0shnxkg9ghihgyrl3dzhqdcgssa7146dn1j51rzbl89x2xk75n3a";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  }) // {inherit windowswmproto libX11 libXext xextproto ;};
    
  libX11 = (stdenv.mkDerivation {
    name = "libX11-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libX11-1.1.3.tar.bz2;
      sha256 = "0ylip0df6hilh0yf5x2wzhj56wnx32fgmf2whxf9bpd55rp5cbsa";
    };
    buildInputs = [pkgconfig bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ];
  }) // {inherit bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ;};
    
  libXScrnSaver = (stdenv.mkDerivation {
    name = "libXScrnSaver-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXScrnSaver-1.1.2.tar.bz2;
      sha256 = "0ryckgkyx2zz4r5vvpja0p8h5bhkjq8wm9h84h60w1j6lyydwxbc";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  }) // {inherit scrnsaverproto libX11 libXext xextproto ;};
    
  libXTrap = (stdenv.mkDerivation {
    name = "libXTrap-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXTrap-1.0.0.tar.bz2;
      sha256 = "1filzv6z59rlrd0d8xglpr1r7ac1zr0jfn106yndwp5xfpk2rlfg";
    };
    buildInputs = [pkgconfig trapproto libX11 libXext xextproto libXt ];
  }) // {inherit trapproto libX11 libXext xextproto libXt ;};
    
  libXau = (stdenv.mkDerivation {
    name = "libXau-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXau-1.0.3.tar.bz2;
      sha256 = "0fwyq42q10k4cxar4nj73c7zd7jg6gh16zmxw2b0wwhafy40mhyn";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXaw = (stdenv.mkDerivation {
    name = "libXaw-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXaw-1.0.4.tar.bz2;
      sha256 = "1yaslcpj6sd6s8gx2hv60gfjf515gggd8f2jv4zqbp5q9wcapx0i";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ];
  }) // {inherit printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ;};
    
  libXcomposite = (stdenv.mkDerivation {
    name = "libXcomposite-0.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXcomposite-0.4.0.tar.bz2;
      sha256 = "043m7jhqzqfb02g29v8k57xxm4vqbw15gln4wja81xni5pl5kdvx";
    };
    buildInputs = [pkgconfig compositeproto fixesproto libX11 libXext libXfixes ];
  }) // {inherit compositeproto fixesproto libX11 libXext libXfixes ;};
    
  libXcursor = (stdenv.mkDerivation {
    name = "libXcursor-1.1.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXcursor-1.1.9.tar.bz2;
      sha256 = "1d6j2md25f6g45xjb2sqsqwvdidf9i3n3mb682bcxj3i49ab7zqx";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes libXrender ];
  }) // {inherit fixesproto libX11 libXfixes libXrender ;};
    
  libXdamage = (stdenv.mkDerivation {
    name = "libXdamage-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXdamage-1.0.4.tar.bz2;
      sha256 = "0dn64lv1nlc017nq11ixgafd15n8vw52p2knw7wxdqbpz870zyax";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes ];
  }) // {inherit damageproto fixesproto libX11 xextproto libXfixes ;};
    
  libXdmcp = (stdenv.mkDerivation {
    name = "libXdmcp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXdmcp-1.0.2.tar.bz2;
      sha256 = "1a4n1z0vfzw10pcj27g95rjn06c231cg38l44z14b4ar8wc0rrgk";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXevie = (stdenv.mkDerivation {
    name = "libXevie-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXevie-1.0.2.tar.bz2;
      sha256 = "1nkls60q0zmrlrxxy08h4jnsv3b9rgpmqwq6sar2v4s5s4dbhw7z";
    };
    buildInputs = [pkgconfig evieext libX11 libXext xextproto xproto ];
  }) // {inherit evieext libX11 libXext xextproto xproto ;};
    
  libXext = (stdenv.mkDerivation {
    name = "libXext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXext-1.0.2.tar.bz2;
      sha256 = "13lg78mlhvnip54yvifcmmqsa6dgnfbd0h7wwscdksvz27slr3in";
    };
    buildInputs = [pkgconfig libX11 libXau xextproto xproto ];
  }) // {inherit libX11 libXau xextproto xproto ;};
    
  libXfixes = (stdenv.mkDerivation {
    name = "libXfixes-4.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXfixes-4.0.3.tar.bz2;
      sha256 = "1p99m3hdh9m6a59jyn4vgwbppabhppsjdkjkwrfbii1pa0y0jzjl";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  }) // {inherit fixesproto libX11 xextproto xproto ;};
    
  libXfont = (stdenv.mkDerivation {
    name = "libXfont-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXfont-1.3.1.tar.bz2;
      sha256 = "1cd9b10s30z4fcvxvlrp8s5ylr482hhq7fc4r65djsm1h34pvyyw";
    };
    buildInputs = [pkgconfig fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ];
  }) // {inherit fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ;};
    
  libXfontcache = (stdenv.mkDerivation {
    name = "libXfontcache-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXfontcache-1.0.4.tar.bz2;
      sha256 = "0770yg0b9vqqlsq34nxb7ri3pf0smlhx018vmxidikc1pz7lgrzz";
    };
    buildInputs = [pkgconfig fontcacheproto libX11 libXext xextproto ];
  }) // {inherit fontcacheproto libX11 libXext xextproto ;};
    
  libXft = (stdenv.mkDerivation {
    name = "libXft-2.1.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXft-2.1.12.tar.bz2;
      sha256 = "11l98adf5sxpi9ryhckmxrdpa9ac2jz3m65xfv4302xgra2nzd38";
    };
    buildInputs = [pkgconfig fontconfig freetype libXrender ];
  }) // {inherit fontconfig freetype libXrender ;};
    
  libXi = (stdenv.mkDerivation {
    name = "libXi-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXi-1.1.3.tar.bz2;
      sha256 = "0gqm2a4bplpidhzknqvr6b1ipadcayyz3z6y794sdl6hjyz5nyn7";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  }) // {inherit inputproto libX11 libXext xextproto xproto ;};
    
  libXinerama = (stdenv.mkDerivation {
    name = "libXinerama-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXinerama-1.0.2.tar.bz2;
      sha256 = "0gfhwmz4bcfiqcsnp85sdlwdi641wzi6c9ncwp2cnvkn9jpdfifj";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  }) // {inherit libX11 libXext xextproto xineramaproto ;};
    
  libXmu = (stdenv.mkDerivation {
    name = "libXmu-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXmu-1.0.3.tar.bz2;
      sha256 = "0rkd8qsqmi3a2346ln4mqvqv89jfs0gvip9khjs9r3fs6s730vmm";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXt ];
  }) // {inherit libX11 libXext xextproto libXt ;};
    
  libXp = (stdenv.mkDerivation {
    name = "libXp-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXp-1.0.0.tar.bz2;
      sha256 = "1blwrr5zhmwwy87j0svmhv3hc13acyn5j14n5rv0anz81iav2r3y";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  }) // {inherit printproto libX11 libXau libXext xextproto ;};
    
  libXpm = (stdenv.mkDerivation {
    name = "libXpm-3.5.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXpm-3.5.7.tar.bz2;
      sha256 = "1aibr6y6hnlgc7m1a1y5s1qx7863praq4pdp0xrpkc75gkk1lw34";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
    patchPhase = "sed -i '/USE_GETTEXT_TRUE/d' sxpm/Makefile.in cxpm/Makefile.in";
  }) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXprintAppUtil = (stdenv.mkDerivation {
    name = "libXprintAppUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXprintAppUtil-1.0.1.tar.bz2;
      sha256 = "198ad7pmkp31vcs0iwd8z3vw08p69hlyjmzgk7sdny9k01368q14";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXprintUtil ];
  }) // {inherit printproto libX11 libXau libXp libXprintUtil ;};
    
  libXprintUtil = (stdenv.mkDerivation {
    name = "libXprintUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXprintUtil-1.0.1.tar.bz2;
      sha256 = "0v3fh9fqgravl8xl509swwd9a2v7iw38szhlpraiyq5r402axdkj";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXt ];
  }) // {inherit printproto libX11 libXau libXp libXt ;};
    
  libXrandr = (stdenv.mkDerivation {
    name = "libXrandr-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXrandr-1.2.2.tar.bz2;
      sha256 = "161aq7gf5h91jz9y9prxikxvh6zsz84yznvkzc9i4azia348svr0";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto libXrender ];
  }) // {inherit randrproto renderproto libX11 libXext xextproto libXrender ;};
    
  libXrender = (stdenv.mkDerivation {
    name = "libXrender-0.9.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXrender-0.9.4.tar.bz2;
      sha256 = "1v0p63g426x0hii0gynq05ccwihr6dn9azjpls8z4zjfvm1x70jn";
    };
    buildInputs = [pkgconfig renderproto libX11 ];
  }) // {inherit renderproto libX11 ;};
    
  libXres = (stdenv.mkDerivation {
    name = "libXres-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXres-1.0.3.tar.bz2;
      sha256 = "0c02i8wnwdnzkiaviddc2h7xswg6s58ipw4m204hzv7mfdsvmmd6";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto ];
  }) // {inherit resourceproto libX11 libXext xextproto ;};
    
  libXt = (stdenv.mkDerivation {
    name = "libXt-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXt-1.0.4.tar.bz2;
      sha256 = "0ifklh82iq81vgjrwp8pdypyr384zc0kca15flbnrxg8zyr8hw7c";
    };
    buildInputs = [pkgconfig kbproto libSM libX11 xproto ];
  }) // {inherit kbproto libSM libX11 xproto ;};
    
  libXtst = (stdenv.mkDerivation {
    name = "libXtst-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXtst-1.0.3.tar.bz2;
      sha256 = "01f9b3386v3dzlvdg0ccpa2wyv0d6b9fbxy149rws17bkhyxva5l";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto ];
  }) // {inherit inputproto recordproto libX11 libXext xextproto ;};
    
  libXv = (stdenv.mkDerivation {
    name = "libXv-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXv-1.0.3.tar.bz2;
      sha256 = "06r66s92pxxr73y2yzsyihdszwns4s8rs5c77kf2cg4swddycypq";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto ];
  }) // {inherit videoproto libX11 libXext xextproto ;};
    
  libXvMC = (stdenv.mkDerivation {
    name = "libXvMC-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXvMC-1.0.4.tar.bz2;
      sha256 = "1frshf8nfa81hz4q61qg1pc2sz93dl6nsc78dr39hqfnm1dq45qj";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto libXv ];
  }) // {inherit videoproto libX11 libXext xextproto libXv ;};
    
  libXxf86dga = (stdenv.mkDerivation {
    name = "libXxf86dga-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXxf86dga-1.0.2.tar.bz2;
      sha256 = "09cs62bvnv1wwjqcqyckhj0b0v7wa3dyldlg2icv67qal0q545sr";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};
    
  libXxf86misc = (stdenv.mkDerivation {
    name = "libXxf86misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXxf86misc-1.0.1.tar.bz2;
      sha256 = "128jm6nssp5wfic17rb54ssz6j3hibm77c9xxgm6x85a95yxc8i1";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};
    
  libXxf86vm = (stdenv.mkDerivation {
    name = "libXxf86vm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libXxf86vm-1.0.1.tar.bz2;
      sha256 = "0ni8r5im508i3yhn5mq78am7zgs53d4i0a6h3rsjyhhwc70w53z0";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};
    
  libdmx = (stdenv.mkDerivation {
    name = "libdmx-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libdmx-1.0.2.tar.bz2;
      sha256 = "1i5r4spy5s9s5nfxzpxlx06j6xcf865z821cfq2flz1zahdg6gzs";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  }) // {inherit dmxproto libX11 libXext xextproto ;};
    
  libfontenc = (stdenv.mkDerivation {
    name = "libfontenc-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libfontenc-1.0.4.tar.bz2;
      sha256 = "1j2qc9xqc2wibc005abvkj8wwn9hk6b5s2qn94ma2ig82wysm4xr";
    };
    buildInputs = [pkgconfig xproto zlib ];
  }) // {inherit xproto zlib ;};
    
  liblbxutil = (stdenv.mkDerivation {
    name = "liblbxutil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/liblbxutil-1.0.1.tar.bz2;
      sha256 = "0n3jgf95svmh788gw601jwdk58gw3sb87h57waaklv8hj1q1rhwl";
    };
    buildInputs = [pkgconfig xextproto xproto zlib ];
  }) // {inherit xextproto xproto zlib ;};
    
  liboldX = (stdenv.mkDerivation {
    name = "liboldX-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/liboldX-1.0.1.tar.bz2;
      sha256 = "03rl20g5fx0qfli1a1cxg4mvivgpsblwv9amszjq93z2yl0x748h";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  libpthreadstubs = (stdenv.mkDerivation {
    name = "libpthread-stubs-0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libpthread-stubs-0.1.tar.bz2;
      sha256 = "0raxl73kmviqinp00bfa025d0j4vmfjjcvfn754mi60mw48swk80";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  libxcb = (stdenv.mkDerivation {
    name = "libxcb-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.1.tar.bz2;
      sha256 = "0gyrh8y8hn9k6vs8c66czx3rwi07xyfr5kc191ksajbbi2vrr2rk";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs libXau xcbproto libXdmcp ];
  }) // {inherit libxslt libpthreadstubs libXau xcbproto libXdmcp ;};
    
  libxkbfile = (stdenv.mkDerivation {
    name = "libxkbfile-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libxkbfile-1.0.4.tar.bz2;
      sha256 = "1bmq4l45a5fzy1g4ap3cwd73c78smf8c5qba9g1sfl9rm97dx2j6";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  }) // {inherit kbproto libX11 ;};
    
  libxkbui = (stdenv.mkDerivation {
    name = "libxkbui-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/libxkbui-1.0.2.tar.bz2;
      sha256 = "0552zyrm0nvhsyy37x7g767cbii9kc3glvb9dmgywd1jsq0k3hi0";
    };
    buildInputs = [pkgconfig libX11 libxkbfile libXt ];
  }) // {inherit libX11 libxkbfile libXt ;};
    
  listres = (stdenv.mkDerivation {
    name = "listres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/listres-1.0.1.tar.bz2;
      sha256 = "18zpmvw4l13h3c4a99af04svp0xj4fwl88mksl0sah724n0famki";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  lndir = (stdenv.mkDerivation {
    name = "lndir-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/lndir-1.0.1.tar.bz2;
      sha256 = "0a84q8m3x8qbyrhx7r2k7wmhdb5588vcb1r21ifkx8yaaw1360fk";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  luit = (stdenv.mkDerivation {
    name = "luit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/luit-1.0.2.tar.bz2;
      sha256 = "171qhbbmfa12jv7anxkxamcrjpwiywyvyqnfyxnn431my1nxgi60";
    };
    buildInputs = [pkgconfig libfontenc libX11 zlib ];
  }) // {inherit libfontenc libX11 zlib ;};
    
  makedepend = (stdenv.mkDerivation {
    name = "makedepend-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/makedepend-1.0.1.tar.bz2;
      sha256 = "1lmi2vagp6svfvkqmhsbafjhchwscii7sfdzr20d90hg46gsslmp";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  mkfontdir = (stdenv.mkDerivation {
    name = "mkfontdir-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/mkfontdir-1.0.3.tar.bz2;
      sha256 = "0x1hclcrqsnccxc0n2wkrx5yjxpgr704dd1x4vvcflqsc41nwy1a";
    };
    buildInputs = [pkgconfig ]; preBuild = "substituteInPlace mkfontdir.cpp --replace BINDIR ${mkfontscale}/bin"; 
  }) // {inherit ;};
    
  mkfontscale = (stdenv.mkDerivation {
    name = "mkfontscale-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/mkfontscale-1.0.3.tar.bz2;
      sha256 = "087h7bapnsl74w7c0r23j0gikz2sazw8wr0ql1cb8jjvaajs6n04";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  }) // {inherit libfontenc freetype xproto zlib ;};
    
  oclock = (stdenv.mkDerivation {
    name = "oclock-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/oclock-1.0.1.tar.bz2;
      sha256 = "0z11fj6f2z4q2wcw96m2yf4pg8cxnhwfw4j0f4qbxyq2ci7pvas9";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  pixman = (stdenv.mkDerivation {
    name = "pixman-0.9.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/individual/lib/pixman-0.9.6.tar.bz2;
      sha256 = "0nrksqwkaq1kczzkpqw1nvxc0b2d89d81gzb4j43hz6n729xn165";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  printproto = (stdenv.mkDerivation {
    name = "printproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/printproto-1.0.3.tar.bz2;
      sha256 = "0dbjxinhbd55vjdx3jws97id116lxlgg8jp49gccgpw3va65ydwb";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  proxymngr = (stdenv.mkDerivation {
    name = "proxymngr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/proxymngr-1.0.1.tar.bz2;
      sha256 = "1i95jp3xw1z2llw028rpkr4id03jxkqb0pv0l1vj8mhi6iax9xg9";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  randrproto = (stdenv.mkDerivation {
    name = "randrproto-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/randrproto-1.2.1.tar.bz2;
      sha256 = "0m7n624h2rsxs7m5x03az87x7hlh0gxqphj59q7laqi5iwpx8bqh";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  recordproto = (stdenv.mkDerivation {
    name = "recordproto-1.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/recordproto-1.13.2.tar.bz2;
      sha256 = "1yfg15k5fznjvndvld3vw7gcbcmq1p6ic0dybf1a2wzk2j5pmrq4";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  renderproto = (stdenv.mkDerivation {
    name = "renderproto-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/renderproto-0.9.3.tar.bz2;
      sha256 = "0nyl5pmgrvw7p6laqgsrk65b633yvrrf8jx0vakqz2p9fyw0i2n9";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  resourceproto = (stdenv.mkDerivation {
    name = "resourceproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/resourceproto-1.0.2.tar.bz2;
      sha256 = "11rlnn54y15bf39ll7vzn9824l1ib15r7p4v8l0k0j7mxvydccqc";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  rgb = (stdenv.mkDerivation {
    name = "rgb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/rgb-1.0.1.tar.bz2;
      sha256 = "1bch55h8dm382hnc2n52rihx1wp965lsl6camx4c4qigyw1bqdgn";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  rstart = (stdenv.mkDerivation {
    name = "rstart-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/rstart-1.0.2.tar.bz2;
      sha256 = "15lmirb2x8icvc7qzj87fcb09p6fk9kbnphf5wkf864h0ssliz02";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scripts = (stdenv.mkDerivation {
    name = "scripts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/scripts-1.0.1.tar.bz2;
      sha256 = "0dm1jhwq1r396xfcxx3g9lvgzydf4mikjicch6cs8b1hb51ln58v";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scrnsaverproto = (stdenv.mkDerivation {
    name = "scrnsaverproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/scrnsaverproto-1.1.0.tar.bz2;
      sha256 = "13s7rpygj0zm8lk6r9zw1ivs8wj3g4qrfqw80ifc0ff37kvsn2fv";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  sessreg = (stdenv.mkDerivation {
    name = "sessreg-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/sessreg-1.0.3.tar.bz2;
      sha256 = "1p40013kg73qkgwhhj06l0yrmvcp90r937vlzh4xyv94adfi833x";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  setxkbmap = (stdenv.mkDerivation {
    name = "setxkbmap-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/setxkbmap-1.0.4.tar.bz2;
      sha256 = "1b1brw1v98q2rqhr5x7f8mr3clxq62nw5175gpamg5s172916nwv";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ]; postInstall = "ensureDir $out/share; ln -sfn ${xkeyboard_config}/etc/X11 $out/share/X11";
  }) // {inherit libX11 libxkbfile ;};
    
  showfont = (stdenv.mkDerivation {
    name = "showfont-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/showfont-1.0.1.tar.bz2;
      sha256 = "033nc48aaq0j5jg36fwksfsxg3wwyg3kaayifjqcdaql57qkrnw7";
    };
    buildInputs = [pkgconfig libFS ];
  }) // {inherit libFS ;};
    
  smproxy = (stdenv.mkDerivation {
    name = "smproxy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/smproxy-1.0.2.tar.bz2;
      sha256 = "1lk79yfdalpn0c7hm57vpr3xg6rib1dr6p2wl634733wy062zlkn";
    };
    buildInputs = [pkgconfig libXmu libXt ];
  }) // {inherit libXmu libXt ;};
    
  trapproto = (stdenv.mkDerivation {
    name = "trapproto-3.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/trapproto-3.4.3.tar.bz2;
      sha256 = "1qd06blxgah1pf49259gm9njpbqqk1gcisbv8p1ssv39pk9s0cpz";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  twm = (stdenv.mkDerivation {
    name = "twm-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/twm-1.0.3.tar.bz2;
      sha256 = "0kiap5xxswx4w6dhbb6ys19blff8nrzzqwxbh8mvz4x8fw25ahav";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  utilmacros = (stdenv.mkDerivation {
    name = "util-macros-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/util-macros-1.1.5.tar.bz2;
      sha256 = "06v5ym133460z9r4jyz9k0dfs07hsrhg1ww35q9cr2vbw689g4vm";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  videoproto = (stdenv.mkDerivation {
    name = "videoproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/videoproto-2.2.2.tar.bz2;
      sha256 = "033q4jgrwgkdcwj5q8hwf7vpl5sdzm7z9dsgwcphrlqchdw8825b";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  viewres = (stdenv.mkDerivation {
    name = "viewres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/viewres-1.0.1.tar.bz2;
      sha256 = "1f1lrvnjnf5c0lwisribdb7zgsk1874rjz1v5fcsd5xizx2wsjdz";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  windowswmproto = (stdenv.mkDerivation {
    name = "windowswmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/windowswmproto-1.0.3.tar.bz2;
      sha256 = "0lgih20hvpxzdvzwrw5plfynrkb2b930mnfymfnffbdvjsb283bq";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  x11perf = (stdenv.mkDerivation {
    name = "x11perf-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/x11perf-1.4.1.tar.bz2;
      sha256 = "0r1h9ndlbnyf87vz36ga97hmqbp05q7zh3lmbfjzv5n5irhij668";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  }) // {inherit libX11 libXext libXft libXmu libXrender ;};
    
  xauth = (stdenv.mkDerivation {
    name = "xauth-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xauth-1.0.2.tar.bz2;
      sha256 = "05qzbxjvn947igkyad5bg12y3bbd5ji6v9h43jznmcay3rc5m7jn";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  }) // {inherit libX11 libXau libXext libXmu ;};
    
  xbacklight = (stdenv.mkDerivation {
    name = "xbacklight-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xbacklight-1.1.tar.bz2;
      sha256 = "1934bnxa3hx0mzihv3bgcid6qrn75an03ci5dzhnjicp2lgh15f7";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  }) // {inherit libX11 libXrandr libXrender ;};
    
  xbiff = (stdenv.mkDerivation {
    name = "xbiff-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xbiff-1.0.1.tar.bz2;
      sha256 = "00v5m4s7kh93fx612pcjviy893h611lbcsgx067l1z8wibxb2icq";
    };
    buildInputs = [pkgconfig libXaw xbitmaps libXext ];
  }) // {inherit libXaw xbitmaps libXext ;};
    
  xbitmaps = (stdenv.mkDerivation {
    name = "xbitmaps-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xbitmaps-1.0.1.tar.bz2;
      sha256 = "0rxqxrnkivn52kk41a9bl1ppy756c5gw5w1rbnw75xvp9rcvx9as";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcalc = (stdenv.mkDerivation {
    name = "xcalc-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xcalc-1.0.2.tar.bz2;
      sha256 = "0cjapca3lc67ypcinmygbwmjb2bd38ycgshb9p8ljwif44nmwdwn";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xcbproto = (stdenv.mkDerivation {
    name = "xcb-proto-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.1.tar.bz2;
      sha256 = "0knih0f85y7j3q2c8dia8s6nw5b25c2fr3zx0m0znxah7pc9ibq6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcbutil = (stdenv.mkDerivation {
    name = "xcb-util-0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.2.tar.bz2;
      sha256 = "06mhfp6n2nyk1flhnbx9kbv2rc3myny2v6rg5y1ymg6wqida3mm0";
    };
    buildInputs = [pkgconfig libxcb ];
  }) // {inherit libxcb ;};
    
  xclipboard = (stdenv.mkDerivation {
    name = "xclipboard-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xclipboard-1.0.1.tar.bz2;
      sha256 = "1z3h9myc5asq6jacb8r7sjlaym226z45a64fazm14l9805qs569k";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xclock = (stdenv.mkDerivation {
    name = "xclock-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xclock-1.0.3.tar.bz2;
      sha256 = "0zspx5jqp52wgp4c4d9qaxhp0b9p2fzx2ys4rza10apgx5x7gd8h";
    };
    buildInputs = [pkgconfig libXaw libX11 libXft libxkbfile libXrender libXt ];
  }) // {inherit libXaw libX11 libXft libxkbfile libXrender libXt ;};
    
  xcmiscproto = (stdenv.mkDerivation {
    name = "xcmiscproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xcmiscproto-1.1.2.tar.bz2;
      sha256 = "1awjhz3cc06zsds57qnjwgm3y7z5bl4l6akqy6xvfcnnm6b7x05j";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcmsdb = (stdenv.mkDerivation {
    name = "xcmsdb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xcmsdb-1.0.1.tar.bz2;
      sha256 = "0bp9xw2cmj9d0d18h5fdzcmc7jnjzbn5sb3vnx6qbbpz86gs6xg2";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xconsole = (stdenv.mkDerivation {
    name = "xconsole-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xconsole-1.0.3.tar.bz2;
      sha256 = "0idw8rxcpg16922zrph4ihnp1a7mq5c46ivl7k1zad5dxxgw47hv";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xcursorgen = (stdenv.mkDerivation {
    name = "xcursorgen-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xcursorgen-1.0.2.tar.bz2;
      sha256 = "0khp7i7w8b5835q7wfdg385x072fhwbnpjqvv558vvxgs8mk42g0";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  }) // {inherit libpng libX11 libXcursor ;};
    
  xcursorthemes = (stdenv.mkDerivation {
    name = "xcursor-themes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xcursor-themes-1.0.1.tar.bz2;
      sha256 = "184ybhyb6wj082rvr83q4jnnx3g7f1i4kpm3s4dwwifh5i0cszaf";
    };
    buildInputs = [pkgconfig libXcursor ];
  }) // {inherit libXcursor ;};
    
  xdbedizzy = (stdenv.mkDerivation {
    name = "xdbedizzy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xdbedizzy-1.0.2.tar.bz2;
      sha256 = "0b81cq8i6shlfq1nad0zljw329grzwd0fhxg9hkypsz7zvlq5s3l";
    };
    buildInputs = [pkgconfig libX11 libXext ];
  }) // {inherit libX11 libXext ;};
    
  xditview = (stdenv.mkDerivation {
    name = "xditview-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xditview-1.0.1.tar.bz2;
      sha256 = "05w1an1x7np1x0z418pi5vgrwddfx1rvb8736kww4c9vz3jr8w8p";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xdm = (stdenv.mkDerivation {
    name = "xdm-1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xdm-1.1.6.tar.bz2;
      sha256 = "1kcbb85vliy4644q6iiazpqaq5zzcg9p2j4w9r1gbhx5knfwh6n4";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
  }) // {inherit libXaw libX11 libXau libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};
    
  xdpyinfo = (stdenv.mkDerivation {
    name = "xdpyinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xdpyinfo-1.0.1.tar.bz2;
      sha256 = "0qawlhs5ryg8zpycqcflrrhf525gk5b43vi15rqwkfv05y3bbk8w";
    };
    buildInputs = [pkgconfig libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  }) // {inherit libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};
    
  xdriinfo = (stdenv.mkDerivation {
    name = "xdriinfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xdriinfo-1.0.2.tar.bz2;
      sha256 = "0rbj9s0jc265wzqz79q9dkqy7626dmby6qdd4266hybcbc4sq0vv";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  }) // {inherit glproto libX11 ;};
    
  xedit = (stdenv.mkDerivation {
    name = "xedit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xedit-1.0.2.tar.bz2;
      sha256 = "1pv26chphq74l7g3d5ps2ylgvyrmq0lw5wv1qbxfzjgqpa5xfn16";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xev = (stdenv.mkDerivation {
    name = "xev-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xev-1.0.1.tar.bz2;
      sha256 = "0m6vkbgmq5zbam7cjjjdpli3daia0anp3in9v93m2m3qbh0hff65";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xextproto = (stdenv.mkDerivation {
    name = "xextproto-7.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xextproto-7.0.2.tar.bz2;
      sha256 = "1ng0247qi8f86p419ig7910g5dp0xdylliyl778qpc39wyd07wsk";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xeyes = (stdenv.mkDerivation {
    name = "xeyes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xeyes-1.0.1.tar.bz2;
      sha256 = "0ac0m9af193lxpyj11k2sp2xpmlhzzn3xrs6kdyy6c11fgl042ak";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  xf86bigfontproto = (stdenv.mkDerivation {
    name = "xf86bigfontproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86bigfontproto-1.1.2.tar.bz2;
      sha256 = "097i2l56kwgcd6033ng8j83xpx9pxlnwx53gvcwaf2bpnaspbd01";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86dga = (stdenv.mkDerivation {
    name = "xf86dga-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86dga-1.0.2.tar.bz2;
      sha256 = "0mqqrifbbfj2bh6hd187kmfzfn1rxgghmhsy9i6s5rcn6yw361k5";
    };
    buildInputs = [pkgconfig libX11 libXaw libXmu libXt libXxf86dga ];
  }) // {inherit libX11 libXaw libXmu libXt libXxf86dga ;};
    
  xf86dgaproto = (stdenv.mkDerivation {
    name = "xf86dgaproto-2.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86dgaproto-2.0.3.tar.bz2;
      sha256 = "00mhjvbgkgr08d8drjavrvxyvnma5rddnmpxc5y74cmh12ix9i2s";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86driproto = (stdenv.mkDerivation {
    name = "xf86driproto-2.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86driproto-2.0.3.tar.bz2;
      sha256 = "1mmqaqkingf8k6qi5kfwrqkb4q4767c2biq4h6q06j1p4jd4c70i";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86inputacecad = (stdenv.mkDerivation {
    name = "xf86-input-acecad-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-acecad-1.2.0.tar.bz2;
      sha256 = "099h36v79sncqvy4gnnwmgq4bq73vfyrb7s1z5h3kvwhfx7jh349";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputaiptek = (stdenv.mkDerivation {
    name = "xf86-input-aiptek-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-aiptek-1.0.1.tar.bz2;
      sha256 = "12n2zjxxppggl3pjs6ndi4yx7did88c6gqkszz13in1lj0jy7c1x";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputcalcomp = (stdenv.mkDerivation {
    name = "xf86-input-calcomp-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-calcomp-1.1.0.tar.bz2;
      sha256 = "01094hfk3x24m64w0khmk38cwsrplnrf672b228x6wpa9vkldi7b";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputcitron = (stdenv.mkDerivation {
    name = "xf86-input-citron-2.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-citron-2.2.0.tar.bz2;
      sha256 = "1zn3s90xf25vhvrp9imqzr9v7xx59g28dlpw740gi0x3sdasgkr6";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdigitaledge = (stdenv.mkDerivation {
    name = "xf86-input-digitaledge-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-digitaledge-1.1.0.tar.bz2;
      sha256 = "0f4ap658852ya9876ydcbwbr1yjf7s308br1z3yc4nvbnhciy014";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdmc = (stdenv.mkDerivation {
    name = "xf86-input-dmc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-dmc-1.1.0.tar.bz2;
      sha256 = "0gs7j23w8ki6yvssfwcibdypx9kp29kd02y1n9khf4z0vyr8zjn5";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdynapro = (stdenv.mkDerivation {
    name = "xf86-input-dynapro-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-dynapro-1.1.0.tar.bz2;
      sha256 = "0shdqpksmh3w5va0vw1jj3gd1fdln0yvgjskv9bzw9x0385xaapw";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputelo2300 = (stdenv.mkDerivation {
    name = "xf86-input-elo2300-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-elo2300-1.1.0.tar.bz2;
      sha256 = "0d11mbd4hxxgnb3d71camg558dmnyqgjs0sdlrkkhmy44izgclcm";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputelographics = (stdenv.mkDerivation {
    name = "xf86-input-elographics-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-elographics-1.0.0.5.tar.bz2;
      sha256 = "0adai0hs7imn4p7baw2vag5j264gkl42bfjxlqqmqw01g4jgil26";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputevdev = (stdenv.mkDerivation {
    name = "xf86-input-evdev-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-evdev-1.1.2.tar.bz2;
      sha256 = "15avwy8isbqagzcdj20ngqajl22k40pssfx7vjirhrqyyq19fiwb";
    };
    preBuild = "
    sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c
    ";
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  }) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputfpit = (stdenv.mkDerivation {
    name = "xf86-input-fpit-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-fpit-1.1.0.tar.bz2;
      sha256 = "1y4lys3s4qsr4afj7r23ldmjryx778ajb85x1x384qaij3gv5qwf";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputhyperpen = (stdenv.mkDerivation {
    name = "xf86-input-hyperpen-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-hyperpen-1.1.0.tar.bz2;
      sha256 = "14zl0zk301w8lvmkgxm4fqab9b66xprdqclqfls5cv7080rhmhni";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputjamstudio = (stdenv.mkDerivation {
    name = "xf86-input-jamstudio-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-jamstudio-1.1.0.tar.bz2;
      sha256 = "06kyclz260x2l5f0yn7449si8m6869dc5kvrdc1k3sh8pmhb6hff";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputjoystick = (stdenv.mkDerivation {
    name = "xf86-input-joystick-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-joystick-1.2.3.tar.bz2;
      sha256 = "1xslb7p3c0ihg36y402cphyhcwfar3nihv2n417sj4hf1z5033kh";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputkeyboard = (stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-keyboard-1.2.2.tar.bz2;
      sha256 = "0wn0gv9mb5ld9mginiikn69jknc9wkwqn3dxjy6r405g9r93any2";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  }) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputmagellan = (stdenv.mkDerivation {
    name = "xf86-input-magellan-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-magellan-1.1.0.tar.bz2;
      sha256 = "0gc3lzq6pb807ffikld4a810asgj6z786wgd62ii71a21jsm9vwf";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmagictouch = (stdenv.mkDerivation {
    name = "xf86-input-magictouch-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-magictouch-1.0.0.5.tar.bz2;
      sha256 = "0k24sy0wcv49xcm4jwfxq3c5xzla8zqviqzvfgs8js6qx4qwivcw";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmicrotouch = (stdenv.mkDerivation {
    name = "xf86-input-microtouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-microtouch-1.1.0.tar.bz2;
      sha256 = "0f90r8drcpl6bvjibcc8q7svi8ra9gyrhhbl03yzpv4m2i9zb4kz";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmouse = (stdenv.mkDerivation {
    name = "xf86-input-mouse-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-mouse-1.2.2.tar.bz2;
      sha256 = "1pvyiv1xl38jacf7cc18sipz8b10mk9vqh11kcl72sq3n99cpsc0";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmutouch = (stdenv.mkDerivation {
    name = "xf86-input-mutouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-mutouch-1.1.0.tar.bz2;
      sha256 = "1sk23d6jw63l19c0j26qplwmfb0kfnwl5zhbixwqvk2g9zfy0ryc";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputpalmax = (stdenv.mkDerivation {
    name = "xf86-input-palmax-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-palmax-1.1.0.tar.bz2;
      sha256 = "0ia1mhp318bk292iszqyz25fns7sq8hjzvib6rssal19xmgch02w";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputpenmount = (stdenv.mkDerivation {
    name = "xf86-input-penmount-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-penmount-1.2.0.tar.bz2;
      sha256 = "03hmcvvlkk56aldbpqxyv7vi9pbnyip1zyhwk2yffncgrw3qm8fy";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputspaceorb = (stdenv.mkDerivation {
    name = "xf86-input-spaceorb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-spaceorb-1.1.0.tar.bz2;
      sha256 = "0588bwr7m03w61p5h7pixaa9nlsrijld6cr2yzriyh5z36vkrmcw";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputsumma = (stdenv.mkDerivation {
    name = "xf86-input-summa-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-summa-1.1.0.tar.bz2;
      sha256 = "1whi5azynj1vv1yiqi47szs0ac0fj5zwh040cnrl02qjsjnjq3zi";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputtek4957 = (stdenv.mkDerivation {
    name = "xf86-input-tek4957-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-tek4957-1.1.0.tar.bz2;
      sha256 = "09spw5gvyj8p2alqazhmp1xrjx8xdv2jnfbjk3vampmi3dnm1f89";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputur98 = (stdenv.mkDerivation {
    name = "xf86-input-ur98-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-ur98-1.1.0.tar.bz2;
      sha256 = "0aj7qvpbfk3hfwlx9qqp0rkfdlpf75jxc0yf93a35aajznqcwjr1";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvmmouse = (stdenv.mkDerivation {
    name = "xf86-input-vmmouse-12.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-vmmouse-12.4.1.tar.bz2;
      sha256 = "1vxlf64hxy4sha293axrhgxwdvqwjsql22cr0zpngdn4rxlspln7";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvoid = (stdenv.mkDerivation {
    name = "xf86-input-void-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-input-void-1.1.0.tar.bz2;
      sha256 = "1r5h92v5f3gis7395c1w9h1byf5q383xscd1l6v0dg911295sg5l";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86miscproto = (stdenv.mkDerivation {
    name = "xf86miscproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86miscproto-0.9.2.tar.bz2;
      sha256 = "1rnnv8vi5z457wl5j184qw1z3ai3mvbwssdshm3ysgf736zlraxa";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86rushproto = (stdenv.mkDerivation {
    name = "xf86rushproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86rushproto-1.1.2.tar.bz2;
      sha256 = "1bm3d7ck33y4gkvk7cc7djrnd9w7v4sm73xjnl9n6b8zahvv5n87";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86videoapm = (stdenv.mkDerivation {
    name = "xf86-video-apm-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-apm-1.1.1.tar.bz2;
      sha256 = "1v6wcl47b3lhik1fs221wx2zcn5006rn09dyiqgi8kxr637ydmq9";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoark = (stdenv.mkDerivation {
    name = "xf86-video-ark-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-ark-0.6.0.tar.bz2;
      sha256 = "1mw4ph6y4cijb8azsjjy4f35gw4na58m5w3kaxnyag34mvsc9az5";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoast = (stdenv.mkDerivation {
    name = "xf86-video-ast-0.81.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-ast-0.81.0.tar.bz2;
      sha256 = "1f2r4j85792b81axil3h4fy2s44i5gp4r4c23h2jivwvz2m56mdr";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoati = (stdenv.mkDerivation {
    name = "xf86-video-ati-6.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-ati-6.6.3.tar.bz2;
      sha256 = "102p6nz1jvd3pgbl83a4zi99smydqr6il61r33l0lqmi3yg452nh";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto mesaHeaders glproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto mesaHeaders glproto;};
    
  xf86videochips = (stdenv.mkDerivation {
    name = "xf86-video-chips-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-chips-1.1.1.tar.bz2;
      sha256 = "153lpk2jm6amxag4i8zrpjnk0mfpq1wx49ikdj9pc49idgdira0n";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocirrus = (stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-cirrus-1.1.0.tar.bz2;
      sha256 = "06wv2yqr7jalk6znwqdnidjxy1glwhwjk5d6yrs340fmk4hrd22r";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocyrix = (stdenv.mkDerivation {
    name = "xf86-video-cyrix-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-cyrix-1.1.0.tar.bz2;
      sha256 = "1bd65iyacnw76nm9znxmfgvjddbbpn346y55rc3xkpgnw1w6g9nn";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videodummy = (stdenv.mkDerivation {
    name = "xf86-video-dummy-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-dummy-0.2.0.tar.bz2;
      sha256 = "04690qg07v01d8ncz5ws651i8scyqsmh7mf50mg1lg3gd62kh0a6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};
    
  xf86videofbdev = (stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-fbdev-0.3.1.tar.bz2;
      sha256 = "1rznknqy3r0jr1xy3186j120qybpjnq4apf0jjj9wmbpiihiz79h";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videoglide = (stdenv.mkDerivation {
    name = "xf86-video-glide-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-glide-1.0.0.tar.bz2;
      sha256 = "1bsynd01sjz3pp9lkphiiln0nwkjy5fyywymfr1x617r1216szb6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoglint = (stdenv.mkDerivation {
    name = "xf86-video-glint-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-glint-1.1.1.tar.bz2;
      sha256 = "0vay25kisr8lpmqnl9z3fglw341yr25ad4sij7qvmknfyp9hsgnn";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};
    
  xf86videoi128 = (stdenv.mkDerivation {
    name = "xf86-video-i128-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-i128-1.2.1.tar.bz2;
      sha256 = "1cay0pyvbwljaf4x6n9gr4398fann5779mgwiv6l2hhkz2n3q0hd";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi740 = (stdenv.mkDerivation {
    name = "xf86-video-i740-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-i740-1.1.0.tar.bz2;
      sha256 = "1idpw8s8wz69qcw0kr3p1826viy17yj3mvkpnkw192kxk1619wmq";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi810 = (stdenv.mkDerivation {
    name = "xf86-video-i810-1.7.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/individual/driver/xf86-video-i810-1.7.4.tar.bz2;
      sha256 = "0na2qy78waa9jy0ikd10g805v0w048icnkdcss6yd753kffdi37z";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm mesaHeaders randrproto renderproto libX11 xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto glproto libdrm mesaHeaders randrproto renderproto libX11 xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ;};
    
  xf86videoimstt = (stdenv.mkDerivation {
    name = "xf86-video-imstt-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-imstt-1.1.0.tar.bz2;
      sha256 = "0zgv20zj4gr4sv93ffl3zzsy446041zrs13wndxdsdwlgwjw4f4j";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videointel = (stdenv.mkDerivation {
    name = "xf86-video-intel-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-intel-2.1.1.tar.bz2;
      sha256 = "0765spq3ksw15hn9mia1sbznainnb2w6zlkgwmdv7d4srjr1awjg";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm mesaHeaders randrproto renderproto libX11 xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto glproto libdrm mesaHeaders randrproto renderproto libX11 xextproto xf86driproto xineramaproto xorgserver xproto libXvMC ;};
    
  xf86videomga = (stdenv.mkDerivation {
    name = "xf86-video-mga-1.4.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-mga-1.4.6.1.tar.bz2;
      sha256 = "1z7xmyyx2wy69w59cnzir03h4ydhcramzn7rqli428fci30fib57";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videoneomagic = (stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-neomagic-1.1.1.tar.bz2;
      sha256 = "11lav16j3ymn2sra0zdx5ql7hxa5sjpprpgycfv8b0kvjs070jfn";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonewport = (stdenv.mkDerivation {
    name = "xf86-video-newport-0.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-newport-0.2.1.tar.bz2;
      sha256 = "026fn4c760rr03i2r9pq824k31nxq5nq0xq582bgh3k9a9a8bb36";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videonsc = (stdenv.mkDerivation {
    name = "xf86-video-nsc-2.8.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-nsc-2.8.3.tar.bz2;
      sha256 = "0f8qicx3b5ibi2y62lmc3r7y093366b61h1rxrdrgf3p301a5ig5";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonv = (stdenv.mkDerivation {
    name = "xf86-video-nv-2.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-nv-2.1.3.tar.bz2;
      sha256 = "0llrjrfm68x7s274m7q5q49qh59ks75kwzqyhbvij6f36yhmx6wd";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videorendition = (stdenv.mkDerivation {
    name = "xf86-video-rendition-4.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-rendition-4.1.3.tar.bz2;
      sha256 = "0224vz4v96y5lbxqp1hnvqwp9jwh67ad1brvb9glhrkl5zvsxrrp";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videos3 = (stdenv.mkDerivation {
    name = "xf86-video-s3-0.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-s3-0.5.0.tar.bz2;
      sha256 = "15swq2wkccraj6xv3wrqh69283ixj7clfr91h64as2i03b5hc4ja";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videos3virge = (stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-s3virge-1.9.1.tar.bz2;
      sha256 = "08n89fl97rpk5mzwfjl4kyj5syhz4k02sixip1zp77plcclp1xff";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosavage = (stdenv.mkDerivation {
    name = "xf86-video-savage-2.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-savage-2.1.3.tar.bz2;
      sha256 = "1i9w3ami0brwim7v9p3nawnr2qsx16vxclqlbn9lbd3w6zgm9wgm";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosiliconmotion = (stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-siliconmotion-1.4.2.tar.bz2;
      sha256 = "1pazl8m6gh60sv92p57ldnd8ixwk9k3mw2r62ai44hs51j960ym4";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosis = (stdenv.mkDerivation {
    name = "xf86-video-sis-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-sis-0.9.3.tar.bz2;
      sha256 = "1xin2hcjjwj2810h7kxhkmqq841plbsvk0swmjl9py7z2vxyi3l9";
    };
    buildInputs = [pkgconfig fontsproto glproto mesaHeaders libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto glproto mesaHeaders libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosisusb = (stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-sisusb-0.8.1.tar.bz2;
      sha256 = "1js5vf5xjxpi0nb0bpjc1glbx2l0fq1wqmnlwayn6cp3nfdbg5hm";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosunbw2 = (stdenv.mkDerivation {
    name = "xf86-video-sunbw2-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-sunbw2-1.1.0.tar.bz2;
      sha256 = "0dl16ccbzzy0dchxzv4g7qjc59a2875c4lb68yn733xd87lp846p";
    };
    buildInputs = [pkgconfig randrproto xorgserver xproto ];
  }) // {inherit randrproto xorgserver xproto ;};
    
  xf86videosuncg14 = (stdenv.mkDerivation {
    name = "xf86-video-suncg14-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-suncg14-1.1.0.tar.bz2;
      sha256 = "09q5wjay9mn9msskawv4i5in3chqwv1a0qp4z54xn9g7f04jpjhy";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg3 = (stdenv.mkDerivation {
    name = "xf86-video-suncg3-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-suncg3-1.1.0.tar.bz2;
      sha256 = "1ybxqf8z8q3r12s6pm1ygv0wffp9h7c6d4am8qnqgsnzrk4fnr1m";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg6 = (stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-suncg6-1.1.0.tar.bz2;
      sha256 = "0jqr6xjs6i8lb40qyiqnyrfzmy9ch53jhjr0w20m5vspkjvz7cfn";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosunffb = (stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-sunffb-1.1.0.tar.bz2;
      sha256 = "0achhw5gskairc2gjqms64qyni7ai8ly6917v1grdxiwx0ks95zq";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosunleo = (stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-sunleo-1.1.0.tar.bz2;
      sha256 = "1a8d4y9v6gpbdmd3pl8qgklxw93v631wkafjvk4rpshv4q7xa15m";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuntcx = (stdenv.mkDerivation {
    name = "xf86-video-suntcx-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-suntcx-1.1.0.tar.bz2;
      sha256 = "1kq1gg273x460rin8gh5spl7yhyv23b4795by46zcimph4wnm63j";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videotdfx = (stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-tdfx-1.3.0.tar.bz2;
      sha256 = "0946f977bc78gcwv8qzbyd20g5bqylc6yz7h11yq2a4nbkgh06kb";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videotga = (stdenv.mkDerivation {
    name = "xf86-video-tga-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-tga-1.1.0.tar.bz2;
      sha256 = "16vfzahrcaw1fpgm28j2anzhfm4di6j1h5glq96i3zarsbyks52h";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotrident = (stdenv.mkDerivation {
    name = "xf86-video-trident-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-trident-1.2.3.tar.bz2;
      sha256 = "1594fbbax5gv5i01i2k0c7bir83h1kbdqqysckgqs8sx2vxbhgnj";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotseng = (stdenv.mkDerivation {
    name = "xf86-video-tseng-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-tseng-1.1.1.tar.bz2;
      sha256 = "0vnmvxngshp4912zjf7bjx7954xbph03swxwd202ddqmhwqz7hf9";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videov4l = (stdenv.mkDerivation {
    name = "xf86-video-v4l-0.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-v4l-0.1.1.tar.bz2;
      sha256 = "0w68msn8vb1k03mc5sy2cinvral35lzlz5nrb1zxma7nlfg59b9k";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  }) // {inherit randrproto videoproto xorgserver xproto ;};
    
  xf86videovermilion = (stdenv.mkDerivation {
    name = "xf86-video-vermilion-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-vermilion-1.0.0.tar.bz2;
      sha256 = "1vr7vfc35x8dd3ra66i5x2xyycl3ydh98wipz7ks4dkkgs4rh39z";
    };
    buildInputs = [pkgconfig fontsproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videovesa = (stdenv.mkDerivation {
    name = "xf86-video-vesa-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-vesa-1.3.0.tar.bz2;
      sha256 = "00z2jg409gyn6gkagdrs7la83qmj6k3w9nj4yg73w4pmh6p80v5r";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovga = (stdenv.mkDerivation {
    name = "xf86-video-vga-4.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-vga-4.1.0.tar.bz2;
      sha256 = "0havz5hv46qz3g6g0mq2568758apdapzy0yd5ny8qs06yz0g89fa";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovia = (stdenv.mkDerivation {
    name = "xf86-video-via-0.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-via-0.2.2.tar.bz2;
      sha256 = "0qn89m1s50m4jajw95wcidarknyxn19h8696dbkgwy21cjpvs9jh";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videovmware = (stdenv.mkDerivation {
    name = "xf86-video-vmware-10.14.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-vmware-10.14.1.tar.bz2;
      sha256 = "1aaghvwy7wnk4pkmxym5cw8w499wqi293nqyc71h8hm5dcszsw8r";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xineramaproto xorgserver xproto ;};
    
  xf86videovoodoo = (stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86-video-voodoo-1.1.1.tar.bz2;
      sha256 = "073mc423wql4w72dbwf73lzr3k0pdxc9drnzs2xb4x76mqdn0x9r";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86vidmodeproto = (stdenv.mkDerivation {
    name = "xf86vidmodeproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xf86vidmodeproto-2.2.2.tar.bz2;
      sha256 = "0vnrqhzrsyjh77zgrxlgx53r34dij15crpl9369wb7n71jcjy587";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xfd = (stdenv.mkDerivation {
    name = "xfd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfd-1.0.1.tar.bz2;
      sha256 = "07ifbsdany081g6wip0mfq5s2xcdl69p76xnk9rxca84g0bal6qi";
    };
    buildInputs = [pkgconfig fontconfig freetype libXaw libXft libXt ];
  }) // {inherit fontconfig freetype libXaw libXft libXt ;};
    
  xfindproxy = (stdenv.mkDerivation {
    name = "xfindproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfindproxy-1.0.1.tar.bz2;
      sha256 = "1sl836x5dbjp6ipin67i0ikrv1l5whvhin3pw4rv85ryvpm5qn3b";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  xfontsel = (stdenv.mkDerivation {
    name = "xfontsel-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfontsel-1.0.1.tar.bz2;
      sha256 = "0zsc9a4n4wpy6g6ajpjcqr277zy9anzhiyaal2cc7dz0gc62mjjy";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xfs = (stdenv.mkDerivation {
    name = "xfs-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfs-1.0.4.tar.bz2;
      sha256 = "06v4xrs2br8h8ailaphfbb2w2yf50xap7fdlihmmmbn74clxwba5";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  }) // {inherit libFS libXfont xtrans ;};
    
  xfsinfo = (stdenv.mkDerivation {
    name = "xfsinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfsinfo-1.0.1.tar.bz2;
      sha256 = "1n8csr613bnq9kkspqg0113z548498005rvx83939wx7nd1k9hxd";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  xfwp = (stdenv.mkDerivation {
    name = "xfwp-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xfwp-1.0.1.tar.bz2;
      sha256 = "14vdkawdw2lxyx4r6ij2vlcx9ba1frw2d2l007fqc866afsfrmnd";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol ];
  }) // {inherit libICE libX11 xproxymanagementprotocol ;};
    
  xgamma = (stdenv.mkDerivation {
    name = "xgamma-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xgamma-1.0.2.tar.bz2;
      sha256 = "07plrky99vwp13463zbp2fqmyfqkvmxc2ra8iypfy2n61wimngax";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  }) // {inherit libX11 libXxf86vm ;};
    
  xgc = (stdenv.mkDerivation {
    name = "xgc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xgc-1.0.1.tar.bz2;
      sha256 = "14qh1qbqh89aa8xyq6zc6qxk9cpnhm0a6axs5nms8qjgqg3dzbbw";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xhost = (stdenv.mkDerivation {
    name = "xhost-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xhost-1.0.2.tar.bz2;
      sha256 = "1dhdm6dz2jcnb08qlrjn2g1mzv3gfbyq6yqg9kjmh3r3kp22razd";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  }) // {inherit libX11 libXau libXmu ;};
    
  xineramaproto = (stdenv.mkDerivation {
    name = "xineramaproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xineramaproto-1.1.2.tar.bz2;
      sha256 = "0409qj8wdl1c3jchrqvdkl63s8r08gni4xhlxngkpz5wmwf2p9p8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xinit = (stdenv.mkDerivation {
    name = "xinit-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xinit-1.0.5.tar.bz2;
      sha256 = "0bf6y622c0d3i40ch65rs88fjhys1229kdshcy71q91dyf1m5mcm";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xkbcomp = (stdenv.mkDerivation {
    name = "xkbcomp-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xkbcomp-1.0.3.tar.bz2;
      sha256 = "05n7mvw50v575kzsma1f3zp3l8gs2jp7ax4rpbmk7jg3vbjvld86";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbevd = (stdenv.mkDerivation {
    name = "xkbevd-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xkbevd-1.0.2.tar.bz2;
      sha256 = "0azpl6mcvsi718630vv0slls8avixvlsfd7nj614kagrxhbf6y2b";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbprint = (stdenv.mkDerivation {
    name = "xkbprint-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xkbprint-1.0.1.tar.bz2;
      sha256 = "05rfvlla9wpbzlg86j83zf907h8cpywx0h5x7v5q0f11bgmgz380";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbutils = (stdenv.mkDerivation {
    name = "xkbutils-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xkbutils-1.0.1.tar.bz2;
      sha256 = "0mjq2yfd1kp3gasc08k6r0q16k4asdsafsxw3259fr5pipnp7bda";
    };
    buildInputs = [pkgconfig libXaw libX11 libxkbfile ];
  }) // {inherit libXaw libX11 libxkbfile ;};
    
  xkill = (stdenv.mkDerivation {
    name = "xkill-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xkill-1.0.1.tar.bz2;
      sha256 = "1pm92hpq1vnj3zjl12x8d9g6a9nyfyz3ahvvicni7qjadsn1m8bp";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xload = (stdenv.mkDerivation {
    name = "xload-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xload-1.0.2.tar.bz2;
      sha256 = "02y5avipnrf9bvhmrs7172j60w3yq7azs6v3qyqmf9f5xyv7dcc6";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xlogo = (stdenv.mkDerivation {
    name = "xlogo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xlogo-1.0.1.tar.bz2;
      sha256 = "1ci6ylnpsy9sgvkkr1jn3rkklx89x8yfr6zk8ps97zj57nzgjnfy";
    };
    buildInputs = [pkgconfig libXaw libXext libXft libXp libXprintUtil libXrender libXt ];
  }) // {inherit libXaw libXext libXft libXp libXprintUtil libXrender libXt ;};
    
  xlsatoms = (stdenv.mkDerivation {
    name = "xlsatoms-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xlsatoms-1.0.1.tar.bz2;
      sha256 = "0nnm2ss1v93wz4jmlvhgxfsrxkx39g9km2jp2nagqdyv1id5fva5";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsclients = (stdenv.mkDerivation {
    name = "xlsclients-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xlsclients-1.0.1.tar.bz2;
      sha256 = "160nk39dj9h5laxd0gbq7jl47y4ikpjf6kl4wlzm469mvk37334q";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsfonts = (stdenv.mkDerivation {
    name = "xlsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xlsfonts-1.0.1.tar.bz2;
      sha256 = "0857x0px3581b89lgv8q05dlc8aly1q71kpdqviviclr88cjdn68";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmag = (stdenv.mkDerivation {
    name = "xmag-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xmag-1.0.2.tar.bz2;
      sha256 = "0hyshs5afqs56y60li86pw65c07vk1wmkk8kzmkq1pbxc0z99pai";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xman = (stdenv.mkDerivation {
    name = "xman-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xman-1.0.3.tar.bz2;
      sha256 = "0jir4m55jfbpz32bi3s5zc2y8s12jnz3jd9f6iars41x5px3pq1q";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xmessage = (stdenv.mkDerivation {
    name = "xmessage-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xmessage-1.0.2.tar.bz2;
      sha256 = "1hy3n227iyrm323hnrdld8knj9h82fz6s7x6bw899axcjdp03d02";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmh = (stdenv.mkDerivation {
    name = "xmh-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xmh-1.0.1.tar.bz2;
      sha256 = "1yn6q8lrc2ndx60j2d42xagpqn3w86vjlwk5p21cbgz0bi2znwcl";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmodmap = (stdenv.mkDerivation {
    name = "xmodmap-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xmodmap-1.0.3.tar.bz2;
      sha256 = "0zql66q2l8wbldfrzz53vlxpv7p62yhfj6lc2cn24n18g4jcggy3";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmore = (stdenv.mkDerivation {
    name = "xmore-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xmore-1.0.1.tar.bz2;
      sha256 = "09r5iwzarqgyxx36z3vsams5qi08n0a1wqx6y52vqx64ffz6cdb5";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xorgcffiles = (stdenv.mkDerivation {
    name = "xorg-cf-files-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xorg-cf-files-1.0.2.tar.bz2;
      sha256 = "15wmz9whf0j9irz5scqyyic4ardr53r6k15x2wcnxmfkqap16ip3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgdocs = (stdenv.mkDerivation {
    name = "xorg-docs-1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xorg-docs-1.4.tar.bz2;
      sha256 = "09a9va5nljg0cahajadpkkqbhm0r6nl2z12yv7fyd5p31kjngz7z";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgserver = (stdenv.mkDerivation {
    name = "xorg-server-1.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xorg-server-1.4.tar.bz2;
      sha256 = "1hpbq0bl1jkq84gvksp0xzbbrwwgl0wz2wakf11p2hld6bgl5cai";
    };
    buildInputs = [pkgconfig pixman renderproto bigreqsproto compositeproto damageproto dbus.libs libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto hal inputproto kbproto libdrm mkfontdir mkfontscale perl printproto randrproto recordproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ]; mesaSrc = mesa.src; x11BuildHook = ./xorgserver.sh; patches = [./xorgserver-dri-path.patch ./xorgserver-xkbcomp-path.patch ./xorgserver-xkb-leds.patch ]; 
  }) // {inherit pixman renderproto bigreqsproto compositeproto damageproto libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto hal inputproto kbproto libdrm mkfontdir mkfontscale perl printproto randrproto recordproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ;};
    
  xorgsgmldoctools = (stdenv.mkDerivation {
    name = "xorg-sgml-doctools-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xorg-sgml-doctools-1.2.tar.bz2;
      sha256 = "1snvlijv7ycdis0m7zhl6q6ibg2z6as3mdb17dlza0p0w3r7ivsd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xphelloworld = (stdenv.mkDerivation {
    name = "xphelloworld-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xphelloworld-1.0.1.tar.bz2;
      sha256 = "09jlwfbhhxnj46wb4cdhagxfm23gg9qmwryqx5g16nsfpbihijmi";
    };
    buildInputs = [pkgconfig libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ];
  }) // {inherit libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ;};
    
  xplsprinters = (stdenv.mkDerivation {
    name = "xplsprinters-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xplsprinters-1.0.1.tar.bz2;
      sha256 = "0wmhin7z59fb87288gpqx7ia049ly8i51yg7l1slp5z010c0mimd";
    };
    buildInputs = [pkgconfig libX11 libXp libXprintUtil ];
  }) // {inherit libX11 libXp libXprintUtil ;};
    
  xpr = (stdenv.mkDerivation {
    name = "xpr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xpr-1.0.1.tar.bz2;
      sha256 = "0jb2zpq8ibb9s1qmcb6zr6k1m5afd8m0xzp9k01wakyw4cfj4wdq";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xprehashprinterlist = (stdenv.mkDerivation {
    name = "xprehashprinterlist-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xprehashprinterlist-1.0.1.tar.bz2;
      sha256 = "0n82yar7hg1npc63fmxrjj84grr6zivddccip1562gbhdwjyjrxs";
    };
    buildInputs = [pkgconfig libX11 libXp ];
  }) // {inherit libX11 libXp ;};
    
  xprop = (stdenv.mkDerivation {
    name = "xprop-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xprop-1.0.3.tar.bz2;
      sha256 = "19kz6dia3kw44rmmy39g5ygiwbrvgvh7mbq8lnbczd53i2w27nnx";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xproto = (stdenv.mkDerivation {
    name = "xproto-7.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xproto-7.0.10.tar.bz2;
      sha256 = "1x2dg14c1q1gi5sg1lpkw0aqaq6jkkzr8kqq2j3y8h9d4qh9jrbd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xproxymanagementprotocol = (stdenv.mkDerivation {
    name = "xproxymanagementprotocol-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xproxymanagementprotocol-1.0.2.tar.bz2;
      sha256 = "1g0ck81yx1bd0mm4sbf3xk2k1lr5ac7nhx17qlm18p680b87clf4";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xrandr = (stdenv.mkDerivation {
    name = "xrandr-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xrandr-1.2.2.tar.bz2;
      sha256 = "00wkm84radzpvnrk8jbv1sxnkw4sz3jazyvzh1wq4zx0jbs3ybv3";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  }) // {inherit libX11 libXrandr libXrender ;};
    
  xrdb = (stdenv.mkDerivation {
    name = "xrdb-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xrdb-1.0.4.tar.bz2;
      sha256 = "0040krghlckdk2q2mm8ng5krpm0xwlp7lar3bw56vsybx1vxx31z";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xrefresh = (stdenv.mkDerivation {
    name = "xrefresh-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xrefresh-1.0.2.tar.bz2;
      sha256 = "1x9jdgwbd1ying44apk718h1ycbfx411p81mjzr51cn057yk2a2j";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xrx = (stdenv.mkDerivation {
    name = "xrx-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xrx-1.0.1.tar.bz2;
      sha256 = "1r640xhbxbyjbmhxsc3gmsfq3cg8rw65jzw0f7krvxzj0z3cf6m5";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ];
  }) // {inherit libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ;};
    
  xset = (stdenv.mkDerivation {
    name = "xset-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xset-1.0.3.tar.bz2;
      sha256 = "04adhsw6dbigiffr7blpq6nbksai88cnlcalr49xyhi4j3cxfgqf";
    };
    buildInputs = [pkgconfig libX11 libXext libXfontcache libXmu libXp libXxf86misc ];
  }) // {inherit libX11 libXext libXfontcache libXmu libXp libXxf86misc ;};
    
  xsetmode = (stdenv.mkDerivation {
    name = "xsetmode-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xsetmode-1.0.0.tar.bz2;
      sha256 = "1am0mylym97m79n54jvlc45njxdchv1mvqdwmpkcd499jb6lg2wq";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetpointer = (stdenv.mkDerivation {
    name = "xsetpointer-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xsetpointer-1.0.0.tar.bz2;
      sha256 = "0jkxddcf5gv1p1n72vkhfic5m2v0kppcrr1qrx6pckqb898g8rbx";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetroot = (stdenv.mkDerivation {
    name = "xsetroot-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xsetroot-1.0.2.tar.bz2;
      sha256 = "079mld5c05dx2xwhncc94xhrkp4n9388xdncx3x7km1h90gpb6jg";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXmu ];
  }) // {inherit libX11 xbitmaps libXmu ;};
    
  xsm = (stdenv.mkDerivation {
    name = "xsm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xsm-1.0.1.tar.bz2;
      sha256 = "16mjk46iza0sqz2fqik416h77f0r3gm14p5i9c5bwnad76ska99g";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xstdcmap = (stdenv.mkDerivation {
    name = "xstdcmap-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xstdcmap-1.0.1.tar.bz2;
      sha256 = "0f77yxhb7brwjwnf6a3yc1s28kg1ij65lfznk52m3vkx2dh0d4hd";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xtrans = (stdenv.mkDerivation {
    name = "xtrans-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xtrans-1.0.4.tar.bz2;
      sha256 = "133xzvxm3ckgh03cx3z5fqqw4qxz9s74b4qfcnqgzpifhbx1jlkn";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xtrap = (stdenv.mkDerivation {
    name = "xtrap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xtrap-1.0.2.tar.bz2;
      sha256 = "1g0gmvf8fnch5ksq7lky3mbpgmlq19hfaxyllgsdyr8cbfj3slcg";
    };
    buildInputs = [pkgconfig libX11 libXTrap ];
  }) // {inherit libX11 libXTrap ;};
    
  xvidtune = (stdenv.mkDerivation {
    name = "xvidtune-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xvidtune-1.0.1.tar.bz2;
      sha256 = "0dhdfji0di1pjkcnq97y7kgrqn7xh3avjxn7jwfh3mpiq91fn3vd";
    };
    buildInputs = [pkgconfig libXaw libXt libXxf86vm ];
  }) // {inherit libXaw libXt libXxf86vm ;};
    
  xvinfo = (stdenv.mkDerivation {
    name = "xvinfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xvinfo-1.0.2.tar.bz2;
      sha256 = "0l7i9h3r0lzb6kmmcp751i92xml84rhzmz04i5lgj8y759hjlvhj";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  }) // {inherit libX11 libXv ;};
    
  xwd = (stdenv.mkDerivation {
    name = "xwd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xwd-1.0.1.tar.bz2;
      sha256 = "0cg1x9ga5cs2fc8xhgbxbknvyzr9l61kxalys0n9qhyzck6rpgf8";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xwininfo = (stdenv.mkDerivation {
    name = "xwininfo-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xwininfo-1.0.3.tar.bz2;
      sha256 = "12j7lmcdw4km9gm0x0cbmw3f39q54slg47wpb0z13yn6zfma3qzv";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu ];
  }) // {inherit libX11 libXext libXmu ;};
    
  xwud = (stdenv.mkDerivation {
    name = "xwud-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.3/src/everything/xwud-1.0.1.tar.bz2;
      sha256 = "0v1kjdn5y7dh3fcp46z1m90i9d3xx1k1y4rdr6nj77j7nhwjvpnj";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
}
