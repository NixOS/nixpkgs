# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, libxslt, expat, libdrm, libpng, zlib, perl, mesa, mesaHeaders
}:

rec {

  applewmproto = (stdenv.mkDerivation {
    name = "applewmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/applewmproto-X11R7.0-1.0.3.tar.bz2;
      sha256 = "1v657wkk6dcpcg9drd92p05wg3ifd4qiy4hzwklfsfspzmvqfwyv";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  appres = (stdenv.mkDerivation {
    name = "appres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/appres-X11R7.2-1.0.1.tar.bz2;
      sha256 = "00k2b66b1ava2yy48c1jflpbj5rv8ab9r8izxggmdyhy3v8yr3n8";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  }) // {inherit libX11 libXt ;};
    
  bdftopcf = (stdenv.mkDerivation {
    name = "bdftopcf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/bdftopcf-X11R7.0-1.0.0.tar.bz2;
      sha256 = "00s8cmhnq95nbv332q9bhyxxyrd2irywk2nh01j62nyg18q0wxjr";
    };
    buildInputs = [pkgconfig libXfont ];
  }) // {inherit libXfont ;};
    
  beforelight = (stdenv.mkDerivation {
    name = "beforelight-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/beforelight-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0pmcsjk0jva36c2hrypnwazvbbgnwywgji7yml9rg1mb8hyr38b2";
    };
    buildInputs = [pkgconfig libX11 libXaw libXScrnSaver libXt ];
  }) // {inherit libX11 libXaw libXScrnSaver libXt ;};
    
  bigreqsproto = (stdenv.mkDerivation {
    name = "bigreqsproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/bigreqsproto-X11R7.0-1.0.2.tar.bz2;
      sha256 = "11nf47y46phdxr222vd867sygg7hdpi9v9z3625g1kmihkzjxn39";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  bitmap = (stdenv.mkDerivation {
    name = "bitmap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/bitmap-X11R7.1-1.0.2.tar.bz2;
      sha256 = "12zlb4nrdwa8mq0gs6f6f1la5d97a74rw7i2yw2r6fp8mjpablaw";
    };
    buildInputs = [pkgconfig libXaw libX11 xbitmaps libXmu libXt ];
  }) // {inherit libXaw libX11 xbitmaps libXmu libXt ;};
    
  compositeproto = (stdenv.mkDerivation {
    name = "compositeproto-0.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/compositeproto-X11R7.1-0.3.1.tar.bz2;
      sha256 = "0ny28gkdcff1pfvyc0fr9m22nbaamh6fqbyjwgy4gq7vllf2q0nw";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  damageproto = (stdenv.mkDerivation {
    name = "damageproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/damageproto-X11R7.0-1.0.3.tar.bz2;
      sha256 = "1z4bnnp1wfa36y696h0drhlbvdk2lbdfkmajq1wg0fnl9zvyc6pp";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  dmxproto = (stdenv.mkDerivation {
    name = "dmxproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/dmxproto-X11R7.0-2.2.2.tar.bz2;
      sha256 = "1nvq1j3x5hiwal8x7blbjjbkf81idwvsixnvrfb0m5c9jmyra6sk";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  editres = (stdenv.mkDerivation {
    name = "editres-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/editres-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0n8yql1rnv4dah44d229aw2jiwm21i8lj12aiajw83dvc4xki6ra";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  encodings = (stdenv.mkDerivation {
    name = "encodings-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/encodings-X11R7.2-1.0.2.tar.bz2;
      sha256 = "03rdw6zqkrknj15hr8b1i18azkm8nd9f1fbq00aqb6c4qw8s1van";
    };
    buildInputs = [pkgconfig mkfontscale ];
  }) // {inherit mkfontscale ;};
    
  evieext = (stdenv.mkDerivation {
    name = "evieext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/evieext-X11R7.0-1.0.2.tar.bz2;
      sha256 = "08wzhzzrdjsxzlk6jxnbv1j7khhnaa79agn637n5hq29m54d1nnp";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fixesproto = (stdenv.mkDerivation {
    name = "fixesproto-4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fixesproto-X11R7.1-4.0.tar.bz2;
      sha256 = "14sgwakhia4dhvmp0hcaaxwlgwkzwzjfbvz6yqrsf35afdfdlmga";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontadobe100dpi = (stdenv.mkDerivation {
    name = "font-adobe-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-adobe-100dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1hrcfhr87jj1lkikrs1yw0xa0f7qi9d9iwi8mdk48nhv4rynz9w8";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobe75dpi = (stdenv.mkDerivation {
    name = "font-adobe-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-adobe-75dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "11wxdk7yjd0y54q9y7y1cbzj7p79ad4g90ab73pr279vddzkgizi";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopia100dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-adobe-utopia-100dpi-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1x9s530mjpgqdmnw52qanj8n60gq53llxhxh130p03jij5ddaqmr";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopia75dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-adobe-utopia-75dpi-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1xx2x074gkpp4v2gqy2l7cyx52zvy4k4sm59w38834ymp9nk52qn";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontadobeutopiatype1 = (stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-adobe-utopia-type1-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1dnmnma1l7likn1jlbnc5bavs5467ymm45lwdlvj4d5gv4qn59qb";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontalias = (stdenv.mkDerivation {
    name = "font-alias-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-alias-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1x12h0l09anljf9yas2h1mly7j7d68an6nsyhfbqs1qycgarm4lw";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontarabicmisc = (stdenv.mkDerivation {
    name = "font-arabic-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-arabic-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "18660xka14z6r0f1wk0jgfalrhn1zmhdcqb14b5way54pnk1jh96";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbh100dpi = (stdenv.mkDerivation {
    name = "font-bh-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-100dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0mdsbmv83c473fdyng4nk651x3clzvxrzwnd55pj6fadbykdwx4g";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbh75dpi = (stdenv.mkDerivation {
    name = "font-bh-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-75dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1flqwb0r3hx9q50a5cxrbmqh6a9wxzvpq7m43zfb3rg0apq2bkkk";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-lucidatypewriter-100dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "00yg08n0vj73a0mbrr7d388ac9qf5ph5a3mdfwxrs6g7703s8nck";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-lucidatypewriter-75dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1mp5x0yvqwklrrsw13pyfqp3j2fvvimlm3bvs5xi4cphkh6mhmcd";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontbhttf = (stdenv.mkDerivation {
    name = "font-bh-ttf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-ttf-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1pwy9nzmmwipia4zgp23h95mds1zsh4xiac54x61x6x4058j8s52";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontbhtype1 = (stdenv.mkDerivation {
    name = "font-bh-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bh-type1-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1mc2a667s2p4kb5p31cyqdr07mpxcqyrvsvfsg1xd0rdx4adxkpp";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontbitstream100dpi = (stdenv.mkDerivation {
    name = "font-bitstream-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bitstream-100dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1ri3qmjs9dlkwmjkgfzhc4q417hpci8x8mvxk6f8lb8699vqb6ry";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbitstream75dpi = (stdenv.mkDerivation {
    name = "font-bitstream-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bitstream-75dpi-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0svz7c3k1fdr7iznb10h7rk8vbrfkw63rx958aass600dr0vdcbi";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontbitstreamspeedo = (stdenv.mkDerivation {
    name = "font-bitstream-speedo-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bitstream-speedo-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0lkx56sgp78bj8sbh2nls3pvjv95w38ndcn7x84lrl1zfmqwajzl";
    };
    buildInputs = [pkgconfig mkfontdir ];
  }) // {inherit mkfontdir ;};
    
  fontbitstreamtype1 = (stdenv.mkDerivation {
    name = "font-bitstream-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-bitstream-type1-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0vgx360jb9q15kjy6ynll850h2kc0lv3s115b3n5nnc9i8wrvw7n";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontcacheproto = (stdenv.mkDerivation {
    name = "fontcacheproto-0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fontcacheproto-X11R7.0-0.1.2.tar.bz2;
      sha256 = "0qb4bbrymlls3i92da43fzqa56aly4vybikwhddwa9vgb05219kj";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontcronyxcyrillic = (stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-cronyx-cyrillic-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0d2bqh6rfwc3b124m1yiilnxf5hlgp4d7v517c6l73339ch3sn98";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontcursormisc = (stdenv.mkDerivation {
    name = "font-cursor-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-cursor-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1d229h1pamf431j46rm6h3llrnylz3165aps7vd3wrc82chcfrss";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontdaewoomisc = (stdenv.mkDerivation {
    name = "font-daewoo-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-daewoo-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "138lvj6fa747xl633fx8yy8vq32xwadm49s5wz7a2986fcfyyyf2";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontdecmisc = (stdenv.mkDerivation {
    name = "font-dec-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-dec-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0xbblqbrg099xj2aqcqxwv4j7yrs953akfdn16jgrhghhhl9ivp7";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontibmtype1 = (stdenv.mkDerivation {
    name = "font-ibm-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-ibm-type1-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1z2wr67sjl3vsg3x87ja189w0x25ywvir3jddlxny5m2f7si0hjk";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontisasmisc = (stdenv.mkDerivation {
    name = "font-isas-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-isas-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1xsmdwqn1hli9dil0v4j9qhgvk5ivbvdpx12lcnsq0mwnkhcyif8";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontjismisc = (stdenv.mkDerivation {
    name = "font-jis-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-jis-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0immg3fl59q8ixyca1w0vngapchn0g10p6z000nj6lpsvpk3qk3z";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmicromisc = (stdenv.mkDerivation {
    name = "font-micro-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-micro-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "08mj6nr05fsl7lz5q2pksng4df2qr7s8idm2nf8a07lac4ic5f93";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmisccyrillic = (stdenv.mkDerivation {
    name = "font-misc-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-misc-cyrillic-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0z673j5z6ppzyf7sqmilq038fv6jjqx6a4hr86f02312wrzljcp3";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontmiscethiopic = (stdenv.mkDerivation {
    name = "font-misc-ethiopic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-misc-ethiopic-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1na882sk7mmb0dhmypzgfj0sv35jf2dap34k6jg5brzlp22500h4";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmeltho = (stdenv.mkDerivation {
    name = "font-misc-meltho-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-misc-meltho-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0g95r9v7ixbr7120p3d99c2yvxlmj5a6lwb19rzb0pdrap0g1jya";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fontmiscmisc = (stdenv.mkDerivation {
    name = "font-misc-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-misc-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0y1npz2qxi7i29z5k0g6s94n3vyxmd1n996ahyv8pa05fd0bkhdx";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ]; postInstall = "ln -s ${fontalias}/lib/X11/fonts/misc/fonts.alias $out/lib/X11/fonts/misc/fonts.alias"; 
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontmuttmisc = (stdenv.mkDerivation {
    name = "font-mutt-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-mutt-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "196i7l8z7jzi3haaq2jb20z68rs7hg7ahd40vw07whpw5x98ssiq";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontschumachermisc = (stdenv.mkDerivation {
    name = "font-schumacher-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-schumacher-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1prqzdb998fy3xkrd0vkcgbqmfvi28w67d0jng6x597zjgrckinm";
    };
    buildInputs = [pkgconfig bdftopcf fontutil mkfontdir mkfontscale ];
  }) // {inherit bdftopcf fontutil mkfontdir mkfontscale ;};
    
  fontscreencyrillic = (stdenv.mkDerivation {
    name = "font-screen-cyrillic-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-screen-cyrillic-X11R7.2-1.0.1.tar.bz2;
      sha256 = "0qj94fd642gvsbi05di0s096dk24s02pk6pclbfj2vvin78zkp2k";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontsonymisc = (stdenv.mkDerivation {
    name = "font-sony-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-sony-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1kg50acvcq1zaxl4gxdr3ddm7jcssgda6i1gr5jyrixn2jix19sf";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontsproto = (stdenv.mkDerivation {
    name = "fontsproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fontsproto-X11R7.0-2.0.2.tar.bz2;
      sha256 = "1d30yq17hkmx0yqk5s13cjq3s6f1xbwpv6hpijjq5ri84fnxk9ch";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontsunmisc = (stdenv.mkDerivation {
    name = "font-sun-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-sun-misc-X11R7.0-1.0.0.tar.bz2;
      sha256 = "01wsl2cymv3arxyjkf08pd5lvyg800c4h3pg3skbs20a0vblq2c0";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fonttosfnt = (stdenv.mkDerivation {
    name = "fonttosfnt-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fonttosfnt-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0ad9jvl85il05fy21z318dsrv53al1gqg2byr1irw3hqnqz9jaw5";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto ];
  }) // {inherit libfontenc freetype xproto ;};
    
  fontutil = (stdenv.mkDerivation {
    name = "font-util-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-util-X11R7.1-1.0.1.tar.bz2;
      sha256 = "1ia86i3abv4mjr2rjwbn406linrywxzjj2iqfxh9k285qx19r8gz";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontwinitzkicyrillic = (stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-winitzki-cyrillic-X11R7.0-1.0.0.tar.bz2;
      sha256 = "079dfhkm6ks94imyihb1pfk9gr9jxgxpc31mdkjbkrjqfq2rfsav";
    };
    buildInputs = [pkgconfig bdftopcf mkfontdir mkfontscale ];
  }) // {inherit bdftopcf mkfontdir mkfontscale ;};
    
  fontxfree86type1 = (stdenv.mkDerivation {
    name = "font-xfree86-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/font-xfree86-type1-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0kzr8jqfqp8gm6vh391l16vlmyclz9ck9nw2f9zjaqnlwzbzx96d";
    };
    buildInputs = [pkgconfig mkfontdir mkfontscale ]; preInstall = "installFlags=(FCCACHE=true)"; 
  }) // {inherit mkfontdir mkfontscale ;};
    
  fslsfonts = (stdenv.mkDerivation {
    name = "fslsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fslsfonts-X11R7.0-1.0.1.tar.bz2;
      sha256 = "08cbvyd0qdvxi0bjyvvgqhra79c6g90q45hxvwzrs057kan14b36";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  fstobdf = (stdenv.mkDerivation {
    name = "fstobdf-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/fstobdf-X11R7.1-1.0.2.tar.bz2;
      sha256 = "01k95l9g6d96zgw7nlywf65bawlx27fgm89fsd5vnjxjwxx0drnq";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  gccmakedep = (stdenv.mkDerivation {
    name = "gccmakedep-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/gccmakedep-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0spnqnzrxjb1ablg17lf48bv28457y8agvym3b6wh8g2p9dnhrni";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  glproto = (stdenv.mkDerivation {
    name = "glproto-1.4.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/glproto-X11R7.2-1.4.8.tar.bz2;
      sha256 = "1p32lbarglg3zviibfjkjym10v4fx9wlavjzki0j3f2mnf3mx1x2";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  iceauth = (stdenv.mkDerivation {
    name = "iceauth-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/iceauth-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1gd7vyxkym84x3d0kc9qnpg04c60xalx0iys0bcgp05yvl6jr826";
    };
    buildInputs = [pkgconfig libICE xproto ];
  }) // {inherit libICE xproto ;};
    
  ico = (stdenv.mkDerivation {
    name = "ico-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/ico-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0zgf28madi8sj74w1wni7bmww8pwzlr27yciafw2lr1mf41iv2lw";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  imake = (stdenv.mkDerivation {
    name = "imake-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/imake-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0an317zszn8l8k627z3hh7gk2rg10bia8kxhq96m6q0dqc87w5kn";
    };
    buildInputs = [pkgconfig xproto ]; inherit xorgcffiles; x11BuildHook = ./imake.sh; patches = [./imake.patch]; 
  }) // {inherit xproto ;};
    
  inputproto = (stdenv.mkDerivation {
    name = "inputproto-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/inputproto-X11R7.0-1.3.2.tar.bz2;
      sha256 = "1l3820pv683nx0i7frsymb8lgng31khi7s9gr9ygqx5gz6az8j1v";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  kbproto = (stdenv.mkDerivation {
    name = "kbproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/kbproto-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0g4hzskj7yk2673pg1mbisp868cfr8i7gg7fc9kr4y9z9flaci2j";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  lbxproxy = (stdenv.mkDerivation {
    name = "lbxproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/lbxproxy-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0vv0bsf7wavqxcx95xdj1lzgq7g9dw16lj13v60sk50d2vb0sdim";
    };
    buildInputs = [pkgconfig bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ];
  }) // {inherit bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ;};
    
  libAppleWM = (stdenv.mkDerivation {
    name = "libAppleWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libAppleWM-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1ma0534bcpkaywz8vqi2lyh2m9b0vv5p45r41y51bk0n73avkmb6";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  }) // {inherit applewmproto libX11 libXext xextproto ;};
    
  libFS = (stdenv.mkDerivation {
    name = "libFS-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libFS-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1wgn4mqamn2ngp876nxylxi474644zwx85ww5c717frgi5zxvghm";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  }) // {inherit fontsproto xproto xtrans ;};
    
  libICE = (stdenv.mkDerivation {
    name = "libICE-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libICE-X11R7.2-1.0.3.tar.bz2;
      sha256 = "1lkg6pqr7v1k41a7y92xyb6mblnk7zx058kk9dr58z9q7isk156j";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  }) // {inherit xproto xtrans ;};
    
  libSM = (stdenv.mkDerivation {
    name = "libSM-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libSM-X11R7.2-1.0.2.tar.bz2;
      sha256 = "01wxyv3i5hrcyigdigfgnywjh01yx0v76gbfvicqzmss5amppgan";
    };
    buildInputs = [pkgconfig libICE xproto xtrans ];
  }) // {inherit libICE xproto xtrans ;};
    
  libWindowsWM = (stdenv.mkDerivation {
    name = "libWindowsWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libWindowsWM-X11R7.0-1.0.0.tar.bz2;
      sha256 = "17c8yybvyjyxa6w60j54zj3lgpp4krcnzrhgx504q6n5vxmdpk3n";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  }) // {inherit windowswmproto libX11 libXext xextproto ;};
    
  libX11 = (stdenv.mkDerivation {
    name = "libX11-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libX11-X11R7.2-1.1.1.tar.bz2;
      sha256 = "1y7xrm8pbb7wsiif9if24iz4yqlyhgcg8wpfi6lfb57ylhhm1dz7";
    };
    buildInputs = [pkgconfig bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ];
  }) // {inherit bigreqsproto inputproto kbproto libXau libxcb xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ;};
    
  libXScrnSaver = (stdenv.mkDerivation {
    name = "libXScrnSaver-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXScrnSaver-X11R7.2-1.1.2.tar.bz2;
      sha256 = "1m3w504q0zwk5x6dbfm3kj73zwqpwf2q5dq444ndxn9ky3d490ch";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  }) // {inherit scrnsaverproto libX11 libXext xextproto ;};
    
  libXTrap = (stdenv.mkDerivation {
    name = "libXTrap-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXTrap-X11R7.0-1.0.0.tar.bz2;
      sha256 = "00wh69p8zbn75c4bk3r333gg6lskn3y2pbmw0wr6nciyh22hrrf7";
    };
    buildInputs = [pkgconfig trapproto libX11 libXext xextproto libXt ];
  }) // {inherit trapproto libX11 libXext xextproto libXt ;};
    
  libXau = (stdenv.mkDerivation {
    name = "libXau-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXau-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0s91s44vzd9j8kyydax1sj2a2az02dy4ccln5l6c9ihbqgmrwyg8";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXaw = (stdenv.mkDerivation {
    name = "libXaw-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXaw-X11R7.1-1.0.2.tar.bz2;
      sha256 = "07p5s29dhsfjdyvwg4yncki5cj70ngx5g8xsjyvjmvln78xa8mfm";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ];
  }) // {inherit printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ;};
    
  libXcomposite = (stdenv.mkDerivation {
    name = "libXcomposite-0.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXcomposite-X11R7.2-0.3.1.tar.bz2;
      sha256 = "194ycacifrkpbx60n8rz9njm6lzyxg241y3ahzh3l2qfrylcg6nl";
    };
    buildInputs = [pkgconfig compositeproto fixesproto libX11 libXext libXfixes ];
  }) // {inherit compositeproto fixesproto libX11 libXext libXfixes ;};
    
  libXcursor = (stdenv.mkDerivation {
    name = "libXcursor-1.1.8";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXcursor-X11R7.2-1.1.8.tar.bz2;
      sha256 = "18qk611mf1cxp327ddgmfss2r9xkh5m7fw07nv456bpwymzggqn3";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes libXrender ];
  }) // {inherit fixesproto libX11 libXfixes libXrender ;};
    
  libXdamage = (stdenv.mkDerivation {
    name = "libXdamage-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXdamage-X11R7.2-1.0.4.tar.bz2;
      sha256 = "05zmzdr2dmdhsa4cm0yrsin7qm0rw90wy7p3kxqvgidm7ba25m2r";
    };
    buildInputs = [pkgconfig damageproto fixesproto libX11 xextproto libXfixes ];
  }) // {inherit damageproto fixesproto libX11 xextproto libXfixes ;};
    
  libXdmcp = (stdenv.mkDerivation {
    name = "libXdmcp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXdmcp-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0vv5rk5ra9gawj57s5z78fah9q00l7csxm2zaahzr4dk3h59v7dy";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXevie = (stdenv.mkDerivation {
    name = "libXevie-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXevie-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0r2x3ic25jc62c9ffl9vz1bz9glg00qsf59dx8krwg8ndg8bjbp6";
    };
    buildInputs = [pkgconfig evieext libX11 libXext xextproto xproto ];
  }) // {inherit evieext libX11 libXext xextproto xproto ;};
    
  libXext = (stdenv.mkDerivation {
    name = "libXext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXext-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0als9pmllyam6nshrzis4abjz4lyxz8laq8x3ykm4p649472ri8i";
    };
    buildInputs = [pkgconfig libX11 libXau xextproto xproto ];
  }) // {inherit libX11 libXau xextproto xproto ;};
    
  libXfixes = (stdenv.mkDerivation {
    name = "libXfixes-4.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXfixes-X11R7.2-4.0.3.tar.bz2;
      sha256 = "0i5lly8szw6mh5f8l9yh7p1j0vjjzkrlsfzp8c7y0akzl5rq31vh";
    };
    buildInputs = [pkgconfig fixesproto libX11 xextproto xproto ];
  }) // {inherit fixesproto libX11 xextproto xproto ;};
    
  libXfont = (stdenv.mkDerivation {
    name = "libXfont-1.2.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXfont-X11R7.2-1.2.7.tar.bz2;
      sha256 = "1361xc6jwx5006cclc0dn8hfr4m1b1311g7bwp5hyp603waz0jym";
    };
    buildInputs = [pkgconfig fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ];
  }) // {inherit fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ;};
    
  libXfontcache = (stdenv.mkDerivation {
    name = "libXfontcache-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXfontcache-X11R7.2-1.0.4.tar.bz2;
      sha256 = "1hbd6g9p03ivwlrsliqmhbflnqww0k3y3aj1qg3cbi7iqxwlwil3";
    };
    buildInputs = [pkgconfig fontcacheproto libX11 libXext xextproto ];
  }) // {inherit fontcacheproto libX11 libXext xextproto ;};
    
  libXft = (stdenv.mkDerivation {
    name = "libXft-2.1.12";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXft-X11R7.2-2.1.12.tar.bz2;
      sha256 = "1hm9lj45wxhg430jyq1rbri5b1hasl9zrypf6q2jz6nvhm691gw0";
    };
    buildInputs = [pkgconfig fontconfig freetype libXrender ];
  }) // {inherit fontconfig freetype libXrender ;};
    
  libXi = (stdenv.mkDerivation {
    name = "libXi-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXi-X11R7.2-1.0.2.tar.bz2;
      sha256 = "1xmixmzsvkv0wv7gvm87mr4rag6nchxqf0diihprnq6zb7gj76iz";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  }) // {inherit inputproto libX11 libXext xextproto xproto ;};
    
  libXinerama = (stdenv.mkDerivation {
    name = "libXinerama-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXinerama-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0yj6bydlszsx5jx5br4vk2gzd3kynrznyn33i7hz2wnfvncs9dbj";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  }) // {inherit libX11 libXext xextproto xineramaproto ;};
    
  libXmu = (stdenv.mkDerivation {
    name = "libXmu-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXmu-X11R7.2-1.0.3.tar.bz2;
      sha256 = "12k1j0d0c4021nr7rl3avd2rkxlpvlmld05xrhk3dsdpqmv8ivaj";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXt ];
  }) // {inherit libX11 libXext xextproto libXt ;};
    
  libXp = (stdenv.mkDerivation {
    name = "libXp-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXp-X11R7.0-1.0.0.tar.bz2;
      sha256 = "1vj1972kaan7hgxd2s2fcyyx1pzjz9x7j66pc1dgdx7g768cnn3z";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  }) // {inherit printproto libX11 libXau libXext xextproto ;};
    
  libXpm = (stdenv.mkDerivation {
    name = "libXpm-3.5.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXpm-X11R7.2-3.5.6.tar.bz2;
      sha256 = "1q64hxfrh5g7dp0017hbgg0937bxj7x2x1k2wqkh1cxrgx65dbiv";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  }) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXprintAppUtil = (stdenv.mkDerivation {
    name = "libXprintAppUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXprintAppUtil-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1x0h6mk9ggzl346lg22iznyx3yq0smxdc47808x79ky87imjcjc3";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXprintUtil ];
  }) // {inherit printproto libX11 libXau libXp libXprintUtil ;};
    
  libXprintUtil = (stdenv.mkDerivation {
    name = "libXprintUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXprintUtil-X11R7.0-1.0.1.tar.bz2;
      sha256 = "03hglsjs3z4gmsri790b9yvcn935dz841i5f8wzhlcn0knbap7xv";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXt ];
  }) // {inherit printproto libX11 libXau libXp libXt ;};
    
  libXrandr = (stdenv.mkDerivation {
    name = "libXrandr-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXrandr-X11R7.2-1.1.2.tar.bz2;
      sha256 = "06saq84vkzq611wrn602gqj1npgv6rmyv1pr372li098y8m51hsi";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto libXrender ];
  }) // {inherit randrproto renderproto libX11 libXext xextproto libXrender ;};
    
  libXrender = (stdenv.mkDerivation {
    name = "libXrender-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXrender-X11R7.2-0.9.2.tar.bz2;
      sha256 = "0dcmyksc91w6vwfy9c4l3f73bc9sap6z30dqpxdv9fypq3yv3xbw";
    };
    buildInputs = [pkgconfig renderproto libX11 ];
  }) // {inherit renderproto libX11 ;};
    
  libXres = (stdenv.mkDerivation {
    name = "libXres-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXres-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0fid350zzq33ygyq6yjy785gravazp49p6jl6pxf95xnz6ngmpha";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto ];
  }) // {inherit resourceproto libX11 libXext xextproto ;};
    
  libXt = (stdenv.mkDerivation {
    name = "libXt-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXt-X11R7.2-1.0.4.tar.bz2;
      sha256 = "00w8s0c1971nhxf28qyzq0amy86cavgggjky6mw7shydq3c53dvv";
    };
    buildInputs = [pkgconfig kbproto libSM libX11 xproto ];
  }) // {inherit kbproto libSM libX11 xproto ;};
    
  libXtst = (stdenv.mkDerivation {
    name = "libXtst-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXtst-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1lvslqzamhpdj6ydd80qpry86l05mrwmx0r78smslahyhgxw3nck";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto ];
  }) // {inherit inputproto recordproto libX11 libXext xextproto ;};
    
  libXv = (stdenv.mkDerivation {
    name = "libXv-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXv-X11R7.2-1.0.3.tar.bz2;
      sha256 = "1pfbp10lj2nsrjw702fwbgd6sf5wp34j2n3knz3snf6afa4bz493";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto ];
  }) // {inherit videoproto libX11 libXext xextproto ;};
    
  libXvMC = (stdenv.mkDerivation {
    name = "libXvMC-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXvMC-X11R7.2-1.0.4.tar.bz2;
      sha256 = "1ags2z5rhiy83dgfvw1a6ch6vqnbbpp13pg9w1x6gnfvdsvwgj8n";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto libXv ];
  }) // {inherit videoproto libX11 libXext xextproto libXv ;};
    
  libXxf86dga = (stdenv.mkDerivation {
    name = "libXxf86dga-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXxf86dga-X11R7.1-1.0.1.tar.bz2;
      sha256 = "1dzx19sjncfsfixfwdic7h02zdyd5mlmfwwc4vlfnai5fb6d2fzd";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};
    
  libXxf86misc = (stdenv.mkDerivation {
    name = "libXxf86misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXxf86misc-X11R7.1-1.0.1.tar.bz2;
      sha256 = "0z311vqm4gq9p13kycd73bfw82a7mfyhapbvzjbrh45kpc9xxnsa";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};
    
  libXxf86vm = (stdenv.mkDerivation {
    name = "libXxf86vm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libXxf86vm-X11R7.1-1.0.1.tar.bz2;
      sha256 = "1q2si6n7kzl9fhqm8c3mbxsvz3gn9qr06xrs9i9gfap739bkcij9";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};
    
  libdmx = (stdenv.mkDerivation {
    name = "libdmx-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libdmx-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1fp9fbs9hm7fgfdw0qnjg8dr7z4pypnl5li6l944bspx38f0yphz";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  }) // {inherit dmxproto libX11 libXext xextproto ;};
    
  libfontenc = (stdenv.mkDerivation {
    name = "libfontenc-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libfontenc-X11R7.2-1.0.4.tar.bz2;
      sha256 = "1hyf6293y0x2hb80nklrsvfssggh9ji7ll8x7ygnycdz98q0c32c";
    };
    buildInputs = [pkgconfig xproto zlib ];
  }) // {inherit xproto zlib ;};
    
  liblbxutil = (stdenv.mkDerivation {
    name = "liblbxutil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/liblbxutil-X11R7.1-1.0.1.tar.bz2;
      sha256 = "1i9v8scx4ij9w92xi9na4jbwap694yn5h10zdla6qjla5x85vjnr";
    };
    buildInputs = [pkgconfig xextproto xproto zlib ];
  }) // {inherit xextproto xproto zlib ;};
    
  liboldX = (stdenv.mkDerivation {
    name = "liboldX-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/liboldX-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1zn1ybbgv4swsb0cp2hx67gj9xn6i0x36q93q5jg02vc0kxnv84q";
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
    name = "libxcb-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/libxcb-1.0.tar.bz2;
      sha256 = "07fi4yvkni7rlkw9gv7z1fa6y63z34gpj3kklc9ydlqg72nb5mhr";
    };
    buildInputs = [pkgconfig libxslt libpthreadstubs libXau xcbproto libXdmcp ];
  }) // {inherit libxslt libpthreadstubs libXau xcbproto libXdmcp ;};
    
  libxkbfile = (stdenv.mkDerivation {
    name = "libxkbfile-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libxkbfile-X11R7.2-1.0.4.tar.bz2;
      sha256 = "117xsyn2x909n3v3yrkkfabms0kbc5jciiwkrk86ksm6pkznvh8m";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  }) // {inherit kbproto libX11 ;};
    
  libxkbui = (stdenv.mkDerivation {
    name = "libxkbui-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/libxkbui-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1prdvz6w38k9sdp1yc7ay8xhx0yrf5dw0lw548lbwiinz456k7d6";
    };
    buildInputs = [pkgconfig libX11 libxkbfile libXt ];
  }) // {inherit libX11 libxkbfile libXt ;};
    
  listres = (stdenv.mkDerivation {
    name = "listres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/listres-X11R7.0-1.0.1.tar.bz2;
      sha256 = "11rdcbk5kafrak9a8bskarbsajgxnnwlhs8lc6jvhi21r7riywa1";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  lndir = (stdenv.mkDerivation {
    name = "lndir-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/lndir-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0444vz904n598mxpqyd6jj0rjb892pa60k0lq3y69762i8bkwmlg";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  luit = (stdenv.mkDerivation {
    name = "luit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/luit-X11R7.2-1.0.2.tar.bz2;
      sha256 = "1xffgs0hfqpv98yq06wysxwyf5i67i56dacfnk013yxwgkfsrl4k";
    };
    buildInputs = [pkgconfig libfontenc libX11 zlib ];
  }) // {inherit libfontenc libX11 zlib ;};
    
  makedepend = (stdenv.mkDerivation {
    name = "makedepend-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/makedepend-X11R7.0-1.0.0.tar.bz2;
      sha256 = "14nsmf6smwcwwhdm651wl7yix20c0pz3yb8g0id37ybzjr54dbqw";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  mkfontdir = (stdenv.mkDerivation {
    name = "mkfontdir-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/mkfontdir-X11R7.1-1.0.2.tar.bz2;
      sha256 = "039sy6j6b00zpvadg247p52gh65x4db2yj3492v291c5mnbapi4l";
    };
    buildInputs = [pkgconfig ]; preBuild = "substituteInPlace mkfontdir.cpp --replace BINDIR ${mkfontscale}/bin"; 
  }) // {inherit ;};
    
  mkfontscale = (stdenv.mkDerivation {
    name = "mkfontscale-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/mkfontscale-X11R7.2-1.0.3.tar.bz2;
      sha256 = "1j6mkh08a0ihbnw9d3q4239635zww5hcgisl6ymywdfpbs4gk2wp";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto zlib ];
  }) // {inherit libfontenc freetype xproto zlib ;};
    
  oclock = (stdenv.mkDerivation {
    name = "oclock-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/oclock-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1sdy6ijrycsw5339b9qlysk8hdv0nyxj4fwj3i9y7d3n9s4rh79l";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  printproto = (stdenv.mkDerivation {
    name = "printproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/printproto-X11R7.0-1.0.3.tar.bz2;
      sha256 = "0wp9hc90cmlwhrl4fflhd9lhmhcgxlypcmqg90a7hy510rwxbgr3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  proxymngr = (stdenv.mkDerivation {
    name = "proxymngr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/proxymngr-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1cpx6qy5yc9khxw3wri1jl4pi1g4kijmng7j0pjln36rdvv27kpi";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  randrproto = (stdenv.mkDerivation {
    name = "randrproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/randrproto-X11R7.0-1.1.2.tar.bz2;
      sha256 = "1l0agrbz8x4npnyiglx3bwyifwkdvjskn5gvyz15hbyh227vapks";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  recordproto = (stdenv.mkDerivation {
    name = "recordproto-1.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/recordproto-X11R7.0-1.13.2.tar.bz2;
      sha256 = "198bwhr2b93q52d3xad5qbhlbjvcxasrzl8yai81gn2smaxfq2h8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  renderproto = (stdenv.mkDerivation {
    name = "renderproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/renderproto-X11R7.0-0.9.2.tar.bz2;
      sha256 = "0hagqwsd9g0418m9rx8nzw50nzdvw4qsq3s634hrawqa24fp8xd8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  resourceproto = (stdenv.mkDerivation {
    name = "resourceproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/resourceproto-X11R7.0-1.0.2.tar.bz2;
      sha256 = "1d22vly3jla5px20hc7hmcqm5rzxkp2gqhllrfnpf8gawf7prpvj";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  rgb = (stdenv.mkDerivation {
    name = "rgb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/rgb-X11R7.1-1.0.1.tar.bz2;
      sha256 = "0hvjnmmldya6ilv84k1bjip3f004j18w45yiw67h6yb84aa0zvi4";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  rstart = (stdenv.mkDerivation {
    name = "rstart-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/rstart-X11R7.1-1.0.2.tar.bz2;
      sha256 = "15sfhxcq1kk432xj6n4gfjbfxva4cr883fmbcz4jaxxvcrrgkbws";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scripts = (stdenv.mkDerivation {
    name = "scripts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/scripts-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0cvb2xcfxnplgywj8kmbpw239q1zhhpd593vny4k3hpzbivbq0mm";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scrnsaverproto = (stdenv.mkDerivation {
    name = "scrnsaverproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/scrnsaverproto-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0ha3xscs2vhfjfi14bm0liqx2dqz859262q8kl5f5ld34f9j3v14";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  sessreg = (stdenv.mkDerivation {
    name = "sessreg-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/sessreg-X11R7.2-1.0.2.tar.bz2;
      sha256 = "09l4wy1rrg1mr5l1cq5r8hv8mky5b4ipl4ybw9z4wb1p4gvb9d0s";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  setxkbmap = (stdenv.mkDerivation {
    name = "setxkbmap-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/setxkbmap-X11R7.2-1.0.3.tar.bz2;
      sha256 = "19jxlksl90i674yad1n7w42s3nv0hhlkwczya2lnavpl0570jr34";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  showfont = (stdenv.mkDerivation {
    name = "showfont-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/showfont-X11R7.0-1.0.1.tar.bz2;
      sha256 = "145khd5pkf1gmczzghchpvadrxq22bhdzgbyaybr72wvnagnnwaq";
    };
    buildInputs = [pkgconfig libFS ];
  }) // {inherit libFS ;};
    
  smproxy = (stdenv.mkDerivation {
    name = "smproxy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/smproxy-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0nwr7d843mzp138z6803pl6d9lwvhr5xi4mi6l756a75glrkxwan";
    };
    buildInputs = [pkgconfig libXmu libXt ];
  }) // {inherit libXmu libXt ;};
    
  trapproto = (stdenv.mkDerivation {
    name = "trapproto-3.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/trapproto-X11R7.0-3.4.3.tar.bz2;
      sha256 = "01nh71dgb2nc6nc9cycp0zvifm6k2469mby87phqj0mqj99fsbaj";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  twm = (stdenv.mkDerivation {
    name = "twm-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/twm-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0vyhrf4wnmixffcly2y6r5ksxh7lm1iali4mg478pkvsl0raakl0";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  utilmacros = (stdenv.mkDerivation {
    name = "util-macros-1.1.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/util-macros-X11R7.2-1.1.5.tar.bz2;
      sha256 = "1wk8457n6zpx0bpx8652js2h6k1406chjnlrc5xgknjh5gljmm94";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  videoproto = (stdenv.mkDerivation {
    name = "videoproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/videoproto-X11R7.0-2.2.2.tar.bz2;
      sha256 = "0dqzgwi8jbd5ka98rmsw4lbv6nh3vl0kksp380wj329y25v4ajq7";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  viewres = (stdenv.mkDerivation {
    name = "viewres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/viewres-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0a2a2k1h02cf79hcrfrkicwpx3fb9nq9pn73s3x612wwvp93zr0f";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  windowswmproto = (stdenv.mkDerivation {
    name = "windowswmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/windowswmproto-X11R7.0-1.0.3.tar.bz2;
      sha256 = "130ilmsj5bj258rwj7zzyrn501l8v1xn3gj18bfx8fxcywaxqxg5";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  x11perf = (stdenv.mkDerivation {
    name = "x11perf-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/x11perf-X11R7.1-1.4.1.tar.bz2;
      sha256 = "04jlbjvda44vk0r5xxl5kmg2i53g73a0nkhnq7v06k78d9mbcbr0";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  }) // {inherit libX11 libXext libXft libXmu libXrender ;};
    
  xauth = (stdenv.mkDerivation {
    name = "xauth-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xauth-X11R7.2-1.0.2.tar.bz2;
      sha256 = "03c1zaazhdv61fi0p2h4dy2a2jzrfj60f51s18k74h8rrvqdfi8h";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  }) // {inherit libX11 libXau libXext libXmu ;};
    
  xbiff = (stdenv.mkDerivation {
    name = "xbiff-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xbiff-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1v5vfr8v6fxdi5gyiyvyajpjj13bdqxr62m0y9n3s1dmvkyrkj69";
    };
    buildInputs = [pkgconfig libXaw xbitmaps libXext ];
  }) // {inherit libXaw xbitmaps libXext ;};
    
  xbitmaps = (stdenv.mkDerivation {
    name = "xbitmaps-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xbitmaps-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1a4llyi5rgkgypfca2im0ydcy0vqcmk5z7zp1shclwc8b37phyrx";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcalc = (stdenv.mkDerivation {
    name = "xcalc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xcalc-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1mjg5glydppwcvvspqv4v954b8d3fxf1hv7qkkk7fw1hfis9rbx1";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xcbproto = (stdenv.mkDerivation {
    name = "xcb-proto-1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-proto-1.0.tar.bz2;
      sha256 = "022fp0h1b482cp1hwyylg7q4ml6izasnwshrpp9sjmwr2c3yhg6z";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcbutil = (stdenv.mkDerivation {
    name = "xcb-util-0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://xcb.freedesktop.org/dist/xcb-util-0.1.tar.bz2;
      sha256 = "0rnj2fivgbzg9s1lsd125wk4wzv34s5r8744iwaw97nj6wd851lh";
    };
    buildInputs = [pkgconfig libxcb ];
  }) // {inherit libxcb ;};
    
  xclipboard = (stdenv.mkDerivation {
    name = "xclipboard-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xclipboard-X11R7.0-1.0.1.tar.bz2;
      sha256 = "15kxc16axcb3p5w38akzd19j38crpflpa28p1av7bln11zf4ksbl";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xclock = (stdenv.mkDerivation {
    name = "xclock-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xclock-X11R7.1-1.0.2.tar.bz2;
      sha256 = "06rfd435jqf9dmyqpvvfn2kbi740kfq4aipb8hdnn87mv7bdr10m";
    };
    buildInputs = [pkgconfig libXaw libX11 libXft libxkbfile libXrender libXt ];
  }) // {inherit libXaw libX11 libXft libxkbfile libXrender libXt ;};
    
  xcmiscproto = (stdenv.mkDerivation {
    name = "xcmiscproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xcmiscproto-X11R7.0-1.1.2.tar.bz2;
      sha256 = "1h7ngg6g6ldzn5znwp1wp5l4ckhidpqrhk1ij7chwndam9mqz3pj";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcmsdb = (stdenv.mkDerivation {
    name = "xcmsdb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xcmsdb-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0f7q7s268g7y7afkywxs4hfx1ygw8zg1p6fcw7aar659ghhdy73f";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xconsole = (stdenv.mkDerivation {
    name = "xconsole-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xconsole-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1s90vbsrdiy4krr543q96lh3yg2v06vgf9ymqfydcpjvpgrns95y";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xcursorgen = (stdenv.mkDerivation {
    name = "xcursorgen-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xcursorgen-X11R7.1-1.0.1.tar.bz2;
      sha256 = "0nkx7mwrcgib98j79wxmv1sskssw4gv8xigdyhbab6dzkly08f5f";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  }) // {inherit libpng libX11 libXcursor ;};
    
  xcursorthemes = (stdenv.mkDerivation {
    name = "xcursor-themes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xcursor-themes-X11R7.0-1.0.1.tar.bz2;
      sha256 = "04x8mgwwf7pfzxdcsps0wxahpv2i3q29ar941m7hjq9nyaj2j03k";
    };
    buildInputs = [pkgconfig libXcursor ];
  }) // {inherit libXcursor ;};
    
  xdbedizzy = (stdenv.mkDerivation {
    name = "xdbedizzy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xdbedizzy-X11R7.2-1.0.2.tar.bz2;
      sha256 = "0gz91n7s7fjzimr543gpdv96y3sqrsq3h76fmzfghdwpvc99aikx";
    };
    buildInputs = [pkgconfig libX11 libXext ];
  }) // {inherit libX11 libXext ;};
    
  xditview = (stdenv.mkDerivation {
    name = "xditview-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xditview-X11R7.0-1.0.1.tar.bz2;
      sha256 = "14h3xklfa7pndgxihm4gxf68w8b7kyym5ybwrnxv0zkzx722srn3";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xdm = (stdenv.mkDerivation {
    name = "xdm-1.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xdm-X11R7.2-1.1.3.tar.bz2;
      sha256 = "00ip6k9irqpnvmbfya914qk4q56kf57pdvxg9jzmvvcgs0arax61";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXdmcp libXext libXft libXinerama libXmu libXpm libXt ];
  }) // {inherit libXaw libX11 libXau libXdmcp libXext libXft libXinerama libXmu libXpm libXt ;};
    
  xdpyinfo = (stdenv.mkDerivation {
    name = "xdpyinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xdpyinfo-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1v9z3q3v17a7plbp9qixaammbsjbxpn4555dq2spy3s0ymr2hzyr";
    };
    buildInputs = [pkgconfig libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  }) // {inherit libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};
    
  xdriinfo = (stdenv.mkDerivation {
    name = "xdriinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xdriinfo-X11R7.1-1.0.1.tar.bz2;
      sha256 = "0qnkvxbsf0i3xvvrjbpllrxvm4zzdb9500ksyxq6sndr0ij18jch";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  }) // {inherit glproto libX11 ;};
    
  xedit = (stdenv.mkDerivation {
    name = "xedit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xedit-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1l1pjbz2niljci5yq99p49gh085s14sp8svi21n1lbx9b6bma8pv";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xev = (stdenv.mkDerivation {
    name = "xev-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xev-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1dy8mn2b5ybk9iih4ih3lf3zmbkbwn9zfxlya81xd9kzj6ksjzpb";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xextproto = (stdenv.mkDerivation {
    name = "xextproto-7.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xextproto-X11R7.0-7.0.2.tar.bz2;
      sha256 = "0fqbnyklhgspm48x6vd60jfab8zkr2wdm4kicq5pr0a3b7893h21";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xeyes = (stdenv.mkDerivation {
    name = "xeyes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xeyes-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1whsyhw4nbpsw7h3ljw9iw5in051m80h3dqvb38apklnzqib6fz9";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  xf86bigfontproto = (stdenv.mkDerivation {
    name = "xf86bigfontproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86bigfontproto-X11R7.0-1.1.2.tar.bz2;
      sha256 = "0y8byn3zczd4ljradgw5is0rfh4ipk687a70zlpkw4jgylk82jan";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86dga = (stdenv.mkDerivation {
    name = "xf86dga-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86dga-X11R7.2-1.0.2.tar.bz2;
      sha256 = "1nbp9vnvhkxsq4bwk403xpdwps533wawsci5jc4xj6y2da53y0im";
    };
    buildInputs = [pkgconfig libX11 libXaw libXmu libXt libXxf86dga ];
  }) // {inherit libX11 libXaw libXmu libXt libXxf86dga ;};
    
  xf86dgaproto = (stdenv.mkDerivation {
    name = "xf86dgaproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86dgaproto-X11R7.0-2.0.2.tar.bz2;
      sha256 = "1kw2dhbjy1y7qrfhc56ja3slg6pb0lgx1300k0qa68b9mpq20sf6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86driproto = (stdenv.mkDerivation {
    name = "xf86driproto-2.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86driproto-X11R7.0-2.0.3.tar.bz2;
      sha256 = "0979b1vy1jvs1nxs2d9qxmfqbnk14msvc27qgrpbkclppm6d0vr5";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86inputacecad = (stdenv.mkDerivation {
    name = "xf86-input-acecad-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-acecad-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0ssmfcb5z88qcw7h3ggpx3w8h5lxpfnxxkmgfvj4b5nbz17dpg5j";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputaiptek = (stdenv.mkDerivation {
    name = "xf86-input-aiptek-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-aiptek-X11R7.1-1.0.1.tar.bz2;
      sha256 = "0a6snv6i6iv96kk4q24xdypi8n5mq9730hfibv54v5v1gwvx430x";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputcalcomp = (stdenv.mkDerivation {
    name = "xf86-input-calcomp-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-calcomp-X11R7.1-1.1.0.tar.bz2;
      sha256 = "043nhm0ghr9jcjdnv82a898mn92767c7hbbi0bv5ppgap1h37wl9";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputcitron = (stdenv.mkDerivation {
    name = "xf86-input-citron-2.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-citron-X11R7.1-2.2.0.tar.bz2;
      sha256 = "0jl1sdgmhfq70k8yjqzcik0hnj2rzwzlrvdghy1b36f895vr4b9n";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdigitaledge = (stdenv.mkDerivation {
    name = "xf86-input-digitaledge-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-digitaledge-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0m42jnichp7r552knz2381g6vn4l2pqxsrhqp7q2h77kvhqx05m4";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdmc = (stdenv.mkDerivation {
    name = "xf86-input-dmc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-dmc-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1wsbn3q6zi8zhnsvcdd6kh24fmvzays34vzg1s2rcydgm5ycp1w2";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputdynapro = (stdenv.mkDerivation {
    name = "xf86-input-dynapro-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-dynapro-X11R7.1-1.1.0.tar.bz2;
      sha256 = "17w82dpdk5gxkvljqhhhanfb768d3585mg4bfpia4zwamjfml3zy";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputelo2300 = (stdenv.mkDerivation {
    name = "xf86-input-elo2300-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-elo2300-X11R7.1-1.1.0.tar.bz2;
      sha256 = "020rwjvb7y7hw1ffrh2ck2qclpjb2cq43gaj4bw1qchsh9cx9ls6";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputelographics = (stdenv.mkDerivation {
    name = "xf86-input-elographics-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-elographics-X11R7.0-1.0.0.5.tar.bz2;
      sha256 = "19yxgi8ii7p2i950gyi2i5kcsalnsdxx7l1wr0c4sgykfm0zidzi";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputevdev = (stdenv.mkDerivation {
    name = "xf86-input-evdev-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-evdev-X11R7.1-1.1.2.tar.bz2;
      sha256 = "1xmdnmfxsb3wnhxjs3iy7fdx9zrwrw0gfmggks17073ywgzv5qp1";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  }) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputfpit = (stdenv.mkDerivation {
    name = "xf86-input-fpit-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-fpit-X11R7.1-1.1.0.tar.bz2;
      sha256 = "02xcfgirf5552yak8jdym9kng0cp8zfnw2cb5by6bz3bvc5vn7d1";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputhyperpen = (stdenv.mkDerivation {
    name = "xf86-input-hyperpen-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-hyperpen-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1qw327in2b7fncqpxkwa98v7s912n0h9yfjmhfac7hl52fzcd2vr";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputjamstudio = (stdenv.mkDerivation {
    name = "xf86-input-jamstudio-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-jamstudio-X11R7.1-1.1.0.tar.bz2;
      sha256 = "05gy54xc6hpyj59rikz1nqfz74l9zb39i64bw5s36zz5qh55kk6a";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputjoystick = (stdenv.mkDerivation {
    name = "xf86-input-joystick-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-joystick-X11R7.1-1.1.0.tar.bz2;
      sha256 = "07hhzq04rr1f5w980p6q5x2f3bp5cffgzs76vciri3q6qhxvy2i4";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputkeyboard = (stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-keyboard-X11R7.2-1.1.1.tar.bz2;
      sha256 = "0iqq8cszd33cw0i92qidqb4rq090ph7z6zfgnfn1vf6slqg0zm22";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  }) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputmagellan = (stdenv.mkDerivation {
    name = "xf86-input-magellan-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-magellan-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0lxs0pgjcxpv2cnf1km14xfxg1y39i5w7midq9iq5kgn0q24www0";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmagictouch = (stdenv.mkDerivation {
    name = "xf86-input-magictouch-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-magictouch-X11R7.1-1.0.0.5.tar.bz2;
      sha256 = "0aqzx8qlfgl85ra7cgicrr5v7g7cyqq79d55lb81559xm77z23xc";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmicrotouch = (stdenv.mkDerivation {
    name = "xf86-input-microtouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-microtouch-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1sldhsh2ny8smzml9a1nka6h9xylnkvhmi4wwsabx8im91azwxi7";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmouse = (stdenv.mkDerivation {
    name = "xf86-input-mouse-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-mouse-X11R7.2-1.1.2.tar.bz2;
      sha256 = "1l9ajcmcbiv41snj7ka5gb28cshb55k3xgwk4zjnz15p65wm6ywv";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmutouch = (stdenv.mkDerivation {
    name = "xf86-input-mutouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-mutouch-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0kcyl867m471lmy2glqg098jh98v2gqd7jmj40rmkbwn0sijw6vm";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputpalmax = (stdenv.mkDerivation {
    name = "xf86-input-palmax-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-palmax-X11R7.1-1.1.0.tar.bz2;
      sha256 = "09kflb64qmqlx8ws5m6h0wlb8qv5dw18ik0zvvp6dfph35la47ii";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputpenmount = (stdenv.mkDerivation {
    name = "xf86-input-penmount-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-penmount-X11R7.2-1.2.0.tar.bz2;
      sha256 = "0xi1m4h4ppjfwixadfz8qn5ybgv12x81ir1qf7qwvpyjbbshi906";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputspaceorb = (stdenv.mkDerivation {
    name = "xf86-input-spaceorb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-spaceorb-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0dy74p0iflflhcrvsa5h04iivwafbr0zdxc497pnapjpppsxz906";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputsumma = (stdenv.mkDerivation {
    name = "xf86-input-summa-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-summa-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1a7djsjiajsgmmvxjwrhjl2d239hc5bacahrixcqvi990kx0sijp";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputtek4957 = (stdenv.mkDerivation {
    name = "xf86-input-tek4957-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-tek4957-X11R7.1-1.1.0.tar.bz2;
      sha256 = "17fi116nd6bpnfc940a2lzhz3v08d7wcxhi9kcdycry13b1pakq6";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputur98 = (stdenv.mkDerivation {
    name = "xf86-input-ur98-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-ur98-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0rnvkpx3imljslbag4z3jhh0h0d83psqj6lxq913yvsc40jflvgh";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvmmouse = (stdenv.mkDerivation {
    name = "xf86-input-vmmouse-12.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-vmmouse-X11R7.1-12.4.0.tar.bz2;
      sha256 = "0hnv11j0qj5h6f0adx3lgqca9s2d354b3wvayyrpxjfh8aj52flp";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputvoid = (stdenv.mkDerivation {
    name = "xf86-input-void-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-input-void-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0hsfa6aqydlzz9xl4x10bp2fq0pj0jpvwsnkmf6fq6pvj1da84j6";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86miscproto = (stdenv.mkDerivation {
    name = "xf86miscproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86miscproto-X11R7.0-0.9.2.tar.bz2;
      sha256 = "0nyybf02bhpqlwrdinyzwsi87bq671p757gw5h2gw1scvgir00gd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86rushproto = (stdenv.mkDerivation {
    name = "xf86rushproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86rushproto-X11R7.0-1.1.2.tar.bz2;
      sha256 = "08xr8cw6cklq66zjmxqbxf7xidgz9nsifqn09101dsf158g8h6w6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86videoapm = (stdenv.mkDerivation {
    name = "xf86-video-apm-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-apm-X11R7.1-1.1.1.tar.bz2;
      sha256 = "18p0icaxs6isa22wi7dh7spzrqy3z1i3rq51p2y8lckhwn1d8hqy";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoark = (stdenv.mkDerivation {
    name = "xf86-video-ark-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-ark-X11R7.1-0.6.0.tar.bz2;
      sha256 = "0lv6y9fdl3mb2kwbl8fgz71mcv38pwqjaabjm4qjxhv5z8nldhh6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videoast = (stdenv.mkDerivation {
    name = "xf86-video-ast-0.81.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-ast-X11R7.1-0.81.0.tar.bz2;
      sha256 = "04c8mlsrhd75jngj6y5s200bi0ghfss8hs2mdj1b91izra40q0ph";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoati = (stdenv.mkDerivation {
    name = "xf86-video-ati-6.6.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-ati-X11R7.2-6.6.3.tar.bz2;
      sha256 = "17l5wmwljaxjm8c0vwxpk2bf3bjn83n8hd1333nlcfm1hzd1xc3y";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videochips = (stdenv.mkDerivation {
    name = "xf86-video-chips-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-chips-X11R7.1-1.1.1.tar.bz2;
      sha256 = "0av5vm6gzcxm3s4mp7kkp93mjbqyi841x5lg9mmvwzhpbxazylg8";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocirrus = (stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-cirrus-X11R7.1-1.1.0.tar.bz2;
      sha256 = "033c0000bzcrkaqpbjx3kn1ss5lzsm89v1cy3mrv4146nyvpz87i";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocyrix = (stdenv.mkDerivation {
    name = "xf86-video-cyrix-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-cyrix-X11R7.1-1.1.0.tar.bz2;
      sha256 = "00lxkyq0hncjnfyxm2hcf7bcsqcd1q2lxnvz4nks4z19vkg45fi5";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videodummy = (stdenv.mkDerivation {
    name = "xf86-video-dummy-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-dummy-X11R7.1-0.2.0.tar.bz2;
      sha256 = "004wdgzprkvzp34cy23ib95ali99gls5vrd0iy7g1jzvxiw85q3k";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xf86dgaproto xorgserver xproto ;};
    
  xf86videofbdev = (stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-fbdev-X11R7.2-0.3.1.tar.bz2;
      sha256 = "19iy2agi9yzsab9mmp9sd8nkfli9cby7k981731pxqqn9jhlk782";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videoglint = (stdenv.mkDerivation {
    name = "xf86-video-glint-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-glint-X11R7.1-1.1.1.tar.bz2;
      sha256 = "1lhpajac3wp809dwh0q5lpzqyiy7p9slwaxf1m3kq4izb5qhvdr1";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};
    
  xf86videoi128 = (stdenv.mkDerivation {
    name = "xf86-video-i128-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-i128-X11R7.2-1.2.1.tar.bz2;
      sha256 = "1xlsb6gb5phmmshd7h69g6x7yzwsnwvjf6kw09iabzwfq9vq61nm";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi740 = (stdenv.mkDerivation {
    name = "xf86-video-i740-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-i740-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1xl99kdfy5lr63s39m64r3l2sg0nbl4sm6gnskc5ji487i8c3iai";
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
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-imstt-X11R7.1-1.1.0.tar.bz2;
      sha256 = "057sc5z6z4rsyax60qnhhari3rcmnm7wpnwjf6c9vaxqidd8faza";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videomga = (stdenv.mkDerivation {
    name = "xf86-video-mga-1.4.6.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-mga-X11R7.2-1.4.6.1.tar.bz2;
      sha256 = "0wy6ljmqn88ymzvnpvlssmx7nc6y5bcr0n3cw7sh48rcvln61j2f";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videoneomagic = (stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-neomagic-X11R7.1-1.1.1.tar.bz2;
      sha256 = "10ffw44h5n44az477cjdqy2yxkqzpwcs4yci4qmxwrjwfyka8frg";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonewport = (stdenv.mkDerivation {
    name = "xf86-video-newport-0.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-newport-X11R7.2-0.2.1.tar.bz2;
      sha256 = "0cjybpx3xiif0k7nlz5abn265ays0sjs1aj3979ib64c6n53mva6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videonsc = (stdenv.mkDerivation {
    name = "xf86-video-nsc-2.8.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-nsc-X11R7.2-2.8.2.tar.bz2;
      sha256 = "0j7x6rb4yjsq5vmwac6d4fzix78v185iwnl0rwhn45fsglrdw73n";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonv = (stdenv.mkDerivation {
    name = "xf86-video-nv-1.2.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-nv-X11R7.2-1.2.2.1.tar.bz2;
      sha256 = "112xs2mm0dnlp9mjma16jdb12bzs169l4gf2sdd21s5dmwsc8zs0";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videorendition = (stdenv.mkDerivation {
    name = "xf86-video-rendition-4.1.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-rendition-X11R7.2-4.1.3.tar.bz2;
      sha256 = "1hibqvb7l54x8ynmm6pa4lq9h4fb9biawc8addsv9axbkmcm5nf4";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videos3 = (stdenv.mkDerivation {
    name = "xf86-video-s3-0.5.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-s3-X11R7.2-0.5.0.tar.bz2;
      sha256 = "0z0k7166h0xybjzq3syrzs46v99nfrynr2slys1ki15xw4aw4qc0";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videos3virge = (stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-s3virge-X11R7.1-1.9.1.tar.bz2;
      sha256 = "0ciwl5pr2bmi8vam5js8xs1zbwzhcb6wffcahlb0944byfcvlpq7";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosavage = (stdenv.mkDerivation {
    name = "xf86-video-savage-2.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-savage-X11R7.2-2.1.2.tar.bz2;
      sha256 = "0xzgyjwwh0sjsxdgfd8ywwrp2k7bsiilvr5w8ricrqk2kf3l6l1x";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosiliconmotion = (stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.4.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-siliconmotion-X11R7.2-1.4.2.tar.bz2;
      sha256 = "13spjwilqwna011s9qdmga48vwqnbh4q0l77w7dj8yr577zqcpf2";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosis = (stdenv.mkDerivation {
    name = "xf86-video-sis-0.9.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-sis-X11R7.2-0.9.3.tar.bz2;
      sha256 = "0szg1rm9fag1889p82ws1yb15yyb6knagncq650mlf2xww116vjq";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosisusb = (stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-sisusb-X11R7.1-0.8.1.tar.bz2;
      sha256 = "0kdhqwqzw3q1lbxycgbxd0qahmhlg8vplr236fwxvzrh964ykpdz";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosunbw2 = (stdenv.mkDerivation {
    name = "xf86-video-sunbw2-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-sunbw2-X11R7.1-1.1.0.tar.bz2;
      sha256 = "0hsghhsvjpn6768w9v3jzz730b6sphmwjq307c0w3abbzycnqrda";
    };
    buildInputs = [pkgconfig randrproto xorgserver xproto ];
  }) // {inherit randrproto xorgserver xproto ;};
    
  xf86videosuncg14 = (stdenv.mkDerivation {
    name = "xf86-video-suncg14-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-suncg14-X11R7.1-1.1.0.tar.bz2;
      sha256 = "11vl6a2rlhhplw12hlpy53b2bj3mpynjgbnlzv30fijmgjcfx8gr";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg3 = (stdenv.mkDerivation {
    name = "xf86-video-suncg3-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-suncg3-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1nss35irq9anhvmib5wmzzgc4qcym40pnpq60561aclg9wnl1rcv";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg6 = (stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-suncg6-X11R7.1-1.1.0.tar.bz2;
      sha256 = "08g67346jjsgcdkq1whsibqa5hn696y7lwz49xq07kxh07jj4pjv";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosunffb = (stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-sunffb-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1k7zrhw74an69nw5g80sfplhppc8zrraid0pfmc6f4xawz26yh1q";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosunleo = (stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-sunleo-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1m373iqiz304yg2fywn4y5k6dwfjpb24xjm3dqygqg2vdm33jwvc";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuntcx = (stdenv.mkDerivation {
    name = "xf86-video-suntcx-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-suntcx-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1wfj5axndnqmw75nrbs4mszvqwnxp42vbfipqzdi85nisf160ni7";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videotdfx = (stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-tdfx-X11R7.2-1.3.0.tar.bz2;
      sha256 = "07lqznsad5m4d4h0pva040ibk3c0431js7gkzp0gwllsh7wwsp0j";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videotga = (stdenv.mkDerivation {
    name = "xf86-video-tga-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-tga-X11R7.1-1.1.0.tar.bz2;
      sha256 = "1dsxfql41k1jy91w9q5h2s3g69gawq4na2sl2j5ny3q7jh6xf3i5";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotrident = (stdenv.mkDerivation {
    name = "xf86-video-trident-1.2.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-trident-X11R7.2-1.2.3.tar.bz2;
      sha256 = "0771vzi6sxf8dlq84163fg2hh3swh0s2d2vglpb2ipfv5kfj2l5g";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotseng = (stdenv.mkDerivation {
    name = "xf86-video-tseng-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-tseng-X11R7.2-1.1.1.tar.bz2;
      sha256 = "1nnxs16fvl5gjlql9z0l5vhqll25gljdwrndydh7959dghc5y9v7";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videov4l = (stdenv.mkDerivation {
    name = "xf86-video-v4l-0.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-v4l-X11R7.1-0.1.1.tar.bz2;
      sha256 = "051i74p7ln4lcw9lfra4qwhygjv4q0prbz942a1a5mkgf6kavdcp";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  }) // {inherit randrproto videoproto xorgserver xproto ;};
    
  xf86videovesa = (stdenv.mkDerivation {
    name = "xf86-video-vesa-1.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-vesa-X11R7.2-1.3.0.tar.bz2;
      sha256 = "0pp645ah12yllclvvg6my67na5g7dirw1yhrbpsbvc5mkpic9zic";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovga = (stdenv.mkDerivation {
    name = "xf86-video-vga-4.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-vga-X11R7.1-4.1.0.tar.bz2;
      sha256 = "1rvld4fj0ri37svb41pkylxzzkafjak3lf0yq435q035z31mz27h";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovia = (stdenv.mkDerivation {
    name = "xf86-video-via-0.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-via-X11R7.2-0.2.2.tar.bz2;
      sha256 = "1bcaq0ijrz9xwxbyw05bgwjqvjr0md1xm8k100vqmmd1v334nrpv";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videovmware = (stdenv.mkDerivation {
    name = "xf86-video-vmware-10.14.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-vmware-X11R7.2-10.14.1.tar.bz2;
      sha256 = "1jlml1mb0072ggj3a6b3m484dsba2ln231b70b3wkzy24dy1nm5p";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xineramaproto xorgserver xproto ;};
    
  xf86videovoodoo = (stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86-video-voodoo-X11R7.2-1.1.1.tar.bz2;
      sha256 = "0bqhwp8fzmbb8nc3w4abhrb160h4mcalyl7r1pa8saflvjsasxn6";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86vidmodeproto = (stdenv.mkDerivation {
    name = "xf86vidmodeproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xf86vidmodeproto-X11R7.0-2.2.2.tar.bz2;
      sha256 = "05gxv4k0nydy4kbrk9jk13mii02zc97hifa0wpgr8bnba5z4i5r4";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xfd = (stdenv.mkDerivation {
    name = "xfd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfd-X11R7.0-1.0.1.tar.bz2;
      sha256 = "13vyszf9hgcb10s26av1mab7gd325kg7ivqj38kfamx9kaqkbzm3";
    };
    buildInputs = [pkgconfig fontconfig freetype libXaw libXft libXt ];
  }) // {inherit fontconfig freetype libXaw libXft libXt ;};
    
  xfindproxy = (stdenv.mkDerivation {
    name = "xfindproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfindproxy-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0v2vn2whva8h3vr51xj088a3f38gx8d2rp70d1msl4gf4r0k7r1k";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  xfontsel = (stdenv.mkDerivation {
    name = "xfontsel-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfontsel-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0hxbgvj1pab3zzl0aasizqr62jvc2qqr5nhgzwsixmml3hbmyyxq";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xfs = (stdenv.mkDerivation {
    name = "xfs-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfs-X11R7.2-1.0.4.tar.bz2;
      sha256 = "0h0pa3ynvqqikkvrx7jhgdjg207njbph408k1i6azqscpmwz5g39";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  }) // {inherit libFS libXfont xtrans ;};
    
  xfsinfo = (stdenv.mkDerivation {
    name = "xfsinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfsinfo-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0qwx0v007yhwa7r910fdr4v5lm7vgw05f9kpypm5i2ca6786lpwd";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  xfwp = (stdenv.mkDerivation {
    name = "xfwp-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xfwp-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0aglkcyz5043dq24klignlsr6gmib27cpisgklddwv1f284cwcyk";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol ];
  }) // {inherit libICE libX11 xproxymanagementprotocol ;};
    
  xgamma = (stdenv.mkDerivation {
    name = "xgamma-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xgamma-X11R7.0-1.0.1.tar.bz2;
      sha256 = "11lamm2as65ywxw63vd06pzwzhi6ccpjcmpjywq0s1vcy0sl6x7c";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  }) // {inherit libX11 libXxf86vm ;};
    
  xgc = (stdenv.mkDerivation {
    name = "xgc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xgc-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1s2lwk4avql8kpy0zlf5wqgksf78zz31jqf4713qgag72a5d0lb1";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xhost = (stdenv.mkDerivation {
    name = "xhost-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xhost-X11R7.1-1.0.1.tar.bz2;
      sha256 = "1n365k4704wnnscl5l00mkq1qc7a79pi0b2cxh3yiidha87s2s5r";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  }) // {inherit libX11 libXau libXmu ;};
    
  xineramaproto = (stdenv.mkDerivation {
    name = "xineramaproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xineramaproto-X11R7.0-1.1.2.tar.bz2;
      sha256 = "1pq6akfgijmi9a1nhjkbnx9bqgyz99sjfi26cx558gyj8zxhskgp";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xinit = (stdenv.mkDerivation {
    name = "xinit-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xinit-X11R7.2-1.0.3.tar.bz2;
      sha256 = "18908namjyjczp703b1jm7xfx39xahc3lclccfr8q7dka189w428";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xkbcomp = (stdenv.mkDerivation {
    name = "xkbcomp-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xkbcomp-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0n1lhb5qvhgf9wc9l7mnrm01p4psf6gv704k1l0mi9albqr257kh";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbevd = (stdenv.mkDerivation {
    name = "xkbevd-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xkbevd-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0jjwvw7g9q0jr5bxa2kkhv39dx20a0il1c701mlxxlfw8n009aw6";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbprint = (stdenv.mkDerivation {
    name = "xkbprint-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xkbprint-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1rqhzhvxjvmy92cbkfbc4n537gfsgbd8pi20rr0h8093iv1c7sfj";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbutils = (stdenv.mkDerivation {
    name = "xkbutils-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xkbutils-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0bz93fc770vn74zahljl60zvzbnbvpxp5znw1b549s7nbb2a2y41";
    };
    buildInputs = [pkgconfig libXaw libX11 libxkbfile ];
  }) // {inherit libXaw libX11 libxkbfile ;};
    
  xkill = (stdenv.mkDerivation {
    name = "xkill-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xkill-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1km3yq0r7h9bk1s0g9ypvii6lq2saa8276wgfzx8xbrzskfdyngy";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xload = (stdenv.mkDerivation {
    name = "xload-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xload-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0w47cs1p1w748br0p8vqpz7j9f1jiyzcdjzill2g0ik6ivskwnvb";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xlogo = (stdenv.mkDerivation {
    name = "xlogo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xlogo-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0cc1sa52r5cdb4cj2g38krv00i2dgnb5wi5wfdzr1s07mrxkg5qk";
    };
    buildInputs = [pkgconfig libXaw libXext libXft libXp libXprintUtil libXrender libXt ];
  }) // {inherit libXaw libXext libXft libXp libXprintUtil libXrender libXt ;};
    
  xlsatoms = (stdenv.mkDerivation {
    name = "xlsatoms-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xlsatoms-X11R7.0-1.0.1.tar.bz2;
      sha256 = "18z9aq9bwna3bczb7n3diwjqgsl99xzpiknag12r7iws65r9h1va";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsclients = (stdenv.mkDerivation {
    name = "xlsclients-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xlsclients-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1f6fj472pz5yilahlnyqf3n30qzlfs33r21ji95za7pd4binkhh5";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsfonts = (stdenv.mkDerivation {
    name = "xlsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xlsfonts-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0vzwmrppqkz22jilsrap00dzw876v3bnxzn6qrmz1h6syzaj738z";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmag = (stdenv.mkDerivation {
    name = "xmag-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xmag-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1lcwzl7w1nbiy04zg6kc7vh21qdi37jga81c8n0x8d6kqrbxhffh";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xman = (stdenv.mkDerivation {
    name = "xman-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xman-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0kk50ixxl9n032599s7fpxhx70msbxxckhril89aj835grvrbwd7";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xmessage = (stdenv.mkDerivation {
    name = "xmessage-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xmessage-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0wzl3pv4kq7dgppd3jbi44c3yhdj1301xsh0wbzxx378dbni7jz9";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmh = (stdenv.mkDerivation {
    name = "xmh-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xmh-X11R7.0-1.0.1.tar.bz2;
      sha256 = "12sv1lh39yr7ri2rgl4m7npl5bs19hqf3lmga4bp9bgwsjvvyv78";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmodmap = (stdenv.mkDerivation {
    name = "xmodmap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xmodmap-X11R7.2-1.0.2.tar.bz2;
      sha256 = "1paqq482v1q62zda59gdpanq1y6a4j5phc72crdvh1hrdh9wn7nh";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmore = (stdenv.mkDerivation {
    name = "xmore-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xmore-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1hglvr9sjbdw00kmc4ibljwy3xdkcln42zn2ys3hg6dasz4d45h6";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xorgcffiles = (stdenv.mkDerivation {
    name = "xorg-cf-files-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xorg-cf-files-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0196z9nl2bl50i986zfa58kidajckwjkyi90237c8f3xy1zxyi30";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgdocs = (stdenv.mkDerivation {
    name = "xorg-docs-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xorg-docs-X11R7.1-1.2.tar.bz2;
      sha256 = "1ysffjsjlzzd7q7b1b87nclqya0lrkwlvc6g6ashihqljafmc62i";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgserver = (stdenv.mkDerivation {
    name = "xorg-server-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xorg-server-X11R7.2-1.2.0.tar.bz2;
      sha256 = "023a13aay8gd09a7x1s6wndbsj3xr2ismsvgbsi9dz4g7nw8ga96";
    };
    patches = [./xorgserver-dri-path.patch];
    buildInputs = [pkgconfig bigreqsproto compositeproto damageproto libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto inputproto kbproto libdrm mkfontdir mkfontscale perl printproto randrproto recordproto renderproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ]; mesaSrc = mesa.src; x11BuildHook = ./xorgserver.sh; 
  }) // {inherit bigreqsproto compositeproto damageproto libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto inputproto kbproto libdrm mkfontdir mkfontscale perl printproto randrproto recordproto renderproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfixes libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ;};
    
  xorgsgmldoctools = (stdenv.mkDerivation {
    name = "xorg-sgml-doctools-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xorg-sgml-doctools-X11R7.2-1.1.1.tar.bz2;
      sha256 = "0hvcs394vv1yka30lilpzn67mqai3hh41cwhf2c7lfzbg4a1i12k";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xphelloworld = (stdenv.mkDerivation {
    name = "xphelloworld-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xphelloworld-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1gw2765zgwyj2cqmc53hy8hk5j1w79f4zxfw31rpkc05jkn63g2g";
    };
    buildInputs = [pkgconfig libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ];
  }) // {inherit libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ;};
    
  xplsprinters = (stdenv.mkDerivation {
    name = "xplsprinters-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xplsprinters-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0fvs4pqa2866bs2zgc3ih3vkkrqr8z44mm39b78maiczq2g26m2g";
    };
    buildInputs = [pkgconfig libX11 libXp libXprintUtil ];
  }) // {inherit libX11 libXp libXprintUtil ;};
    
  xpr = (stdenv.mkDerivation {
    name = "xpr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xpr-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1x6d8vga4ggfr5k5y9idiy4gkp9rqh9h1ny5kba80k0i2dijaxwc";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xprehashprinterlist = (stdenv.mkDerivation {
    name = "xprehashprinterlist-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xprehashprinterlist-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0wqxy4ay3ssdjxabv5krl1bn8g6a5i83r1l83gki436n8v8gaa6c";
    };
    buildInputs = [pkgconfig libX11 libXp ];
  }) // {inherit libX11 libXp ;};
    
  xprop = (stdenv.mkDerivation {
    name = "xprop-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xprop-X11R7.2-1.0.2.tar.bz2;
      sha256 = "1nzpz7faq5v9yyrnp1cqrd0w0nxr93bpsvwl416h38vw6x99p17z";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xproto = (stdenv.mkDerivation {
    name = "xproto-7.0.10";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xproto-X11R7.2-7.0.10.tar.bz2;
      sha256 = "0dwkf445sc8isvfkf2pqk2fwfpv3y2gdn3aq8j293hx23kara75w";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xproxymanagementprotocol = (stdenv.mkDerivation {
    name = "xproxymanagementprotocol-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xproxymanagementprotocol-X11R7.0-1.0.2.tar.bz2;
      sha256 = "13xlwxgm00ycskcrfahifp29paa4sayb6xi1wapc6cnkvx151hpk";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xrandr = (stdenv.mkDerivation {
    name = "xrandr-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xrandr-X11R7.1-1.0.2.tar.bz2;
      sha256 = "14vpk0hqg7spjhx2y8p06jnswi5iv4d8r59sslikrfblcs1a2cpk";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  }) // {inherit libX11 libXrandr libXrender ;};
    
  xrdb = (stdenv.mkDerivation {
    name = "xrdb-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xrdb-X11R7.1-1.0.2.tar.bz2;
      sha256 = "15v3726g6qnndqc7mqmsvabf5a3dvzzy66y7lhqd8j22a6q9is4b";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xrefresh = (stdenv.mkDerivation {
    name = "xrefresh-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xrefresh-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0jq3jsiqrbig5m3c9ki0fqlfyr9hpw1ziridli7mch31v3crckwn";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xrx = (stdenv.mkDerivation {
    name = "xrx-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xrx-X11R7.0-1.0.1.tar.bz2;
      sha256 = "03iib9zsw6f0kfgdfa9mkpxj0sfvh14w19v0j88dqby96sgpl5ra";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ];
  }) // {inherit libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ;};
    
  xset = (stdenv.mkDerivation {
    name = "xset-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xset-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1m1n27sdi845k7h1y3vq8dsy0b60m0i39q9s96lkmjnri308szpj";
    };
    buildInputs = [pkgconfig libX11 libXext libXfontcache libXmu libXp libXxf86misc ];
  }) // {inherit libX11 libXext libXfontcache libXmu libXp libXxf86misc ;};
    
  xsetmode = (stdenv.mkDerivation {
    name = "xsetmode-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xsetmode-X11R7.0-1.0.0.tar.bz2;
      sha256 = "0jlyf2ghnsvj27pjczpga2l4afi0kvzx658xq1mp8py3fxn0fzpz";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetpointer = (stdenv.mkDerivation {
    name = "xsetpointer-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xsetpointer-X11R7.0-1.0.0.tar.bz2;
      sha256 = "01ndlvxydzcawi5pirfzxrfdwhs4mc48xfr77bpkg4iyaajkaghh";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetroot = (stdenv.mkDerivation {
    name = "xsetroot-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xsetroot-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0i7yy3bp1hfhwk9rkkmckzsib8nwf7wnnpcddk017g8x96ac49w3";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXmu ];
  }) // {inherit libX11 xbitmaps libXmu ;};
    
  xsm = (stdenv.mkDerivation {
    name = "xsm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xsm-X11R7.0-1.0.1.tar.bz2;
      sha256 = "0jbab4jd2qjfqr5wp7rha2mp64hs6a1qympif8rdraaagc8pavn6";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xstdcmap = (stdenv.mkDerivation {
    name = "xstdcmap-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xstdcmap-X11R7.0-1.0.1.tar.bz2;
      sha256 = "134a4dxh0i1zm9d93mnx0nwi650x559wvxi4lj9qbwnx7r17xw1s";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xtrans = (stdenv.mkDerivation {
    name = "xtrans-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xtrans-X11R7.2-1.0.3.tar.bz2;
      sha256 = "0c2wkzr40np9lxq5yxmbc4h11wp0b4r8a3bb3ypdqsdbdr0da5qk";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xtrap = (stdenv.mkDerivation {
    name = "xtrap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xtrap-X11R7.1-1.0.2.tar.bz2;
      sha256 = "1irg89fz09grjzsl4dnwxi7fs27iilhrsjd1bvwlnzvkwdhfc7i9";
    };
    buildInputs = [pkgconfig libX11 libXTrap ];
  }) // {inherit libX11 libXTrap ;};
    
  xvidtune = (stdenv.mkDerivation {
    name = "xvidtune-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xvidtune-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1kgmig2qnzi6ix9iz14rxpi4hv8yabh4sxz5sd3d30crgrfr5czp";
    };
    buildInputs = [pkgconfig libXaw libXt libXxf86vm ];
  }) // {inherit libXaw libXt libXxf86vm ;};
    
  xvinfo = (stdenv.mkDerivation {
    name = "xvinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xvinfo-X11R7.0-1.0.1.tar.bz2;
      sha256 = "1xlp6sy26n0b6fhad6i6hydf2hz0fqi8zx8mzdr373pg38jafljv";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  }) // {inherit libX11 libXv ;};
    
  xwd = (stdenv.mkDerivation {
    name = "xwd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xwd-X11R7.0-1.0.1.tar.bz2;
      sha256 = "04gvy3vn99q9q1w7y72wjczwy75ckds2fxvccs0kd3y89vrsph4f";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xwininfo = (stdenv.mkDerivation {
    name = "xwininfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xwininfo-X11R7.1-1.0.2.tar.bz2;
      sha256 = "0pjx2imqd12gawi25gcsgj49q0fk08d1xrwlqs4g0n3fadyn3z2m";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu ];
  }) // {inherit libX11 libXext libXmu ;};
    
  xwud = (stdenv.mkDerivation {
    name = "xwud-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.2/src/everything/xwud-X11R7.0-1.0.1.tar.bz2;
      sha256 = "11hm1w132w17g330rnph0f2dlqn58cvnnld9dr10fbv3mm87j351";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
}
