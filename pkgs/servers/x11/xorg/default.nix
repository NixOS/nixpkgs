# THIS IS A GENERATED FILE.  DO NOT EDIT!
args: with args;

let

  overrides = import ./overrides.nix {inherit args xorg;};

  xorg = rec {

  applewmproto = (stdenv.mkDerivation ((if overrides ? applewmproto then overrides.applewmproto else x: x) {
    name = "applewmproto-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/applewmproto-1.4.1.tar.bz2;
      sha256 = "06fyixmx36qac2qqwmra3l9xr570rankm9kzmk0mgqyhgldrw1h8";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  bdftopcf = (stdenv.mkDerivation ((if overrides ? bdftopcf then overrides.bdftopcf else x: x) {
    name = "bdftopcf-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/bdftopcf-1.0.2.tar.bz2;
      sha256 = "0sx09m677xjvq88sg4yq21y79zck47bvpzanpll35z9psq6py08i";
    };
    buildInputs = [pkgconfig libXfont ];
  })) // {inherit libXfont ;};
    
  bigreqsproto = (stdenv.mkDerivation ((if overrides ? bigreqsproto then overrides.bigreqsproto else x: x) {
    name = "bigreqsproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/bigreqsproto-1.1.0.tar.bz2;
      sha256 = "1g8725413gz4lj4cc8svqvk4b4r9alj84127xslv16as7hny2r28";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  compositeproto = (stdenv.mkDerivation ((if overrides ? compositeproto then overrides.compositeproto else x: x) {
    name = "compositeproto-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/compositeproto-0.4.1.tar.bz2;
      sha256 = "1139c3nqrwx9fca3b4xrf07jdl31g25dbq5d7981c50yfdv4ax72";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  damageproto = (stdenv.mkDerivation ((if overrides ? damageproto then overrides.damageproto else x: x) {
    name = "damageproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/damageproto-1.2.0.tar.bz2;
      sha256 = "13zfd4qni9sw1ym8zd95sk2a39nh50rpwmsnzpbdksif19vm00m5";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  dmxproto = (stdenv.mkDerivation ((if overrides ? dmxproto then overrides.dmxproto else x: x) {
    name = "dmxproto-2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/dmxproto-2.3.tar.bz2;
      sha256 = "1c03qkb7gj1fd84wz5c8kxanvmfpgx06r3j6i4s9wd8z7aj2r21s";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  dri2proto = (stdenv.mkDerivation ((if overrides ? dri2proto then overrides.dri2proto else x: x) {
    name = "dri2proto-2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/dri2proto-2.3.tar.bz2;
      sha256 = "0xz6nf5rrn1fvply5mq7dd1w89r73mggylp9lpzzwdfvl291h55j";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  encodings = (stdenv.mkDerivation ((if overrides ? encodings then overrides.encodings else x: x) {
    name = "encodings-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/encodings-1.0.3.tar.bz2;
      sha256 = "0lqgp2rmygn0dhmjy658cyv6mq2g7a88z7srfb2mmq7b99npdn87";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fixesproto = (stdenv.mkDerivation ((if overrides ? fixesproto then overrides.fixesproto else x: x) {
    name = "fixesproto-4.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/fixesproto-4.1.1.tar.bz2;
      sha256 = "1vv4y5zjlh2x6vbxx1nj770aznrbb1amr57q8wwd1fylda8k4ap7";
    };
    buildInputs = [pkgconfig xextproto ];
  })) // {inherit xextproto ;};
    
  fontadobe100dpi = (stdenv.mkDerivation ((if overrides ? fontadobe100dpi then overrides.fontadobe100dpi else x: x) {
    name = "font-adobe-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-adobe-100dpi-1.0.1.tar.bz2;
      sha256 = "0b5m5iwc6925ysf0ljghx5znh9nkl792l77i26spdyzqsslbqhm7";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobe75dpi = (stdenv.mkDerivation ((if overrides ? fontadobe75dpi then overrides.fontadobe75dpi else x: x) {
    name = "font-adobe-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-adobe-75dpi-1.0.1.tar.bz2;
      sha256 = "0wczvzn5pc3c46xxp4328s207giisy4vwwv5if574w3bs9jigrad";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopia100dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia100dpi then overrides.fontadobeutopia100dpi else x: x) {
    name = "font-adobe-utopia-100dpi-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-adobe-utopia-100dpi-1.0.2.tar.bz2;
      sha256 = "0plmfm3x5lsaa27slslw0sxx4jv9wb6zwwv2n8r957sq15akz36x";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopia75dpi = (stdenv.mkDerivation ((if overrides ? fontadobeutopia75dpi then overrides.fontadobeutopia75dpi else x: x) {
    name = "font-adobe-utopia-75dpi-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-adobe-utopia-75dpi-1.0.2.tar.bz2;
      sha256 = "0mv5pa2x7xvz8cjkcfihnfnl98ljx8bbxdb26qxy2wsvbfxa8g1v";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontadobeutopiatype1 = (stdenv.mkDerivation ((if overrides ? fontadobeutopiatype1 then overrides.fontadobeutopiatype1 else x: x) {
    name = "font-adobe-utopia-type1-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-adobe-utopia-type1-1.0.2.tar.bz2;
      sha256 = "0cz2aqknq4r923v77s9r61bxvxi1jy7igz2c3ff23xjawi92fpwc";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontalias = (stdenv.mkDerivation ((if overrides ? fontalias then overrides.fontalias else x: x) {
    name = "font-alias-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-alias-1.0.2.tar.bz2;
      sha256 = "0w42ndi73wiyrc9zj7g0syxnfq2x2cncjpchm5pdnpihz7rxd2s3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontarabicmisc = (stdenv.mkDerivation ((if overrides ? fontarabicmisc then overrides.fontarabicmisc else x: x) {
    name = "font-arabic-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-arabic-misc-1.0.1.tar.bz2;
      sha256 = "0q3gxbk4wcj1cpw1fhs66vf7ddar8fmkml47g8rlv127zmd31c7l";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbh100dpi = (stdenv.mkDerivation ((if overrides ? fontbh100dpi then overrides.fontbh100dpi else x: x) {
    name = "font-bh-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-100dpi-1.0.1.tar.bz2;
      sha256 = "15rk3k1w12pidz9373y388zqmbrmw13pmj2aydk35689gd46hvf4";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbh75dpi = (stdenv.mkDerivation ((if overrides ? fontbh75dpi then overrides.fontbh75dpi else x: x) {
    name = "font-bh-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-75dpi-1.0.1.tar.bz2;
      sha256 = "0h4xnrbznb2vyy950h9iq0fyxgwpdkw5pb2l424g0sgifylpacca";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter100dpi then overrides.fontbhlucidatypewriter100dpi else x: x) {
    name = "font-bh-lucidatypewriter-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-lucidatypewriter-100dpi-1.0.1.tar.bz2;
      sha256 = "1acd04cd2ls7c1gihywa2hf67ijm7iz4q5c7q9wd9yx3wp2gfml1";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation ((if overrides ? fontbhlucidatypewriter75dpi then overrides.fontbhlucidatypewriter75dpi else x: x) {
    name = "font-bh-lucidatypewriter-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-lucidatypewriter-75dpi-1.0.1.tar.bz2;
      sha256 = "0h9qxgb7v6i12qjyc98ry3ym52a602kkpsvycjb6r4f62icrrzr0";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontbhttf = (stdenv.mkDerivation ((if overrides ? fontbhttf then overrides.fontbhttf else x: x) {
    name = "font-bh-ttf-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-ttf-1.0.1.tar.bz2;
      sha256 = "1j57lzrvnzhi56y7nzz4najymgvf093574czjh77zpy4ls22zrqw";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontbhtype1 = (stdenv.mkDerivation ((if overrides ? fontbhtype1 then overrides.fontbhtype1 else x: x) {
    name = "font-bh-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bh-type1-1.0.1.tar.bz2;
      sha256 = "0idvayiwbysvhmrm0870hpw0cy0hgadcfl0zhgrvmq6dqqk5yfys";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontbitstream100dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream100dpi then overrides.fontbitstream100dpi else x: x) {
    name = "font-bitstream-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bitstream-100dpi-1.0.1.tar.bz2;
      sha256 = "0iq3kzabfvdssivhi4vmzhjan535ws48hxgc8rp0xh0d9nvwj19y";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbitstream75dpi = (stdenv.mkDerivation ((if overrides ? fontbitstream75dpi then overrides.fontbitstream75dpi else x: x) {
    name = "font-bitstream-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bitstream-75dpi-1.0.1.tar.bz2;
      sha256 = "0av66i14x3wj379jkgcjswawkis0imvr31v7wmkaa5qmqaqir7ng";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontbitstreamtype1 = (stdenv.mkDerivation ((if overrides ? fontbitstreamtype1 then overrides.fontbitstreamtype1 else x: x) {
    name = "font-bitstream-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-bitstream-type1-1.0.1.tar.bz2;
      sha256 = "1aqkw51m69k8dlwj3cllnqnfjgvpy59vd8n140v1ah4isk0pq0ji";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontcronyxcyrillic = (stdenv.mkDerivation ((if overrides ? fontcronyxcyrillic then overrides.fontcronyxcyrillic else x: x) {
    name = "font-cronyx-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-cronyx-cyrillic-1.0.1.tar.bz2;
      sha256 = "08ilkby85m8pj2nn3hnfawmxzg8gq36fpw4g7r8i2cgyi913md7p";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontcursormisc = (stdenv.mkDerivation ((if overrides ? fontcursormisc then overrides.fontcursormisc else x: x) {
    name = "font-cursor-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-cursor-misc-1.0.1.tar.bz2;
      sha256 = "1cy1gl9xnkab8ddb1krxpisa2c4cr0h47flsir23b8za3f305vny";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontdaewoomisc = (stdenv.mkDerivation ((if overrides ? fontdaewoomisc then overrides.fontdaewoomisc else x: x) {
    name = "font-daewoo-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-daewoo-misc-1.0.1.tar.bz2;
      sha256 = "14g4wqymc0csnpc0qa0pjndl3wqid13ll2vgk1yfqvy6h113wa72";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontdecmisc = (stdenv.mkDerivation ((if overrides ? fontdecmisc then overrides.fontdecmisc else x: x) {
    name = "font-dec-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-dec-misc-1.0.1.tar.bz2;
      sha256 = "0lk596dw3yk9wspqy167q72r76pwzph9v4rhx0vf41ywzm5dl87v";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontibmtype1 = (stdenv.mkDerivation ((if overrides ? fontibmtype1 then overrides.fontibmtype1 else x: x) {
    name = "font-ibm-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-ibm-type1-1.0.1.tar.bz2;
      sha256 = "06f9dihdss70w3h3rdak1zwkr0gdnryfw2lnsi85rp8grjashzl8";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontisasmisc = (stdenv.mkDerivation ((if overrides ? fontisasmisc then overrides.fontisasmisc else x: x) {
    name = "font-isas-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-isas-misc-1.0.1.tar.bz2;
      sha256 = "0yza5kqj89b81whkrdhficwryhzfgya4w5p8l33lvscixdlh9zjj";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontjismisc = (stdenv.mkDerivation ((if overrides ? fontjismisc then overrides.fontjismisc else x: x) {
    name = "font-jis-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-jis-misc-1.0.1.tar.bz2;
      sha256 = "1kz8ajxsalxhkqbs9m1icwrqji0972f1knqljaa62nrr0k19hfx6";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmicromisc = (stdenv.mkDerivation ((if overrides ? fontmicromisc then overrides.fontmicromisc else x: x) {
    name = "font-micro-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-micro-misc-1.0.1.tar.bz2;
      sha256 = "0awpwich27vhaccrqh6rg330yvfaab0d3jm6d0wzclxz73m8gfd5";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmisccyrillic = (stdenv.mkDerivation ((if overrides ? fontmisccyrillic then overrides.fontmisccyrillic else x: x) {
    name = "font-misc-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-misc-cyrillic-1.0.1.tar.bz2;
      sha256 = "0xdgv2ad4qq1dvp6cy99wmrynri267n8dzbjk5220n6rjgyzpyns";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontmiscethiopic = (stdenv.mkDerivation ((if overrides ? fontmiscethiopic then overrides.fontmiscethiopic else x: x) {
    name = "font-misc-ethiopic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-misc-ethiopic-1.0.1.tar.bz2;
      sha256 = "0j6rsf5nwgm8afvjr6c3ga5rnhpd2dqhwnczsyr4fh3c9fcklfxz";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmeltho = (stdenv.mkDerivation ((if overrides ? fontmiscmeltho then overrides.fontmiscmeltho else x: x) {
    name = "font-misc-meltho-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-misc-meltho-1.0.1.tar.bz2;
      sha256 = "0616v6pamg41q4yhm7wiaycky49hhkfwvabn8r89w64ayfhdfrjk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmisc = (stdenv.mkDerivation ((if overrides ? fontmiscmisc then overrides.fontmiscmisc else x: x) {
    name = "font-misc-misc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-misc-misc-1.1.0.tar.bz2;
      sha256 = "0ys9in88psmxsryci4pq5jj9208jlzamsmfdxw8rlcagp6555xsh";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontmuttmisc = (stdenv.mkDerivation ((if overrides ? fontmuttmisc then overrides.fontmuttmisc else x: x) {
    name = "font-mutt-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-mutt-misc-1.0.1.tar.bz2;
      sha256 = "09bfj00kaf31zncj5k2dm1in5ldp8pmrhrji9vprp16iyp5k7gvp";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontschumachermisc = (stdenv.mkDerivation ((if overrides ? fontschumachermisc then overrides.fontschumachermisc else x: x) {
    name = "font-schumacher-misc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-schumacher-misc-1.1.0.tar.bz2;
      sha256 = "0k8vvssb2dyr9vwal493zkq7x1d0draffvh8wvjzwc1rnmgr20rh";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf fontutil mkfontdir ;};
    
  fontscreencyrillic = (stdenv.mkDerivation ((if overrides ? fontscreencyrillic then overrides.fontscreencyrillic else x: x) {
    name = "font-screen-cyrillic-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-screen-cyrillic-1.0.2.tar.bz2;
      sha256 = "04dyzq73yq0278pk9ssbhb9ia518djgzj9ybi8snvw9zn4gqipf5";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontsonymisc = (stdenv.mkDerivation ((if overrides ? fontsonymisc then overrides.fontsonymisc else x: x) {
    name = "font-sony-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-sony-misc-1.0.1.tar.bz2;
      sha256 = "1jjnzhxzbk2x1byp77yddcni0myd73sxilqj75fkkkkl9j22d5fs";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontsproto = (stdenv.mkDerivation ((if overrides ? fontsproto then overrides.fontsproto else x: x) {
    name = "fontsproto-2.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/fontsproto-2.1.0.tar.bz2;
      sha256 = "0dgb7b49h60wvrcpzax1i7wa03lpkl5f6jkfpb4qh90lr4fzd6js";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontsunmisc = (stdenv.mkDerivation ((if overrides ? fontsunmisc then overrides.fontsunmisc else x: x) {
    name = "font-sun-misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-sun-misc-1.0.1.tar.bz2;
      sha256 = "02cxmssnri09iz2a673f38x3wj94yn96m55b69s1m5cgxbsj45a1";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontutil = (stdenv.mkDerivation ((if overrides ? fontutil then overrides.fontutil else x: x) {
    name = "font-util-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-util-1.1.1.tar.bz2;
      sha256 = "121gq3iiz0hydvcqfh88adrqkky3zs48irjwa31xfgvw1lxiwgx3";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  fontwinitzkicyrillic = (stdenv.mkDerivation ((if overrides ? fontwinitzkicyrillic then overrides.fontwinitzkicyrillic else x: x) {
    name = "font-winitzki-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-winitzki-cyrillic-1.0.1.tar.bz2;
      sha256 = "0ihlvf6rsd8hpdyp09zfisvp44sxdddpi3zbld1ya66vf2gw4mvw";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir ]; configureFlags = "--with-fontrootdir=$(out)/lib/X11/fonts"; 
  })) // {inherit bdftopcf mkfontdir ;};
    
  fontxfree86type1 = (stdenv.mkDerivation ((if overrides ? fontxfree86type1 then overrides.fontxfree86type1 else x: x) {
    name = "font-xfree86-type1-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/font-xfree86-type1-1.0.2.tar.bz2;
      sha256 = "1k86ryqkhq3rrvsz5w7a28i9n5jv29hx6p5kq6r1k9p5mzm6l0ks";
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
    name = "glproto-1.4.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/glproto-1.4.11.tar.bz2;
      sha256 = "0lclh6fnz6k5xqbqarsvzx6sg7gjkprg27k7797xn0agsy4isj7y";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  iceauth = (stdenv.mkDerivation ((if overrides ? iceauth then overrides.iceauth else x: x) {
    name = "iceauth-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/iceauth-1.0.3.tar.bz2;
      sha256 = "07nq2y8py2hvp54dklvv9y8l6b76wlmfkw3llh02dnpjr7v3zjmb";
    };
    buildInputs = [pkgconfig libICE xproto ];
  })) // {inherit libICE xproto ;};
    
  imake = (stdenv.mkDerivation ((if overrides ? imake then overrides.imake else x: x) {
    name = "imake-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/imake-1.0.3.tar.bz2;
      sha256 = "1sjknp0g39r7ywp44drcrb8r92159a9nxgnjc90mjcksvm2540ch";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  inputproto = (stdenv.mkDerivation ((if overrides ? inputproto then overrides.inputproto else x: x) {
    name = "inputproto-2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/inputproto-2.0.tar.bz2;
      sha256 = "1x0sx8ilw857r69ddfr94x66gf8x17284nd20c9hmclajbvmfbs7";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  kbproto = (stdenv.mkDerivation ((if overrides ? kbproto then overrides.kbproto else x: x) {
    name = "kbproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/kbproto-1.0.4.tar.bz2;
      sha256 = "0g30x2jgabp3bx6h556f9777dk384xk45zfzh7mw7l0k2f9jkahv";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  libAppleWM = (stdenv.mkDerivation ((if overrides ? libAppleWM then overrides.libAppleWM else x: x) {
    name = "libAppleWM-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libAppleWM-1.4.0.tar.bz2;
      sha256 = "10hw7rvwc2b0v3v6mc6vaq8xs6vim4bg43rnhspf4p26mlb2dsf8";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  })) // {inherit applewmproto libX11 libXext xextproto ;};
    
  libFS = (stdenv.mkDerivation ((if overrides ? libFS then overrides.libFS else x: x) {
    name = "libFS-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libFS-1.0.2.tar.bz2;
      sha256 = "0j9hrqsn808zpr573p6vnpg17p3nk7ry7d6x1ghjdc52xbjmyamg";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  })) // {inherit fontsproto xproto xtrans ;};
    
  libICE = (stdenv.mkDerivation ((if overrides ? libICE then overrides.libICE else x: x) {
    name = "libICE-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libICE-1.0.6.tar.bz2;
      sha256 = "12sn3d28figzmszcacbcv4v1k03jdp4g2ca5riza4ajxa1cnhd58";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  })) // {inherit xproto xtrans ;};
    
  libSM = (stdenv.mkDerivation ((if overrides ? libSM then overrides.libSM else x: x) {
    name = "libSM-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libSM-1.1.1.tar.bz2;
      sha256 = "1q3wmblw594vzylndcb20cdq3yjgzpy2xmghyhzin0vaii6ih3gm";
    };
    buildInputs = [pkgconfig libICE libuuid xproto xtrans ];
  })) // {inherit libICE libuuid xproto xtrans ;};
    
  libWindowsWM = (stdenv.mkDerivation ((if overrides ? libWindowsWM then overrides.libWindowsWM else x: x) {
    name = "libWindowsWM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libWindowsWM-1.0.1.tar.bz2;
      sha256 = "1p0flwb67xawyv6yhri9w17m1i4lji5qnd0gq8v1vsfb8zw7rw15";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  })) // {inherit windowswmproto libX11 libXext xextproto ;};
    
  libX11 = (stdenv.mkDerivation ((if overrides ? libX11 then overrides.libX11 else x: x) {
    name = "libX11-1.3.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libX11-1.3.4.tar.bz2;
      sha256 = "0i58i744fh9jp0wdyifc9ip5ahvanniyfzana0s15kgpwn627mw8";
    };
    buildInputs = [pkgconfig bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ];
  })) // {inherit bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ;};
    
  libXScrnSaver = (stdenv.mkDerivation ((if overrides ? libXScrnSaver then overrides.libXScrnSaver else x: x) {
    name = "libXScrnSaver-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXScrnSaver-1.2.0.tar.bz2;
      sha256 = "11bz918c8c2r8m5y5rgm25f0xsq7l46g5rdx4r941dif1zn7n1jv";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  })) // {inherit scrnsaverproto libX11 libXext xextproto ;};
    
  libXau = (stdenv.mkDerivation ((if overrides ? libXau then overrides.libXau else x: x) {
    name = "libXau-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXau-1.0.6.tar.bz2;
      sha256 = "1z3h07wj2kg2hnzj4gd9pc3rkj4n0mfw6f9skg9w1hfwzrgl317f";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  libXaw = (stdenv.mkDerivation ((if overrides ? libXaw then overrides.libXaw else x: x) {
    name = "libXaw-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXaw-1.0.7.tar.bz2;
      sha256 = "0a7kqs23c3vwf2gibdm4xw8ylw7fqn0h72c01z4b31lmn3lsw2kl";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXmu libXpm xproto libXt ];
  })) // {inherit libX11 libXext xextproto libXmu libXpm xproto libXt ;};
    
  libXcomposite = (stdenv.mkDerivation ((if overrides ? libXcomposite then overrides.libXcomposite else x: x) {
    name = "libXcomposite-0.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXcomposite-0.4.2.tar.bz2;
      sha256 = "007qcqhp0dhvq2v7nkpz282rbwa6m9pmmpg4ypb30hv8yw5xwas4";
    };
    buildInputs = [pkgconfig compositeproto fixesproto libX11 libXext libXfixes xproto ];
  })) // {inherit compositeproto fixesproto libX11 libXext libXfixes xproto ;};
    
  libXcursor = (stdenv.mkDerivation ((if overrides ? libXcursor then overrides.libXcursor else x: x) {
    name = "libXcursor-1.1.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXcursor-1.1.10.tar.bz2;
      sha256 = "1gbcwf5v108m96y9gpghjb3hv7chvibh1k3b9chc7wh34bv6si5r";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes xproto libXrender ];
  })) // {inherit fixesproto libX11 libXfixes xproto libXrender ;};
    
  libXdamage = (stdenv.mkDerivation ((if overrides ? libXdamage then overrides.libXdamage else x: x) {
    name = "libXdamage-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXdamage-1.1.3.tar.bz2;
      sha256 = "1a678bwap74sqczbr2z4y4fvbr35km3inkm8bi1igjyk4v46jqdw";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes xproto ];
  })) // {inherit damageproto fixesproto libX11 xextproto libXfixes xproto ;};
    
  libXdmcp = (stdenv.mkDerivation ((if overrides ? libXdmcp then overrides.libXdmcp else x: x) {
    name = "libXdmcp-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXdmcp-1.0.3.tar.bz2;
      sha256 = "1jvqfcc7cng7qsdqxj1ivbki3id1kkb3mdqn9zgddzi0mqpkl0yq";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  libXext = (stdenv.mkDerivation ((if overrides ? libXext then overrides.libXext else x: x) {
    name = "libXext-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXext-1.1.2.tar.bz2;
      sha256 = "0x2gzqrdzdzyrw8h9qz4ml8yyplb5ki78pvf17ibdjajkkv0ysmc";
    };
    buildInputs = [pkgconfig libX11 xextproto xproto ];
  })) // {inherit libX11 xextproto xproto ;};
    
  libXfixes = (stdenv.mkDerivation ((if overrides ? libXfixes then overrides.libXfixes else x: x) {
    name = "libXfixes-4.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfixes-4.0.5.tar.bz2;
      sha256 = "0x4drdxrslxf4vgcfyba0f0fbxg98c8x5dfrl7azakhf8qhd0v1f";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  })) // {inherit fixesproto libX11 xextproto xproto ;};
    
  libXfont = (stdenv.mkDerivation ((if overrides ? libXfont then overrides.libXfont else x: x) {
    name = "libXfont-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXfont-1.4.2.tar.bz2;
      sha256 = "0ns99rhfz29y6bbc8slfaxjr132bb9x072vnhgv2kzfbk62mlpyh";
    };
    buildInputs = [pkgconfig libfontenc fontsproto freetype xproto xtrans zlib ];
  })) // {inherit libfontenc fontsproto freetype xproto xtrans zlib ;};
    
  libXft = (stdenv.mkDerivation ((if overrides ? libXft then overrides.libXft else x: x) {
    name = "libXft-2.1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXft-2.1.14.tar.bz2;
      sha256 = "0phpypmkj0dl9vq7wl0jr207gky4s37sbi7sspgx7jl19dcrs3kh";
    };
    buildInputs = [pkgconfig fontconfig freetype libXrender ];
  })) // {inherit fontconfig freetype libXrender ;};
    
  libXi = (stdenv.mkDerivation ((if overrides ? libXi then overrides.libXi else x: x) {
    name = "libXi-1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXi-1.3.tar.bz2;
      sha256 = "0jwl19w8ry30v4wyar3fv9xbhzp3fbx1mq6p7c342s1qc068qarn";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  })) // {inherit inputproto libX11 libXext xextproto xproto ;};
    
  libXinerama = (stdenv.mkDerivation ((if overrides ? libXinerama then overrides.libXinerama else x: x) {
    name = "libXinerama-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXinerama-1.1.tar.bz2;
      sha256 = "0d5zf9ksbhmpmzk5iglkvwvxkf69cl0r3m4dr56b8cg1q9s9xlz0";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  })) // {inherit libX11 libXext xextproto xineramaproto ;};
    
  libXmu = (stdenv.mkDerivation ((if overrides ? libXmu then overrides.libXmu else x: x) {
    name = "libXmu-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXmu-1.0.5.tar.bz2;
      sha256 = "1mr6f4pqzzdpkqghp6jpb9grgc5z4w8hn0hqhjmcy68hxjqbd4h6";
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
    name = "libXpm-3.5.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXpm-3.5.8.tar.bz2;
      sha256 = "0k1cajiw7ijzphrysr2d4yc5s10822nvkbh4xvhkbqz66am7m9q2";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  })) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXrandr = (stdenv.mkDerivation ((if overrides ? libXrandr then overrides.libXrandr else x: x) {
    name = "libXrandr-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXrandr-1.3.0.tar.bz2;
      sha256 = "0y1fh1jf199kdkx7yl8h9azz468pq2d6dvdk1213l5y5fw7wwqar";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto xproto libXrender ];
  })) // {inherit randrproto renderproto libX11 libXext xextproto xproto libXrender ;};
    
  libXrender = (stdenv.mkDerivation ((if overrides ? libXrender then overrides.libXrender else x: x) {
    name = "libXrender-0.9.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXrender-0.9.6.tar.bz2;
      sha256 = "0s567qgys8m6782lbrpvpscm8fkk2jm2717g7s3hm7hhcgib2n3z";
    };
    buildInputs = [pkgconfig renderproto libX11 xproto ];
  })) // {inherit renderproto libX11 xproto ;};
    
  libXres = (stdenv.mkDerivation ((if overrides ? libXres then overrides.libXres else x: x) {
    name = "libXres-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXres-1.0.4.tar.bz2;
      sha256 = "1pvjfn3mczr788x4nh877f911w63abx7z29gng7ri1zgf1x5czs5";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto xproto ];
  })) // {inherit resourceproto libX11 libXext xextproto xproto ;};
    
  libXt = (stdenv.mkDerivation ((if overrides ? libXt then overrides.libXt else x: x) {
    name = "libXt-1.0.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXt-1.0.8.tar.bz2;
      sha256 = "0z03nbb0lhxshpnyx2nl9kw0n3civjkag1mfiqf82qc64n0jrxbh";
    };
    buildInputs = [pkgconfig libICE kbproto libSM libX11 xproto ];
  })) // {inherit libICE kbproto libSM libX11 xproto ;};
    
  libXtst = (stdenv.mkDerivation ((if overrides ? libXtst then overrides.libXtst else x: x) {
    name = "libXtst-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXtst-1.1.0.tar.bz2;
      sha256 = "09pblj4h8i6fdl553lsgn511vgygl6jq4dx83chmfsg0g53hyi5x";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto libXi ];
  })) // {inherit inputproto recordproto libX11 libXext xextproto libXi ;};
    
  libXv = (stdenv.mkDerivation ((if overrides ? libXv then overrides.libXv else x: x) {
    name = "libXv-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXv-1.0.5.tar.bz2;
      sha256 = "0430v78igg9hgkf5alj3sb20i7xg88if3pl5r9ybkvzy4bgsyjfm";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto ];
  })) // {inherit videoproto libX11 libXext xextproto xproto ;};
    
  libXvMC = (stdenv.mkDerivation ((if overrides ? libXvMC then overrides.libXvMC else x: x) {
    name = "libXvMC-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXvMC-1.0.5.tar.bz2;
      sha256 = "0zyyiwrfx303lfcb8av4apbql2r2w34rzc0czq7ayhw3s9lcfi06";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto xproto libXv ];
  })) // {inherit videoproto libX11 libXext xextproto xproto libXv ;};
    
  libXxf86dga = (stdenv.mkDerivation ((if overrides ? libXxf86dga then overrides.libXxf86dga else x: x) {
    name = "libXxf86dga-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXxf86dga-1.1.1.tar.bz2;
      sha256 = "05jnvsl70c1dgvkldrgaqsjq72ar0papprx346w5rwfgbs4zhdwd";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};
    
  libXxf86misc = (stdenv.mkDerivation ((if overrides ? libXxf86misc then overrides.libXxf86misc else x: x) {
    name = "libXxf86misc-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libXxf86misc-1.0.2.tar.bz2;
      sha256 = "1cvwjl4f83ic97j9da95x2a7gd0hw5vnv1pxn49d3z1lpyqvcr4f";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};
    
  libXxf86vm = (stdenv.mkDerivation ((if overrides ? libXxf86vm then overrides.libXxf86vm else x: x) {
    name = "libXxf86vm-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libXxf86vm-1.1.0.tar.bz2;
      sha256 = "1s4dhgl879hkfys28gl3rflas4ci48kiyx359rzjdi9pndvybibw";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  })) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};
    
  libdmx = (stdenv.mkDerivation ((if overrides ? libdmx then overrides.libdmx else x: x) {
    name = "libdmx-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libdmx-1.1.0.tar.bz2;
      sha256 = "1mg2sd8xlwcz6lysdc3zld05a2fa1a4hfxxhbh87cpfc93wah10r";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  })) // {inherit dmxproto libX11 libXext xextproto ;};
    
  libfontenc = (stdenv.mkDerivation ((if overrides ? libfontenc then overrides.libfontenc else x: x) {
    name = "libfontenc-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libfontenc-1.0.5.tar.bz2;
      sha256 = "001749s6whw04fv0426zk48p0wqn29g2ba5i42kkvbg9641xwg3z";
    };
    buildInputs = [pkgconfig xproto zlib ];
  })) // {inherit xproto zlib ;};
    
  libpciaccess = (stdenv.mkDerivation ((if overrides ? libpciaccess then overrides.libpciaccess else x: x) {
    name = "libpciaccess-0.12.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/libpciaccess-0.12.0.tar.bz2;
      sha256 = "0msnx3mcbqgghjscq3z1nh894k71k3bx659iaqlhgaqa3h7c1czn";
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
    name = "libxcb-1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.6.tar.bz2;
      sha256 = "0di9mm6d8wmscgfaw6sfa8znrk522y8dnl4xhy87wqx4fhbwirhs";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs python libXau xcbproto libXdmcp ];
  })) // {inherit libxslt libpthreadstubs python libXau xcbproto libXdmcp ;};
    
  libxkbfile = (stdenv.mkDerivation ((if overrides ? libxkbfile then overrides.libxkbfile else x: x) {
    name = "libxkbfile-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/libxkbfile-1.0.6.tar.bz2;
      sha256 = "0fb0l221m5fsifydrih3fg6ndlsrm0d4fa53cx0rk0i7dcgkr91c";
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
    name = "luit-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/luit-1.0.4.tar.bz2;
      sha256 = "0ll2rcg65h0gd18jkj56kbp9j7816j0cnycxz1h20razjw0da76i";
    };
    buildInputs = [pkgconfig libfontenc libX11 zlib ];
  })) // {inherit libfontenc libX11 zlib ;};
    
  makedepend = (stdenv.mkDerivation ((if overrides ? makedepend then overrides.makedepend else x: x) {
    name = "makedepend-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/makedepend-1.0.2.tar.bz2;
      sha256 = "0mvnjrx161wrzn602c3fd012fixsi8j74dvqahk5nz1dlf8b18j1";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  mkfontdir = (stdenv.mkDerivation ((if overrides ? mkfontdir then overrides.mkfontdir else x: x) {
    name = "mkfontdir-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/mkfontdir-1.0.5.tar.bz2;
      sha256 = "02rd3b8gp3dxfws2fff07fcxm0z2rlbdhxqm23wijdjhzw66ad55";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  mkfontscale = (stdenv.mkDerivation ((if overrides ? mkfontscale then overrides.mkfontscale else x: x) {
    name = "mkfontscale-1.0.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/mkfontscale-1.0.7.tar.bz2;
      sha256 = "09vivvbw6hbx7n1aq4k4gp23g3pp1bv1zjw2cmm22cx2rhlv41l3";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  })) // {inherit libfontenc freetype xproto zlib ;};
    
  pixman = (stdenv.mkDerivation ((if overrides ? pixman then overrides.pixman else x: x) {
    name = "pixman-0.18.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/lib/pixman-0.18.2.tar.bz2;
      sha256 = "08rr88cy33k427vyxryxa9yssfy6j9s9m1vcvqmjl2949qv63818";
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
    name = "randrproto-1.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/randrproto-1.3.1.tar.bz2;
      sha256 = "1jl5k46lq4p1jv4mfdpj8zp4m79wzfnyxq97dbd4a2kimv0a6g6r";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  recordproto = (stdenv.mkDerivation ((if overrides ? recordproto then overrides.recordproto else x: x) {
    name = "recordproto-1.14";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/recordproto-1.14.tar.bz2;
      sha256 = "0ryhd6g2h7bg7vzf7dvfgf3n2bbscpqhr9x01alkxamxs9dkglhv";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  renderproto = (stdenv.mkDerivation ((if overrides ? renderproto then overrides.renderproto else x: x) {
    name = "renderproto-0.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/renderproto-0.11.tar.bz2;
      sha256 = "1hpzxlmk4hylriqx10h9ixq64ksk3lbhr2cli8r9mvdnn3cxdlf4";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  resourceproto = (stdenv.mkDerivation ((if overrides ? resourceproto then overrides.resourceproto else x: x) {
    name = "resourceproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/resourceproto-1.1.0.tar.bz2;
      sha256 = "0sxk97siq4qkm4r0q6c4fdb7glbasbbx1lj4p0dis574cyq9m3a0";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  scrnsaverproto = (stdenv.mkDerivation ((if overrides ? scrnsaverproto then overrides.scrnsaverproto else x: x) {
    name = "scrnsaverproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/scrnsaverproto-1.2.0.tar.bz2;
      sha256 = "16adwjq9cnf15a4gv87c0s1kkwm1w1k3lg1s6nmhszk128r0mbyy";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  sessreg = (stdenv.mkDerivation ((if overrides ? sessreg then overrides.sessreg else x: x) {
    name = "sessreg-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/sessreg-1.0.5.tar.bz2;
      sha256 = "1afir60wikx4xx0d5mbk01s5p5l4wk6y37gfiy0vnlwd078gn21k";
    };
    buildInputs = [pkgconfig xproto ];
  })) // {inherit xproto ;};
    
  setxkbmap = (stdenv.mkDerivation ((if overrides ? setxkbmap then overrides.setxkbmap else x: x) {
    name = "setxkbmap-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/setxkbmap-1.1.0.tar.bz2;
      sha256 = "0r5g9wyyywp90hclhvqkiq6nbgrs0wrwcqvds76dzxjb98qjnbwk";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  smproxy = (stdenv.mkDerivation ((if overrides ? smproxy then overrides.smproxy else x: x) {
    name = "smproxy-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/smproxy-1.0.3.tar.bz2;
      sha256 = "0ddfsh2mf938xvac6179cnf8n8n47njb8xyrlyjc43r8hdad538v";
    };
    buildInputs = [pkgconfig libXmu libXt ];
  })) // {inherit libXmu libXt ;};
    
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
    name = "util-macros-1.10.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/util-macros-1.10.0.tar.bz2;
      sha256 = "0a8in00qqyksij66wgk1m1cp6n4lii88a0c6g1s7cqshwp5b6lmr";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  videoproto = (stdenv.mkDerivation ((if overrides ? videoproto then overrides.videoproto else x: x) {
    name = "videoproto-2.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/videoproto-2.3.0.tar.bz2;
      sha256 = "0pq46hgnrx459v7rlskzk50qi7llk358j9csbbrxcq0vb97cjasg";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  windowswmproto = (stdenv.mkDerivation ((if overrides ? windowswmproto then overrides.windowswmproto else x: x) {
    name = "windowswmproto-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/windowswmproto-1.0.4.tar.bz2;
      sha256 = "0syjxgy4m8l94qrm03nvn5k6bkxc8knnlld1gbllym97nvnv0ny0";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  x11perf = (stdenv.mkDerivation ((if overrides ? x11perf then overrides.x11perf else x: x) {
    name = "x11perf-1.5.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/x11perf-1.5.1.tar.bz2;
      sha256 = "0mkhzxvjn9n5ax013wj3lz7jmlm07l57ds2vxy2r9ylkkxbnlk5b";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  })) // {inherit libX11 libXext libXft libXmu libXrender ;};
    
  xauth = (stdenv.mkDerivation ((if overrides ? xauth then overrides.xauth else x: x) {
    name = "xauth-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xauth-1.0.4.tar.bz2;
      sha256 = "0nba0xg19y124cswy37ds5dmxfw4avd303xhhq5jf65vp34904gr";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  })) // {inherit libX11 libXau libXext libXmu ;};
    
  xbacklight = (stdenv.mkDerivation ((if overrides ? xbacklight then overrides.xbacklight else x: x) {
    name = "xbacklight-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xbacklight-1.1.1.tar.bz2;
      sha256 = "1ckgc3mbi5z3wv1fa9nf4yv028xh9911qkqz4f4h171vr28xhcjx";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  })) // {inherit libX11 libXrandr libXrender ;};
    
  xbitmaps = (stdenv.mkDerivation ((if overrides ? xbitmaps then overrides.xbitmaps else x: x) {
    name = "xbitmaps-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xbitmaps-1.1.0.tar.bz2;
      sha256 = "0qc7mmljabh06s4vkz9nkrca1d3f5yr7nr3927pbfdh6iff0b8n9";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xcbproto = (stdenv.mkDerivation ((if overrides ? xcbproto then overrides.xcbproto else x: x) {
    name = "xcb-proto-1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.6.tar.bz2;
      sha256 = "18jwkgd2ayvd0zzwawnbh86b4xqjq29mgsq44h06yj8jkcaw2azm";
    };
    buildInputs = [pkgconfig python ];
  })) // {inherit python ;};
    
  xcbutil = (stdenv.mkDerivation ((if overrides ? xcbutil then overrides.xcbutil else x: x) {
    name = "xcb-util-0.3.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.3.6.tar.bz2;
      sha256 = "0mqfyq6skm19hhfmd5kmcn0v4di4pmbdszmbf2lmhn01mc8yxf7z";
    };
    buildInputs = [pkgconfig gperf m4 libxcb xproto ];
  })) // {inherit gperf m4 libxcb xproto ;};
    
  xclock = (stdenv.mkDerivation ((if overrides ? xclock then overrides.xclock else x: x) {
    name = "xclock-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xclock-1.0.4.tar.bz2;
      sha256 = "1w7dwrxjwhllynvkvms236jnls8aik8g755kbpycj4aj62v07fb9";
    };
    buildInputs = [pkgconfig libX11 libXaw libXft libxkbfile libXrender libXt ];
  })) // {inherit libX11 libXaw libXft libxkbfile libXrender libXt ;};
    
  xcmiscproto = (stdenv.mkDerivation ((if overrides ? xcmiscproto then overrides.xcmiscproto else x: x) {
    name = "xcmiscproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xcmiscproto-1.2.0.tar.bz2;
      sha256 = "13pnmizik323jdzdrhf3vyibmf63qmv4wcly8smyki85f1mw05yy";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xcmsdb = (stdenv.mkDerivation ((if overrides ? xcmsdb then overrides.xcmsdb else x: x) {
    name = "xcmsdb-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xcmsdb-1.0.2.tar.bz2;
      sha256 = "1kps2q1gr9l168agqmsk6l9xp2b01qbs9j7i0wb4lkga6ikcdjmz";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xcursorgen = (stdenv.mkDerivation ((if overrides ? xcursorgen then overrides.xcursorgen else x: x) {
    name = "xcursorgen-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xcursorgen-1.0.3.tar.bz2;
      sha256 = "0m62paz36b38bx9xpb79qmf9im1yamgmlvj0hp5gy88wi3z3ypzd";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  })) // {inherit libpng libX11 libXcursor ;};
    
  xcursorthemes = (stdenv.mkDerivation ((if overrides ? xcursorthemes then overrides.xcursorthemes else x: x) {
    name = "xcursor-themes-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xcursor-themes-1.0.2.tar.bz2;
      sha256 = "1mhlfnjdq5c0h9k2h088fq82bdsr0g2001x4l2gw15173lpqqyaz";
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
    name = "xdpyinfo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xdpyinfo-1.1.0.tar.bz2;
      sha256 = "0c86d890bbdswhpnknlfn1xg5xbjgymjhnfk4vp44gv5cpz8s3bq";
    };
    buildInputs = [pkgconfig libdmx libX11 libXcomposite libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  })) // {inherit libdmx libX11 libXcomposite libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};
    
  xdriinfo = (stdenv.mkDerivation ((if overrides ? xdriinfo then overrides.xdriinfo else x: x) {
    name = "xdriinfo-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xdriinfo-1.0.3.tar.bz2;
      sha256 = "1715vk6vhxdsn7ir3gd2gy90b4d31llddkysssgxg66713yjlxib";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  })) // {inherit glproto libX11 ;};
    
  xev = (stdenv.mkDerivation ((if overrides ? xev then overrides.xev else x: x) {
    name = "xev-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xev-1.0.4.tar.bz2;
      sha256 = "1s7x06jw3y6blq4nfgm8m55jphp933idwcs6yivyc956anbrrbbz";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xextproto = (stdenv.mkDerivation ((if overrides ? xextproto then overrides.xextproto else x: x) {
    name = "xextproto-7.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xextproto-7.1.1.tar.bz2;
      sha256 = "16adjr7hfzf5qaikrq7341p2g6n2nj8gvxgc9jr2qz6mvlqvs2kd";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xeyes = (stdenv.mkDerivation ((if overrides ? xeyes then overrides.xeyes else x: x) {
    name = "xeyes-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xeyes-1.1.0.tar.bz2;
      sha256 = "01ymjkdhz0jrra47l1cqc4vkklaw3frmzgwwvq6jyvm0zr0rcswr";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXrender libXt ];
  })) // {inherit libX11 libXext libXmu libXrender libXt ;};
    
  xf86bigfontproto = (stdenv.mkDerivation ((if overrides ? xf86bigfontproto then overrides.xf86bigfontproto else x: x) {
    name = "xf86bigfontproto-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86bigfontproto-1.2.0.tar.bz2;
      sha256 = "0j0n7sj5xfjpmmgx6n5x556rw21hdd18fwmavp95wps7qki214ms";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86dgaproto = (stdenv.mkDerivation ((if overrides ? xf86dgaproto then overrides.xf86dgaproto else x: x) {
    name = "xf86dgaproto-2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86dgaproto-2.1.tar.bz2;
      sha256 = "0l4hx48207mx0hp09026r6gy9nl3asbq0c75hri19wp1118zcpmc";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86driproto = (stdenv.mkDerivation ((if overrides ? xf86driproto then overrides.xf86driproto else x: x) {
    name = "xf86driproto-2.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86driproto-2.1.0.tar.bz2;
      sha256 = "1gp1vkzypwnd9lvn23vzazl6xxm77vgsgmkyi4p5hgnhzzg14gyj";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xf86inputacecad = (stdenv.mkDerivation ((if overrides ? xf86inputacecad then overrides.xf86inputacecad else x: x) {
    name = "xf86-input-acecad-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-acecad-1.4.0.tar.bz2;
      sha256 = "0mnmvffxwgcvsa208vffsqlai7lldjc46rdk6j0j4q00df5isd28";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputaiptek = (stdenv.mkDerivation ((if overrides ? xf86inputaiptek then overrides.xf86inputaiptek else x: x) {
    name = "xf86-input-aiptek-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-aiptek-1.3.0.tar.bz2;
      sha256 = "0p2ygfh883wbwk5n1ippd7f562bwrsvbpgriqwvw7zqx0axkazxk";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputevdev = (stdenv.mkDerivation ((if overrides ? xf86inputevdev then overrides.xf86inputevdev else x: x) {
    name = "xf86-input-evdev-2.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-input-evdev-2.4.0.tar.bz2;
      sha256 = "0sl02sx755j5kg9sd762sgqk2gnvkhj3pm76l47qhw0a2jvqmx4f";
    };
    buildInputs = [pkgconfig inputproto xorgserver xproto ];
  })) // {inherit inputproto xorgserver xproto ;};
    
  xf86inputjoystick = (stdenv.mkDerivation ((if overrides ? xf86inputjoystick then overrides.xf86inputjoystick else x: x) {
    name = "xf86-input-joystick-1.4.99.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-joystick-1.4.99.2.tar.bz2;
      sha256 = "1fsjabi8221wi1xnqla1kdawng91h6s8nkhh992jsdk0hlxfj93j";
    };
    buildInputs = [pkgconfig inputproto kbproto xorgserver xproto ];
  })) // {inherit inputproto kbproto xorgserver xproto ;};
    
  xf86inputkeyboard = (stdenv.mkDerivation ((if overrides ? xf86inputkeyboard then overrides.xf86inputkeyboard else x: x) {
    name = "xf86-input-keyboard-1.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-keyboard-1.4.0.tar.bz2;
      sha256 = "19fnlr555pf5y0s01mlhski6v9rvsjzp6b2n5i7sppb8rb7kcbc4";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  })) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputmouse = (stdenv.mkDerivation ((if overrides ? xf86inputmouse then overrides.xf86inputmouse else x: x) {
    name = "xf86-input-mouse-1.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-mouse-1.5.0.tar.bz2;
      sha256 = "15xk3a6ld9zphqhfm1w69cmnsd13fz8k9xx70w7b4bxbf84f40zk";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputsynaptics = (stdenv.mkDerivation ((if overrides ? xf86inputsynaptics then overrides.xf86inputsynaptics else x: x) {
    name = "xf86-input-synaptics-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-synaptics-1.2.0.tar.bz2;
      sha256 = "033232bvvy0ibr6w0fmcm3mjv212fl2bywj22d32wbxd4m6avmfx";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXi xorgserver xproto libXtst ];
  })) // {inherit inputproto recordproto libX11 libXi xorgserver xproto libXtst ;};
    
  xf86inputvmmouse = (stdenv.mkDerivation ((if overrides ? xf86inputvmmouse then overrides.xf86inputvmmouse else x: x) {
    name = "xf86-input-vmmouse-12.6.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-vmmouse-12.6.5.tar.bz2;
      sha256 = "03ccsqs5hyrjspfaww8dwia01iz98nczqj27bd1bpxs7vjww66iq";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  })) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvoid = (stdenv.mkDerivation ((if overrides ? xf86inputvoid then overrides.xf86inputvoid else x: x) {
    name = "xf86-input-void-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-input-void-1.3.0.tar.bz2;
      sha256 = "03qk5gaw8msmi39m6024p61b0faw91b3vn257hdy40vpcggms5p2";
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
    name = "xf86-video-apm-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-apm-1.2.2.tar.bz2;
      sha256 = "0lhp3karp7v59p4i7lxk8yc5amsqihwa5pfcf9zpqphx7q3dv3k7";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoark = (stdenv.mkDerivation ((if overrides ? xf86videoark then overrides.xf86videoark else x: x) {
    name = "xf86-video-ark-0.7.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-ark-0.7.2.tar.bz2;
      sha256 = "0hap0q41bxq10a2jxbkpb93ad7zxbl1l64bcy4vjhf5xbvhz67nv";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoast = (stdenv.mkDerivation ((if overrides ? xf86videoast then overrides.xf86videoast else x: x) {
    name = "xf86-video-ast-0.89.9";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-ast-0.89.9.tar.bz2;
      sha256 = "00dllv1vs8xg9gbsabixsz846xd9y6ijibpl2ljhafip5b9ic3w8";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoati = (stdenv.mkDerivation ((if overrides ? xf86videoati then overrides.xf86videoati else x: x) {
    name = "xf86-video-ati-6.12.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-ati-6.12.4.tar.bz2;
      sha256 = "1xiqyf5pa8k0mva3ikq2i1xq8yn9lswmrsbr9xi9p8c7f1m0dpng";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};
    
  xf86videochips = (stdenv.mkDerivation ((if overrides ? xf86videochips then overrides.xf86videochips else x: x) {
    name = "xf86-video-chips-1.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-chips-1.2.2.tar.bz2;
      sha256 = "03kz0gvg0ryynj4pllbismb77aq2wmsy7zpk4cxynby6zwnfyvzz";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocirrus = (stdenv.mkDerivation ((if overrides ? xf86videocirrus then overrides.xf86videocirrus else x: x) {
    name = "xf86-video-cirrus-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-cirrus-1.3.2.tar.bz2;
      sha256 = "06na525xy5d6xf5g13bjsk9cyxly5arzgrk9j8dmxfll5jj9i6jj";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videodummy = (stdenv.mkDerivation ((if overrides ? xf86videodummy then overrides.xf86videodummy else x: x) {
    name = "xf86-video-dummy-0.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-dummy-0.3.2.tar.bz2;
      sha256 = "1yj5bk79lxdqrdivznqxpds7dh2fdx3d9anz1y990pqb3g1cp2ck";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};
    
  xf86videofbdev = (stdenv.mkDerivation ((if overrides ? xf86videofbdev then overrides.xf86videofbdev else x: x) {
    name = "xf86-video-fbdev-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-fbdev-0.4.1.tar.bz2;
      sha256 = "13r8nwl8z0kwqvgmiaj9wrjwid4d55cs1vn6qsf3lhr3jlbmgy1b";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videogeode = (stdenv.mkDerivation ((if overrides ? xf86videogeode then overrides.xf86videogeode else x: x) {
    name = "xf86-video-geode-2.11.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-geode-2.11.6.tar.bz2;
      sha256 = "148zfkxzw3g56wbhfix4ggw781szbay3rrrjgyji7nq8pi3xl6ja";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videoglide = (stdenv.mkDerivation ((if overrides ? xf86videoglide then overrides.xf86videoglide else x: x) {
    name = "xf86-video-glide-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-glide-1.0.3.tar.bz2;
      sha256 = "1n76g133iq5pd8pll9k37j2szp8py2qmzr6w0r5jhd13lrazi1gi";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoglint = (stdenv.mkDerivation ((if overrides ? xf86videoglint then overrides.xf86videoglint else x: x) {
    name = "xf86-video-glint-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-glint-1.2.4.tar.bz2;
      sha256 = "0vypk7njd6927imi80akfyd6q2wl1d8ragg6p8sx4qf208xnx3az";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};
    
  xf86videoi128 = (stdenv.mkDerivation ((if overrides ? xf86videoi128 then overrides.xf86videoi128 else x: x) {
    name = "xf86-video-i128-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-i128-1.3.3.tar.bz2;
      sha256 = "0bmh6adk0pkzkcn0p4xkfi8r2hmya1rp2d6c0mfhfm1viv7921jd";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi740 = (stdenv.mkDerivation ((if overrides ? xf86videoi740 then overrides.xf86videoi740 else x: x) {
    name = "xf86-video-i740-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-i740-1.3.2.tar.bz2;
      sha256 = "0hzr5fz6d5jk9jxh9plfgvgias3w7xzyg1n4gx0hs2lc7mm9qm28";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videointel = (stdenv.mkDerivation ((if overrides ? xf86videointel then overrides.xf86videointel else x: x) {
    name = "xf86-video-intel-2.12.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-intel-2.12.0.tar.bz2;
      sha256 = "1pzzzpw0i55m6s48ac8c3a0453rskqrdb4v6s9dq5bvj3ywpysz1";
    };
    buildInputs = [pkgconfig dri2proto fontsproto glproto libdrm libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ];
  })) // {inherit dri2proto fontsproto glproto libdrm libpciaccess randrproto renderproto libX11 xcbutil libxcb libXext xextproto xf86driproto libXfixes xorgserver xproto libXvMC ;};
    
  xf86videomach64 = (stdenv.mkDerivation ((if overrides ? xf86videomach64 then overrides.xf86videomach64 else x: x) {
    name = "xf86-video-mach64-6.8.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-mach64-6.8.2.tar.bz2;
      sha256 = "07b7dkb6xc10pvf483dg52r2klpikmw339i5ln9ig913601r84dr";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videomga = (stdenv.mkDerivation ((if overrides ? xf86videomga then overrides.xf86videomga else x: x) {
    name = "xf86-video-mga-1.4.11";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-mga-1.4.11.tar.bz2;
      sha256 = "1rlp1ywvcfk04p7h5n0s2pm7r4d7jkzr5nnv3pa78vs8dwqj46f9";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videoneomagic = (stdenv.mkDerivation ((if overrides ? xf86videoneomagic then overrides.xf86videoneomagic else x: x) {
    name = "xf86-video-neomagic-1.2.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-neomagic-1.2.4.tar.bz2;
      sha256 = "0lw3i7dkrg98dzjdci6yf4dn3a9j2rmd31hab7s46wh0dnca4ka3";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonewport = (stdenv.mkDerivation ((if overrides ? xf86videonewport then overrides.xf86videonewport else x: x) {
    name = "xf86-video-newport-0.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-newport-0.2.3.tar.bz2;
      sha256 = "0w02rz49gipnfl33vak3zgis8bh9i0v5ykyj8qh9vzddjm7ypjp6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videonv = (stdenv.mkDerivation ((if overrides ? xf86videonv then overrides.xf86videonv else x: x) {
    name = "xf86-video-nv-2.1.15";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-nv-2.1.15.tar.bz2;
      sha256 = "0h9nbbp4dd4lcm9bjmfgv9p9pdq6hj535mnjf70xkkip0i0y1361";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoopenchrome = (stdenv.mkDerivation ((if overrides ? xf86videoopenchrome then overrides.xf86videoopenchrome else x: x) {
    name = "xf86-video-openchrome-0.2.904";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-openchrome-0.2.904.tar.bz2;
      sha256 = "1sksddn0pc3izvab5ppxhprs1xzk5ijwqz5ylivx1cb5hg2gggf7";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videor128 = (stdenv.mkDerivation ((if overrides ? xf86videor128 then overrides.xf86videor128 else x: x) {
    name = "xf86-video-r128-6.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-r128-6.8.1.tar.bz2;
      sha256 = "1jlybabm3k09hhlzx1xilndqngk3xgdck66n94sr02w5hg622zji";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videorendition = (stdenv.mkDerivation ((if overrides ? xf86videorendition then overrides.xf86videorendition else x: x) {
    name = "xf86-video-rendition-4.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-rendition-4.2.3.tar.bz2;
      sha256 = "152dfsjf75xbkl8a2xlpr1pl5365b3svhfj9y9dfxzi963ymjmcx";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videos3 = (stdenv.mkDerivation ((if overrides ? xf86videos3 then overrides.xf86videos3 else x: x) {
    name = "xf86-video-s3-0.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-s3-0.6.3.tar.bz2;
      sha256 = "0i2i1080cw3pxy1pm43bskb80n7wql0cxpyd2s61v0didsm6b7zd";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videos3virge = (stdenv.mkDerivation ((if overrides ? xf86videos3virge then overrides.xf86videos3virge else x: x) {
    name = "xf86-video-s3virge-1.10.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-s3virge-1.10.4.tar.bz2;
      sha256 = "1f3zjs6a3j2a8lfdilijggpwbg9cs88qksrvzvd71ggxf5p0vl0w";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosavage = (stdenv.mkDerivation ((if overrides ? xf86videosavage then overrides.xf86videosavage else x: x) {
    name = "xf86-video-savage-2.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-savage-2.3.1.tar.bz2;
      sha256 = "1ays1l4phyjcdikc9d1zwgswivcrb1grkh7klv5klvqahbfxqjib";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosiliconmotion = (stdenv.mkDerivation ((if overrides ? xf86videosiliconmotion then overrides.xf86videosiliconmotion else x: x) {
    name = "xf86-video-siliconmotion-1.7.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-siliconmotion-1.7.3.tar.bz2;
      sha256 = "0aqb0sl2ds6n3wqq452xn6d5zkavryiks154xa6c1596wj5ldnpb";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosis = (stdenv.mkDerivation ((if overrides ? xf86videosis then overrides.xf86videosis else x: x) {
    name = "xf86-video-sis-0.10.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-sis-0.10.2.tar.bz2;
      sha256 = "1hi8h7ixfbwhnqiara9xx5y6pzi3svnvma97j2dncmg3k4bp1b9s";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xineramaproto xorgserver xproto ;};
    
  xf86videosisusb = (stdenv.mkDerivation ((if overrides ? xf86videosisusb then overrides.xf86videosisusb else x: x) {
    name = "xf86-video-sisusb-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-sisusb-0.9.3.tar.bz2;
      sha256 = "1clvnjkjzs2fmjm58fv31x6b5nk6y5ahb5vwvrizpm9irh7aky8x";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ;};
    
  xf86videosuncg14 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg14 then overrides.xf86videosuncg14 else x: x) {
    name = "xf86-video-suncg14-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-suncg14-1.1.1.tar.bz2;
      sha256 = "1n108xbwg803v2sk51galx66ph8wdb0ym84fx45h0jrr41wh0hyb";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg3 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg3 then overrides.xf86videosuncg3 else x: x) {
    name = "xf86-video-suncg3-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-suncg3-1.1.1.tar.bz2;
      sha256 = "06c4hzmd5cfzbw79yrv3knss80hllciamz734ij1pbzj6j6fjvym";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg6 = (stdenv.mkDerivation ((if overrides ? xf86videosuncg6 then overrides.xf86videosuncg6 else x: x) {
    name = "xf86-video-suncg6-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-suncg6-1.1.1.tar.bz2;
      sha256 = "07w0hm63fiy5l3cpcjsl0ig8z84z9r36xm0cmnpiv3g75dy6q8fi";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosunffb = (stdenv.mkDerivation ((if overrides ? xf86videosunffb then overrides.xf86videosunffb else x: x) {
    name = "xf86-video-sunffb-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-sunffb-1.2.1.tar.bz2;
      sha256 = "04byax4sc1fn183vyyq0q11q730k16h2by4ggjky7s36wgv7ldzx";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videosunleo = (stdenv.mkDerivation ((if overrides ? xf86videosunleo then overrides.xf86videosunleo else x: x) {
    name = "xf86-video-sunleo-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-sunleo-1.2.0.tar.bz2;
      sha256 = "01kffjbshmwix2cdb95j0cx2qmrss6yfjj7y5qssw83h36bvw5dk";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuntcx = (stdenv.mkDerivation ((if overrides ? xf86videosuntcx then overrides.xf86videosuntcx else x: x) {
    name = "xf86-video-suntcx-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-suntcx-1.1.1.tar.bz2;
      sha256 = "07lqah5sizhwjpzr4vcpwgvbl86fwz4k0c3skp63sq58ng21acal";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  })) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videotdfx = (stdenv.mkDerivation ((if overrides ? xf86videotdfx then overrides.xf86videotdfx else x: x) {
    name = "xf86-video-tdfx-1.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-tdfx-1.4.3.tar.bz2;
      sha256 = "0cxz1rsc87cnf0ba1zfwhk0lhfas92ysc9b13q6x21m31b53bn9s";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videotga = (stdenv.mkDerivation ((if overrides ? xf86videotga then overrides.xf86videotga else x: x) {
    name = "xf86-video-tga-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-tga-1.2.1.tar.bz2;
      sha256 = "0mdqrn02zzkdnmhg4vh9djaawg6b2p82g5qbj66z8b30yr77b93h";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotrident = (stdenv.mkDerivation ((if overrides ? xf86videotrident then overrides.xf86videotrident else x: x) {
    name = "xf86-video-trident-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-trident-1.3.3.tar.bz2;
      sha256 = "1x8ibnkq6vv9ify1alc65hj5c8np7bii9dp61cw7b87hyfvflhb2";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotseng = (stdenv.mkDerivation ((if overrides ? xf86videotseng then overrides.xf86videotseng else x: x) {
    name = "xf86-video-tseng-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-tseng-1.2.3.tar.bz2;
      sha256 = "11via1r9b3x0cfa0ys44w9hff9s5a2wf50hgi1zfhjysg4zbnmh5";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videov4l = (stdenv.mkDerivation ((if overrides ? xf86videov4l then overrides.xf86videov4l else x: x) {
    name = "xf86-video-v4l-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-v4l-0.2.0.tar.bz2;
      sha256 = "0pcjc75hgbih3qvhpsx8d4fljysfk025slxcqyyhr45dzch93zyb";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  })) // {inherit randrproto videoproto xorgserver xproto ;};
    
  xf86videovesa = (stdenv.mkDerivation ((if overrides ? xf86videovesa then overrides.xf86videovesa else x: x) {
    name = "xf86-video-vesa-2.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vesa-2.3.0.tar.bz2;
      sha256 = "0yhdj39d8rfv2n4i52dg7cg1rsrclagn7rjs3pc3jdajjh75mn4f";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovmware = (stdenv.mkDerivation ((if overrides ? xf86videovmware then overrides.xf86videovmware else x: x) {
    name = "xf86-video-vmware-11.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/driver/xf86-video-vmware-11.0.1.tar.bz2;
      sha256 = "1gp7gj1a1jdcqr8qa9z57h1zjf0wjhr78b7fyxbl9fl1rdd1sdx6";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xineramaproto xorgserver xproto ;};
    
  xf86videovoodoo = (stdenv.mkDerivation ((if overrides ? xf86videovoodoo then overrides.xf86videovoodoo else x: x) {
    name = "xf86-video-voodoo-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-voodoo-1.2.3.tar.bz2;
      sha256 = "1s99ms9kjb1ypq8ra340iyc14x3mkh4vpbbz85r5nchrmfclsp82";
    };
    buildInputs = [pkgconfig fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  })) // {inherit fontsproto libpciaccess randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videowsfb = (stdenv.mkDerivation ((if overrides ? xf86videowsfb then overrides.xf86videowsfb else x: x) {
    name = "xf86-video-wsfb-0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-wsfb-0.3.0.tar.bz2;
      sha256 = "17lqhir0adcccfkrzz2sr8cpv5vkakk0w7xfc22vv7c6jz9vdgbq";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  })) // {inherit xorgserver xproto ;};
    
  xf86videoxgi = (stdenv.mkDerivation ((if overrides ? xf86videoxgi then overrides.xf86videoxgi else x: x) {
    name = "xf86-video-xgi-1.5.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-xgi-1.5.1.tar.bz2;
      sha256 = "064yginmdlcrk09rmwgbjn1jvgm38j9prfhmzv25yd4xgwlga6fb";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ];
  })) // {inherit fontsproto glproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xineramaproto xorgserver xproto ;};
    
  xf86videoxgixp = (stdenv.mkDerivation ((if overrides ? xf86videoxgixp then overrides.xf86videoxgixp else x: x) {
    name = "xf86-video-xgixp-1.7.99.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86-video-xgixp-1.7.99.4.tar.bz2;
      sha256 = "15bk90pr8xcwiva1bhfmqz3qjyycwnid4x7iwrwxc47zi661f2pf";
    };
    buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  })) // {inherit fontsproto libdrm libpciaccess randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86vidmodeproto = (stdenv.mkDerivation ((if overrides ? xf86vidmodeproto then overrides.xf86vidmodeproto else x: x) {
    name = "xf86vidmodeproto-2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xf86vidmodeproto-2.3.tar.bz2;
      sha256 = "0iy25ayr105x5b6yfi1a2xvmgc7jaghghp6hjk2k2ys0ll9lcw4g";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xfs = (stdenv.mkDerivation ((if overrides ? xfs then overrides.xfs else x: x) {
    name = "xfs-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xfs-1.1.0.tar.bz2;
      sha256 = "0vazp4p2c9xayd1gdmlqqhklsv0770sgwvmafgjsi204rnxx9fj7";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  })) // {inherit libFS libXfont xtrans ;};
    
  xgamma = (stdenv.mkDerivation ((if overrides ? xgamma then overrides.xgamma else x: x) {
    name = "xgamma-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xgamma-1.0.3.tar.bz2;
      sha256 = "06kf7r0fq1gn2sw6rb0mxlpc5ac78hh09cviapdw5idxzf42bsz5";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  })) // {inherit libX11 libXxf86vm ;};
    
  xhost = (stdenv.mkDerivation ((if overrides ? xhost then overrides.xhost else x: x) {
    name = "xhost-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xhost-1.0.3.tar.bz2;
      sha256 = "05xd6j8l120kcz4vz9pdrv1wnfhkq2rlagizliry57z8cmy00qrd";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  })) // {inherit libX11 libXau libXmu ;};
    
  xineramaproto = (stdenv.mkDerivation ((if overrides ? xineramaproto then overrides.xineramaproto else x: x) {
    name = "xineramaproto-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xineramaproto-1.2.tar.bz2;
      sha256 = "0r5slwkj8h8v548ysgwhm6idqnij8w96nkgr33ch2wpcrs3q1s2q";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xinit = (stdenv.mkDerivation ((if overrides ? xinit then overrides.xinit else x: x) {
    name = "xinit-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinit-1.2.1.tar.bz2;
      sha256 = "01wvdi69v9yadzavch6l8c80v1rqgxsyl6cl3byq0v8vx0xcgg0n";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xinput = (stdenv.mkDerivation ((if overrides ? xinput then overrides.xinput else x: x) {
    name = "xinput-1.5.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xinput-1.5.2.tar.bz2;
      sha256 = "1433lw6xv59f240rgrpgyf9qrmh9knpx64gg95bm32cjvh0qdrrc";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext libXi ];
  })) // {inherit inputproto libX11 libXext libXi ;};
    
  xkbcomp = (stdenv.mkDerivation ((if overrides ? xkbcomp then overrides.xkbcomp else x: x) {
    name = "xkbcomp-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xkbcomp-1.1.1.tar.bz2;
      sha256 = "0qz6hbypcv350cqrnlks7ncby6gl6g4v5rb550ga9zyr8gyvqxcp";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  xkbevd = (stdenv.mkDerivation ((if overrides ? xkbevd then overrides.xkbevd else x: x) {
    name = "xkbevd-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xkbevd-1.1.0.tar.bz2;
      sha256 = "1px26hmn4rv1m997r7bg01w2viaybxgsm4ddahwz27rj43fpl0s6";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  })) // {inherit libX11 libxkbfile ;};
    
  xkbutils = (stdenv.mkDerivation ((if overrides ? xkbutils then overrides.xkbutils else x: x) {
    name = "xkbutils-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xkbutils-1.0.2.tar.bz2;
      sha256 = "1vhbqyqgvdzkqlkvj80sg6w4phk8f21g6n8n5djb5pm4ji2pv8qj";
    };
    buildInputs = [pkgconfig inputproto libX11 libXaw libxkbfile ];
  })) // {inherit inputproto libX11 libXaw libxkbfile ;};
    
  xkill = (stdenv.mkDerivation ((if overrides ? xkill then overrides.xkill else x: x) {
    name = "xkill-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xkill-1.0.2.tar.bz2;
      sha256 = "09sskbg2njl52kq7x8l95m7sfg195b06f0wdp8fankizilwz0bak";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xlsatoms = (stdenv.mkDerivation ((if overrides ? xlsatoms then overrides.xlsatoms else x: x) {
    name = "xlsatoms-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsatoms-1.1.0.tar.bz2;
      sha256 = "03fbknvq7rixfgpv5945s7r82jz2xc06a0n09w1p22hl4pd7l0aa";
    };
    buildInputs = [pkgconfig libxcb ];
  })) // {inherit libxcb ;};
    
  xlsclients = (stdenv.mkDerivation ((if overrides ? xlsclients then overrides.xlsclients else x: x) {
    name = "xlsclients-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xlsclients-1.1.0.tar.bz2;
      sha256 = "037sph4zyar6061445xmf1bqrmm00k6qr9lpypjnrx4ragsm2nzr";
    };
    buildInputs = [pkgconfig libxcb xcbutil ];
  })) // {inherit libxcb xcbutil ;};
    
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
    name = "xmodmap-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xmodmap-1.0.4.tar.bz2;
      sha256 = "1v8bpp3svyza9nn3f8jlilf01nwwzchr3a0sl5h9vxcrbm966nl0";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xorgcffiles = (stdenv.mkDerivation ((if overrides ? xorgcffiles then overrides.xorgcffiles else x: x) {
    name = "xorg-cf-files-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/util/xorg-cf-files-1.0.3.tar.bz2;
      sha256 = "02z2w72bwa1hvjyp7ilw37qs2zbr7cggabq18jzdpb4dzgcdwcmw";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xorgdocs = (stdenv.mkDerivation ((if overrides ? xorgdocs then overrides.xorgdocs else x: x) {
    name = "xorg-docs-1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xorg-docs-1.5.tar.bz2;
      sha256 = "1z7afnz0cxla7dz9gj95vwrwzqph7w90kd6d5ah7dbcp5rc67k32";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xorgserver = (stdenv.mkDerivation ((if overrides ? xorgserver then overrides.xorgserver else x: x) {
    name = "xorg-server-1.8.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/xserver/xorg-server-1.8.2.tar.bz2;
      sha256 = "1qmcmrv26p8645nwdm2q558mpvi75fpn9knkacanzysw5497w5aj";
    };
    buildInputs = [pkgconfig bigreqsproto damageproto dbus fixesproto fontsproto inputproto kbproto libdrm openssl libpciaccess perl pixman randrproto renderproto libX11 libXau libXaw xcmiscproto libXdmcp xextproto libXfixes libXfont libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXv ];
  })) // {inherit bigreqsproto damageproto dbus fixesproto fontsproto inputproto kbproto libdrm openssl libpciaccess perl pixman randrproto renderproto libX11 libXau libXaw xcmiscproto libXdmcp xextproto libXfixes libXfont libxkbfile libXmu libXpm xproto libXrender libXres libXt xtrans libXv ;};
    
  xorgsgmldoctools = (stdenv.mkDerivation ((if overrides ? xorgsgmldoctools then overrides.xorgsgmldoctools else x: x) {
    name = "xorg-sgml-doctools-1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xorg-sgml-doctools-1.3.tar.bz2;
      sha256 = "1cnvfmdnyadh56sj29snz5k94zjbnf9aiad6l8dsdi2dm2gjgh6m";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xpr = (stdenv.mkDerivation ((if overrides ? xpr then overrides.xpr else x: x) {
    name = "xpr-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xpr-1.0.3.tar.bz2;
      sha256 = "0zckkd45lzbikmdn29r12faby8g5prjkacc1z8aw87pq9sqdcy18";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xprop = (stdenv.mkDerivation ((if overrides ? xprop then overrides.xprop else x: x) {
    name = "xprop-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xprop-1.1.0.tar.bz2;
      sha256 = "09k2qvfg5fvya8a26082ks3laif5fa9a3zdg7c8mz2bl2n80g3nc";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xproto = (stdenv.mkDerivation ((if overrides ? xproto then overrides.xproto else x: x) {
    name = "xproto-7.0.17";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/proto/xproto-7.0.17.tar.bz2;
      sha256 = "00cxgwaijhz7vp60washz03nvwk42f7sz72xkzfcx01pbgf1yb4v";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xrandr = (stdenv.mkDerivation ((if overrides ? xrandr then overrides.xrandr else x: x) {
    name = "xrandr-1.3.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/individual/app/xrandr-1.3.3.tar.bz2;
      sha256 = "0iiywk10vi56k7bpdlhn4wv0friz8vzz6dbfhy1xrnrvsgkg73wn";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  })) // {inherit libX11 libXrandr libXrender ;};
    
  xrdb = (stdenv.mkDerivation ((if overrides ? xrdb then overrides.xrdb else x: x) {
    name = "xrdb-1.0.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xrdb-1.0.6.tar.bz2;
      sha256 = "16gwcvpp93mn65dqg5ijc5yns7mglsnabx2dn4icypv6chvjl1ld";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  })) // {inherit libX11 libXmu ;};
    
  xrefresh = (stdenv.mkDerivation ((if overrides ? xrefresh then overrides.xrefresh else x: x) {
    name = "xrefresh-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xrefresh-1.0.3.tar.bz2;
      sha256 = "1nbyglx05jjz1yjj50x5w449z9f90rw8xzzwrbxvyjximvvsbq1y";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xset = (stdenv.mkDerivation ((if overrides ? xset then overrides.xset else x: x) {
    name = "xset-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xset-1.1.0.tar.bz2;
      sha256 = "0hs6amxfjbqp2y6bxxihmfnhxral6isb5l18z1fa54080g35kj3j";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXp libXxf86misc ];
  })) // {inherit libX11 libXext libXmu libXp libXxf86misc ;};
    
  xsetroot = (stdenv.mkDerivation ((if overrides ? xsetroot then overrides.xsetroot else x: x) {
    name = "xsetroot-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xsetroot-1.0.3.tar.bz2;
      sha256 = "0j4gfa6f177hy230fb0gnnj6ibkwbmh9x7rwrmgspqvdd3615rfp";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXmu ];
  })) // {inherit libX11 xbitmaps libXmu ;};
    
  xtrans = (stdenv.mkDerivation ((if overrides ? xtrans then overrides.xtrans else x: x) {
    name = "xtrans-1.2.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xtrans-1.2.5.tar.bz2;
      sha256 = "1688p5v9jalykyj97jv34a6mxfipa7givb7fvbjpd0fsyj8s6wfc";
    };
    buildInputs = [pkgconfig ];
  })) // {inherit ;};
    
  xvinfo = (stdenv.mkDerivation ((if overrides ? xvinfo then overrides.xvinfo else x: x) {
    name = "xvinfo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xvinfo-1.1.0.tar.bz2;
      sha256 = "1yvfx1lli1k90h8ww0krgd9y3cr0c47nklmr5b6daayrl1n8yc8a";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  })) // {inherit libX11 libXv ;};
    
  xwd = (stdenv.mkDerivation ((if overrides ? xwd then overrides.xwd else x: x) {
    name = "xwd-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xwd-1.0.3.tar.bz2;
      sha256 = "1zg3grx6sjm2w1aqyn80k7qvf9p00pp0k4ihsiil8mbc13mdpwpz";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
  xwininfo = (stdenv.mkDerivation ((if overrides ? xwininfo then overrides.xwininfo else x: x) {
    name = "xwininfo-1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xwininfo-1.0.5.tar.bz2;
      sha256 = "1nfw5jj67g0vnmq5l7622agb3c27jzgl2vbcrsnfgi0bgcdbidld";
    };
    buildInputs = [pkgconfig libX11 libXext ];
  })) // {inherit libX11 libXext ;};
    
  xwud = (stdenv.mkDerivation ((if overrides ? xwud then overrides.xwud else x: x) {
    name = "xwud-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = mirror://xorg/X11R7.5/src/everything/xwud-1.0.2.tar.bz2;
      sha256 = "1h8ap7c29yib6fza2qgbf6pl11km0wjdmairjrl13i0dzzxmsd44";
    };
    buildInputs = [pkgconfig libX11 ];
  })) // {inherit libX11 ;};
    
}; in xorg
