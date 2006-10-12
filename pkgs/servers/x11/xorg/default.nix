# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, expat, libdrm, libpng, zlib, perl, mesa
}:

rec {

  applewmproto = (stdenv.mkDerivation {
    name = "applewmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/applewmproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "2acf46c814a27c40acd3e448ed17fee3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  appres = (stdenv.mkDerivation {
    name = "appres-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/appres-X11R7.0-1.0.0.tar.bz2;
      md5 = "3327357fc851a49e8e5dc44405e7b862";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  }) // {inherit libX11 libXt ;};
    
  bdftopcf = (stdenv.mkDerivation {
    name = "bdftopcf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/bdftopcf-X11R7.0-1.0.0.tar.bz2;
      md5 = "f43667fcf613054cae0679f5dc5a1e7a";
    };
    buildInputs = [pkgconfig libXfont ];
  }) // {inherit libXfont ;};
    
  beforelight = (stdenv.mkDerivation {
    name = "beforelight-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/beforelight-X11R7.0-1.0.1.tar.bz2;
      md5 = "e0326eff9d1bd4e3a1af9e615a0048b3";
    };
    buildInputs = [pkgconfig libX11 libXaw libXScrnSaver libXt ];
  }) // {inherit libX11 libXaw libXScrnSaver libXt ;};
    
  bigreqsproto = (stdenv.mkDerivation {
    name = "bigreqsproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/bigreqsproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "ec15d17e3f04ddb5870ef7239b4ab367";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  bitmap = (stdenv.mkDerivation {
    name = "bitmap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/bitmap-X11R7.1-1.0.2.tar.bz2;
      md5 = "5a6228512bcce7d9fabe8fc2d66269bf";
    };
    buildInputs = [pkgconfig libXaw libX11 xbitmaps libXmu libXt ];
  }) // {inherit libXaw libX11 xbitmaps libXmu libXt ;};
    
  compositeproto = (stdenv.mkDerivation {
    name = "compositeproto-0.3.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/compositeproto-X11R7.1-0.3.1.tar.bz2;
      md5 = "8e85c1e19a3169a42c5e860c36ec3e3b";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  damageproto = (stdenv.mkDerivation {
    name = "damageproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/damageproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "b906344d68e09a5639deb0097bd74224";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  dmxproto = (stdenv.mkDerivation {
    name = "dmxproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/dmxproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "21c79302beb868a078490549f558cdcf";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  editres = (stdenv.mkDerivation {
    name = "editres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/editres-X11R7.0-1.0.1.tar.bz2;
      md5 = "a9dc7f3b0cb59f08ab1e6554a5e60721";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  encodings = (stdenv.mkDerivation {
    name = "encodings-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/encodings-X11R7.0-1.0.0.tar.bz2;
      md5 = "385cbd4093b610610ca54c06cbb0f497";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  evieext = (stdenv.mkDerivation {
    name = "evieext-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/evieext-X11R7.0-1.0.2.tar.bz2;
      md5 = "411c0d4f9eaa7d220a8d13edc790e3de";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fixesproto = (stdenv.mkDerivation {
    name = "fixesproto-4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/fixesproto-X11R7.1-4.0.tar.bz2;
      md5 = "7ba155d9209fa7320fc387b338457bc6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontadobe100dpi = (stdenv.mkDerivation {
    name = "font-adobe-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "f5de34fa63976de9263f032453348f6c";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontadobe75dpi = (stdenv.mkDerivation {
    name = "font-adobe-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "361fc4c9da3c34c5105df4f4688029d0";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontadobeutopia100dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-100dpi-X11R7.0-1.0.1.tar.bz2;
      md5 = "b720eed8eba0e4c5bcb9fdf6c2003355";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontadobeutopia75dpi = (stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-75dpi-X11R7.0-1.0.1.tar.bz2;
      md5 = "a6d5d355b92a7e640698c934b0b79b53";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontadobeutopiatype1 = (stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-type1-X11R7.0-1.0.1.tar.bz2;
      md5 = "db1cc2f707cffd08a461f093b55ced5e";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontalias = (stdenv.mkDerivation {
    name = "font-alias-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-alias-X11R7.0-1.0.1.tar.bz2;
      md5 = "de7035b15ba7edc36f8685ab3c17a9cf";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontarabicmisc = (stdenv.mkDerivation {
    name = "font-arabic-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-arabic-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "b95dc750ddc7d511e1f570034d9e1b27";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbh100dpi = (stdenv.mkDerivation {
    name = "font-bh-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "29eeed0ad42653f27b929119581deb3e";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontbh75dpi = (stdenv.mkDerivation {
    name = "font-bh-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "7546c97560eb325400365adbc426308b";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontbhlucidatypewriter100dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-lucidatypewriter-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "8a56f4cbea74f4dbbf9bdac95686dca8";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontbhlucidatypewriter75dpi = (stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-lucidatypewriter-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "e5cccf93f4f1f793cd32adfa81cc1b40";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontbhttf = (stdenv.mkDerivation {
    name = "font-bh-ttf-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-ttf-X11R7.0-1.0.0.tar.bz2;
      md5 = "53b984889aec3c0c2eb07f8aaa49dba9";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbhtype1 = (stdenv.mkDerivation {
    name = "font-bh-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "302111513d1e94303c0ec0139d5ae681";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbitstream100dpi = (stdenv.mkDerivation {
    name = "font-bitstream-100dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "dc595e77074de890974726769f25e123";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbitstream75dpi = (stdenv.mkDerivation {
    name = "font-bitstream-75dpi-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "408515646743d14e1e2e240da4fffdc2";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbitstreamspeedo = (stdenv.mkDerivation {
    name = "font-bitstream-speedo-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-speedo-X11R7.0-1.0.0.tar.bz2;
      md5 = "068c78ce48e5e6c4f25e0bba839a6b7a";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontbitstreamtype1 = (stdenv.mkDerivation {
    name = "font-bitstream-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "f4881a7e28eaeb7580d5eaf0f09239da";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontcacheproto = (stdenv.mkDerivation {
    name = "fontcacheproto-0.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fontcacheproto-X11R7.0-0.1.2.tar.bz2;
      md5 = "116997d63cf6f65b75593ff5ae7afecb";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontcronyxcyrillic = (stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-cronyx-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "447163fff74b57968fc5139d8b2ad988";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontcursormisc = (stdenv.mkDerivation {
    name = "font-cursor-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-cursor-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "82e89de0e1b9c95f32b0fc12f5131d2c";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontdaewoomisc = (stdenv.mkDerivation {
    name = "font-daewoo-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-daewoo-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "2fd7e6c8c21990ad906872efd02f3873";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontdecmisc = (stdenv.mkDerivation {
    name = "font-dec-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-dec-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "7ff9aba4c65aa226bda7528294c7998c";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontibmtype1 = (stdenv.mkDerivation {
    name = "font-ibm-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-ibm-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "fab2c49cb0f9fcee0bc0ac77e510d4e5";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontisasmisc = (stdenv.mkDerivation {
    name = "font-isas-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-isas-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "c0981507c9276c22956c7bfe932223d9";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontjismisc = (stdenv.mkDerivation {
    name = "font-jis-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-jis-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "3732ca6c34d03e44c73f0c103512ef26";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontmicromisc = (stdenv.mkDerivation {
    name = "font-micro-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-micro-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "eb0050d73145c5b9fb6b9035305edeb6";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontmisccyrillic = (stdenv.mkDerivation {
    name = "font-misc-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "58d31311e8e51efbe16517adaf1a239d";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontmiscethiopic = (stdenv.mkDerivation {
    name = "font-misc-ethiopic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-ethiopic-X11R7.0-1.0.0.tar.bz2;
      md5 = "190738980705826a27fbf4685650d3b9";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontmiscmeltho = (stdenv.mkDerivation {
    name = "font-misc-meltho-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-meltho-X11R7.0-1.0.0.tar.bz2;
      md5 = "8812c57220bcd139b4ba6266eafbd712";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontmiscmisc = (stdenv.mkDerivation {
    name = "font-misc-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "4a5a7987183a9e1ea232c8391ae4c244";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontmuttmisc = (stdenv.mkDerivation {
    name = "font-mutt-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-mutt-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "139b368edecf8185d16a33b4a7c09657";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontschumachermisc = (stdenv.mkDerivation {
    name = "font-schumacher-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-schumacher-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "d51808138ef63b84363f7d82ed8bb681";
    };
    buildInputs = [pkgconfig fontutil ];
  }) // {inherit fontutil ;};
    
  fontscreencyrillic = (stdenv.mkDerivation {
    name = "font-screen-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-screen-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "c08da585feb173e1b27c3fbf8f90ba45";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontsonymisc = (stdenv.mkDerivation {
    name = "font-sony-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-sony-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "014725f97635da9e5e9b303ab796817e";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontsproto = (stdenv.mkDerivation {
    name = "fontsproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fontsproto-X11R7.0-2.0.2.tar.bz2;
      md5 = "e2ca22df3a20177f060f04f15b8ce19b";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontsunmisc = (stdenv.mkDerivation {
    name = "font-sun-misc-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-sun-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "0259436c430034f24f3b239113c9630e";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fonttosfnt = (stdenv.mkDerivation {
    name = "fonttosfnt-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fonttosfnt-X11R7.0-1.0.1.tar.bz2;
      md5 = "89b65e010acaa3c5d370e1cc0ea9fce9";
    };
    buildInputs = [pkgconfig libfontenc freetype xproto ];
  }) // {inherit libfontenc freetype xproto ;};
    
  fontutil = (stdenv.mkDerivation {
    name = "font-util-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/font-util-X11R7.1-1.0.1.tar.bz2;
      md5 = "69ba2181665e291ea09908a11136c21a";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontwinitzkicyrillic = (stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-winitzki-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "6dc447609609e4e2454ad7da29873501";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fontxfree86type1 = (stdenv.mkDerivation {
    name = "font-xfree86-type1-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-xfree86-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "27a6bbf5c8bbe998ff7e8537929ccbc8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  fslsfonts = (stdenv.mkDerivation {
    name = "fslsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fslsfonts-X11R7.0-1.0.1.tar.bz2;
      md5 = "c500b96cfec485e362204a8fc0bdfd44";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  fstobdf = (stdenv.mkDerivation {
    name = "fstobdf-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/fstobdf-X11R7.1-1.0.2.tar.bz2;
      md5 = "e6f102e10f0861c972a250e4fc57fdc2";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  gccmakedep = (stdenv.mkDerivation {
    name = "gccmakedep-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/gccmakedep-X11R7.1-1.0.2.tar.bz2;
      md5 = "519e8b1a9911bdddfa2ee46fb36b9774";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  glproto = (stdenv.mkDerivation {
    name = "glproto-1.4.7";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/glproto-X11R7.1-1.4.7.tar.bz2;
      md5 = "26744ff426147b2400b20e5c8b1eb735";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  iceauth = (stdenv.mkDerivation {
    name = "iceauth-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/iceauth-X11R7.0-1.0.1.tar.bz2;
      md5 = "92035bd69b4c9aba47607ba0efcc8530";
    };
    buildInputs = [pkgconfig libICE xproto ];
  }) // {inherit libICE xproto ;};
    
  ico = (stdenv.mkDerivation {
    name = "ico-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/ico-X11R7.0-1.0.1.tar.bz2;
      md5 = "9c63d68a779819ba79e45d9b15d26b1f";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  imake = (stdenv.mkDerivation {
    name = "imake-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/imake-X11R7.1-1.0.2.tar.bz2;
      md5 = "db33c65135ebc78e55c6009292c51b43";
    };
    buildInputs = [pkgconfig xproto ]; inherit xorgcffiles; x11BuildHook = ./imake.sh; patches = [./imake.patch]; 
  }) // {inherit xproto ;};
    
  inputproto = (stdenv.mkDerivation {
    name = "inputproto-1.3.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/inputproto-X11R7.0-1.3.2.tar.bz2;
      md5 = "0da271f396bede5b8d09a61f6d1c4484";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  kbproto = (stdenv.mkDerivation {
    name = "kbproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/kbproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "403f56d717b3fefe465ddd03d9c7bc81";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  lbxproxy = (stdenv.mkDerivation {
    name = "lbxproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/lbxproxy-X11R7.0-1.0.1.tar.bz2;
      md5 = "d9c05283660eae742a77dcbc0091841a";
    };
    buildInputs = [pkgconfig bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ];
  }) // {inherit bigreqsproto libICE liblbxutil libX11 libXext xproxymanagementprotocol xtrans zlib ;};
    
  libAppleWM = (stdenv.mkDerivation {
    name = "libAppleWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libAppleWM-X11R7.0-1.0.0.tar.bz2;
      md5 = "8af30932ebc278835375fca34a2790f5";
    };
    buildInputs = [pkgconfig applewmproto libX11 libXext xextproto ];
  }) // {inherit applewmproto libX11 libXext xextproto ;};
    
  libFS = (stdenv.mkDerivation {
    name = "libFS-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libFS-X11R7.0-1.0.0.tar.bz2;
      md5 = "12d2d89e7eb6ab0eb5823c3296f4e7a5";
    };
    buildInputs = [pkgconfig fontsproto xproto xtrans ];
  }) // {inherit fontsproto xproto xtrans ;};
    
  libICE = (stdenv.mkDerivation {
    name = "libICE-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libICE-X11R7.1-1.0.1.tar.bz2;
      md5 = "b372dcd527fd5b5058e77ee1b586afdf";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  }) // {inherit xproto xtrans ;};
    
  libSM = (stdenv.mkDerivation {
    name = "libSM-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libSM-X11R7.1-1.0.1.tar.bz2;
      md5 = "dc10726abe267727fa5e3c552594e3c8";
    };
    buildInputs = [pkgconfig libICE xproto xtrans ];
  }) // {inherit libICE xproto xtrans ;};
    
  libWindowsWM = (stdenv.mkDerivation {
    name = "libWindowsWM-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libWindowsWM-X11R7.0-1.0.0.tar.bz2;
      md5 = "d94f0389cd655b50e2987d5b988b82a5";
    };
    buildInputs = [pkgconfig windowswmproto libX11 libXext xextproto ];
  }) // {inherit windowswmproto libX11 libXext xextproto ;};
    
  libX11 = (stdenv.mkDerivation {
    name = "libX11-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libX11-X11R7.1-1.0.1.tar.bz2;
      md5 = "f592bec1848e55c377b45e629eb09df4";
    };
    buildInputs = [pkgconfig bigreqsproto inputproto kbproto libXau xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ];
  }) // {inherit bigreqsproto inputproto kbproto libXau xcmiscproto libXdmcp xextproto xf86bigfontproto xproto xtrans ;};
    
  libXScrnSaver = (stdenv.mkDerivation {
    name = "libXScrnSaver-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXScrnSaver-X11R7.1-1.1.0.tar.bz2;
      md5 = "e9a4ed1a499595003b75a34a5633e93e";
    };
    buildInputs = [pkgconfig scrnsaverproto libX11 libXext xextproto ];
  }) // {inherit scrnsaverproto libX11 libXext xextproto ;};
    
  libXTrap = (stdenv.mkDerivation {
    name = "libXTrap-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXTrap-X11R7.0-1.0.0.tar.bz2;
      md5 = "8f2f1cc3b35f005e9030e162d89e2bdd";
    };
    buildInputs = [pkgconfig trapproto libX11 libXext xextproto libXt ];
  }) // {inherit trapproto libX11 libXext xextproto libXt ;};
    
  libXau = (stdenv.mkDerivation {
    name = "libXau-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXau-X11R7.1-1.0.1.tar.bz2;
      md5 = "ae91d7080784df34b2fab7bff75cfb41";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXaw = (stdenv.mkDerivation {
    name = "libXaw-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXaw-X11R7.1-1.0.2.tar.bz2;
      md5 = "99f2e6a3ff8e5535710150aa30f5b3c3";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ];
  }) // {inherit printproto libX11 libXau libXext xextproto libXmu libXp libXpm xproto libXt ;};
    
  libXcomposite = (stdenv.mkDerivation {
    name = "libXcomposite-0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXcomposite-X11R7.1-0.3.tar.bz2;
      md5 = "f5229a7a38bc3d90380b7c18de10db5e";
    };
    buildInputs = [pkgconfig compositeproto ];
  }) // {inherit compositeproto ;};
    
  libXcursor = (stdenv.mkDerivation {
    name = "libXcursor-1.1.6";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXcursor-X11R7.1-1.1.6.tar.bz2;
      md5 = "a69f8735a0c1fc1df260ca4feaf4be87";
    };
    buildInputs = [pkgconfig fixesproto libX11 libXfixes libXrender ];
  }) // {inherit fixesproto libX11 libXfixes libXrender ;};
    
  libXdamage = (stdenv.mkDerivation {
    name = "libXdamage-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXdamage-X11R7.1-1.0.3.tar.bz2;
      md5 = "e9cd3688623c9c5a86d7ddb62fd88d76";
    };
    buildInputs = [pkgconfig damageproto libX11 ];
  }) // {inherit damageproto libX11 ;};
    
  libXdmcp = (stdenv.mkDerivation {
    name = "libXdmcp-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXdmcp-X11R7.1-1.0.1.tar.bz2;
      md5 = "d74e6e52d598544f92e2c185e114e656";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  libXevie = (stdenv.mkDerivation {
    name = "libXevie-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXevie-X11R7.1-1.0.1.tar.bz2;
      md5 = "0f0eb4c5441a26341d3b774bc9db35ba";
    };
    buildInputs = [pkgconfig evieext libX11 libXext xextproto xproto ];
  }) // {inherit evieext libX11 libXext xextproto xproto ;};
    
  libXext = (stdenv.mkDerivation {
    name = "libXext-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXext-X11R7.1-1.0.1.tar.bz2;
      md5 = "273845ee8a2d5e272bb3fa08810512f3";
    };
    buildInputs = [pkgconfig libX11 libXau xextproto xproto ];
  }) // {inherit libX11 libXau xextproto xproto ;};
    
  libXfixes = (stdenv.mkDerivation {
    name = "libXfixes-4.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXfixes-X11R7.1-4.0.1.tar.bz2;
      md5 = "d6e91a6d366a72c090cae83da88af184";
    };
    buildInputs = [pkgconfig fixesproto libX11 xproto ];
  }) // {inherit fixesproto libX11 xproto ;};
    
  libXfont = (stdenv.mkDerivation {
    name = "libXfont-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXfont-X11R7.1-1.1.0.tar.bz2;
      md5 = "d25a2c90b882c5f2ff7f13a300aa18f4";
    };
    buildInputs = [pkgconfig fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ];
  }) // {inherit fontcacheproto libfontenc fontsproto freetype xproto xtrans zlib ;};
    
  libXfontcache = (stdenv.mkDerivation {
    name = "libXfontcache-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXfontcache-X11R7.1-1.0.2.tar.bz2;
      md5 = "87299d9c6d74b3b68e60bb4b693f5d62";
    };
    buildInputs = [pkgconfig fontcacheproto libX11 libXext xextproto ];
  }) // {inherit fontcacheproto libX11 libXext xextproto ;};
    
  libXft = (stdenv.mkDerivation {
    name = "libXft-2.1.8.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXft-X11R7.0-2.1.8.2.tar.bz2;
      md5 = "c42292b35325a9eeb24eb0f8d3a6ec52";
    };
    buildInputs = [pkgconfig fontconfig freetype libXrender ];
  }) // {inherit fontconfig freetype libXrender ;};
    
  libXi = (stdenv.mkDerivation {
    name = "libXi-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXi-X11R7.1-1.0.1.tar.bz2;
      md5 = "2e3782d25d5fa6c98cfcaf055556f5c7";
    };
    buildInputs = [pkgconfig inputproto libX11 libXext xextproto xproto ];
  }) // {inherit inputproto libX11 libXext xextproto xproto ;};
    
  libXinerama = (stdenv.mkDerivation {
    name = "libXinerama-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXinerama-X11R7.0-1.0.1.tar.bz2;
      md5 = "1a1be870bb106193a4acc73c8c584dbc";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  }) // {inherit libX11 libXext xextproto xineramaproto ;};
    
  libXmu = (stdenv.mkDerivation {
    name = "libXmu-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXmu-X11R7.1-1.0.1.tar.bz2;
      md5 = "d68cacb66ee72e43d0a6b1f8b2dc901a";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXt ];
  }) // {inherit libX11 libXext xextproto libXt ;};
    
  libXp = (stdenv.mkDerivation {
    name = "libXp-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXp-X11R7.0-1.0.0.tar.bz2;
      md5 = "63c3048e06da4f6a033c5ce25217b0c3";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXext xextproto ];
  }) // {inherit printproto libX11 libXau libXext xextproto ;};
    
  libXpm = (stdenv.mkDerivation {
    name = "libXpm-3.5.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXpm-X11R7.1-3.5.5.tar.bz2;
      md5 = "00d91c2bcc4d2941e08339f3989c2351";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xproto libXt ];
  }) // {inherit libX11 libXext xextproto xproto libXt ;};
    
  libXprintAppUtil = (stdenv.mkDerivation {
    name = "libXprintAppUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXprintAppUtil-X11R7.0-1.0.1.tar.bz2;
      md5 = "6d3f5d8d1f6c2c380bfc739128f41909";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXprintUtil ];
  }) // {inherit printproto libX11 libXau libXp libXprintUtil ;};
    
  libXprintUtil = (stdenv.mkDerivation {
    name = "libXprintUtil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXprintUtil-X11R7.0-1.0.1.tar.bz2;
      md5 = "47f1863042a53a48b40c2fb0aa55a8f7";
    };
    buildInputs = [pkgconfig printproto libX11 libXau libXp libXt ];
  }) // {inherit printproto libX11 libXau libXp libXt ;};
    
  libXrandr = (stdenv.mkDerivation {
    name = "libXrandr-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXrandr-X11R7.1-1.1.1.tar.bz2;
      md5 = "021e870b637f26be58b4b1acbdea19ca";
    };
    buildInputs = [pkgconfig randrproto renderproto libX11 libXext xextproto libXrender ];
  }) // {inherit randrproto renderproto libX11 libXext xextproto libXrender ;};
    
  libXrender = (stdenv.mkDerivation {
    name = "libXrender-0.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXrender-X11R7.1-0.9.1.tar.bz2;
      md5 = "54dbd492753409496066383a500a6e3e";
    };
    buildInputs = [pkgconfig renderproto libX11 ];
  }) // {inherit renderproto libX11 ;};
    
  libXres = (stdenv.mkDerivation {
    name = "libXres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXres-X11R7.1-1.0.1.tar.bz2;
      md5 = "60e5bc7d04f8995bd16febcd14c034ba";
    };
    buildInputs = [pkgconfig resourceproto libX11 libXext xextproto ];
  }) // {inherit resourceproto libX11 libXext xextproto ;};
    
  libXt = (stdenv.mkDerivation {
    name = "libXt-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXt-X11R7.1-1.0.2.tar.bz2;
      md5 = "a617ba32277ecffbb79be6bac49792d1";
    };
    buildInputs = [pkgconfig kbproto libSM libX11 xproto ];
  }) // {inherit kbproto libSM libX11 xproto ;};
    
  libXtst = (stdenv.mkDerivation {
    name = "libXtst-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXtst-X11R7.0-1.0.1.tar.bz2;
      md5 = "3a3a3b88b4bc2a82f0b6de8ff526cc8c";
    };
    buildInputs = [pkgconfig inputproto recordproto libX11 libXext xextproto ];
  }) // {inherit inputproto recordproto libX11 libXext xextproto ;};
    
  libXv = (stdenv.mkDerivation {
    name = "libXv-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXv-X11R7.0-1.0.1.tar.bz2;
      md5 = "9f0075619fc8d8df460be8aaa9d9ab5d";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto ];
  }) // {inherit videoproto libX11 libXext xextproto ;};
    
  libXvMC = (stdenv.mkDerivation {
    name = "libXvMC-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXvMC-X11R7.1-1.0.2.tar.bz2;
      md5 = "f5fe1d950925e5d70401570df3ca8ebb";
    };
    buildInputs = [pkgconfig videoproto libX11 libXext xextproto libXv ];
  }) // {inherit videoproto libX11 libXext xextproto libXv ;};
    
  libXxf86dga = (stdenv.mkDerivation {
    name = "libXxf86dga-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXxf86dga-X11R7.1-1.0.1.tar.bz2;
      md5 = "8350ee065737f68072c4b59bc0c66df1";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86dgaproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86dgaproto xproto ;};
    
  libXxf86misc = (stdenv.mkDerivation {
    name = "libXxf86misc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXxf86misc-X11R7.1-1.0.1.tar.bz2;
      md5 = "19ba9ff3f98d769a46525b0d8ce0d1e2";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86miscproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86miscproto xproto ;};
    
  libXxf86vm = (stdenv.mkDerivation {
    name = "libXxf86vm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libXxf86vm-X11R7.1-1.0.1.tar.bz2;
      md5 = "3a5d54d0d2321c3d61c9cd9f3e2204a3";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xf86vidmodeproto xproto ];
  }) // {inherit libX11 libXext xextproto xf86vidmodeproto xproto ;};
    
  libdmx = (stdenv.mkDerivation {
    name = "libdmx-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libdmx-X11R7.1-1.0.2.tar.bz2;
      md5 = "fbc2c1fa3ef95a69e1a816fbe81372f8";
    };
    buildInputs = [pkgconfig dmxproto libX11 libXext xextproto ];
  }) // {inherit dmxproto libX11 libXext xextproto ;};
    
  libfontenc = (stdenv.mkDerivation {
    name = "libfontenc-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libfontenc-X11R7.1-1.0.2.tar.bz2;
      md5 = "d8ca3192867c98669bd7d6a41ed26b09";
    };
    buildInputs = [pkgconfig xproto zlib ];
  }) // {inherit xproto zlib ;};
    
  liblbxutil = (stdenv.mkDerivation {
    name = "liblbxutil-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/liblbxutil-X11R7.1-1.0.1.tar.bz2;
      md5 = "6cef76df73f86482fa478ad8252d9055";
    };
    buildInputs = [pkgconfig xextproto xproto zlib ];
  }) // {inherit xextproto xproto zlib ;};
    
  liboldX = (stdenv.mkDerivation {
    name = "liboldX-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/liboldX-X11R7.0-1.0.1.tar.bz2;
      md5 = "a443a2dc15aa96a3d18340a1617d1bae";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  libxkbfile = (stdenv.mkDerivation {
    name = "libxkbfile-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libxkbfile-X11R7.1-1.0.3.tar.bz2;
      md5 = "598ce15a8b8c9da26944ab4691df6984";
    };
    buildInputs = [pkgconfig kbproto libX11 ];
  }) // {inherit kbproto libX11 ;};
    
  libxkbui = (stdenv.mkDerivation {
    name = "libxkbui-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/libxkbui-X11R7.1-1.0.2.tar.bz2;
      md5 = "e66230bc7f369e113112d1d282f7833d";
    };
    buildInputs = [pkgconfig libX11 libxkbfile libXt ];
  }) // {inherit libX11 libxkbfile libXt ;};
    
  listres = (stdenv.mkDerivation {
    name = "listres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/listres-X11R7.0-1.0.1.tar.bz2;
      md5 = "2eeb802272a7910bb8a52b308bf0d5f6";
    };
    buildInputs = [pkgconfig libXaw libX11 libXmu libXt ];
  }) // {inherit libXaw libX11 libXmu libXt ;};
    
  lndir = (stdenv.mkDerivation {
    name = "lndir-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/lndir-X11R7.0-1.0.1.tar.bz2;
      md5 = "aa3616b9795e2445c85b2c79b0f94f7b";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  luit = (stdenv.mkDerivation {
    name = "luit-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/luit-X11R7.0-1.0.1.tar.bz2;
      md5 = "30428b8ff783a0cfd61dab05a17cfaa7";
    };
    buildInputs = [pkgconfig libfontenc libX11 zlib ];
  }) // {inherit libfontenc libX11 zlib ;};
    
  makedepend = (stdenv.mkDerivation {
    name = "makedepend-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/makedepend-X11R7.0-1.0.0.tar.bz2;
      md5 = "7494c7ff65d8c31ef8db13661487b54c";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  mkcfm = (stdenv.mkDerivation {
    name = "mkcfm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/mkcfm-X11R7.0-1.0.1.tar.bz2;
      md5 = "912e6305998441c26852309403742bec";
    };
    buildInputs = [pkgconfig libfontenc libFS libX11 libXfont ];
  }) // {inherit libfontenc libFS libX11 libXfont ;};
    
  mkfontdir = (stdenv.mkDerivation {
    name = "mkfontdir-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/mkfontdir-X11R7.1-1.0.2.tar.bz2;
      md5 = "384ee10787c455c520bcf031989de6f3";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  mkfontscale = (stdenv.mkDerivation {
    name = "mkfontscale-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/mkfontscale-X11R7.0-1.0.1.tar.bz2;
      md5 = "75bbd1dc425849e415a60afd9e74d2ff";
    };
    buildInputs = [pkgconfig libfontenc freetype libX11 zlib ];
  }) // {inherit libfontenc freetype libX11 zlib ;};
    
  oclock = (stdenv.mkDerivation {
    name = "oclock-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/oclock-X11R7.0-1.0.1.tar.bz2;
      md5 = "e35af9699c49f0b77fad45a3b942c3b1";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  printproto = (stdenv.mkDerivation {
    name = "printproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/printproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "15c629a109b074d669886b1c6b7b319e";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  proxymngr = (stdenv.mkDerivation {
    name = "proxymngr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/proxymngr-X11R7.0-1.0.1.tar.bz2;
      md5 = "0d2ca6876d84302f966fd105a3b69a8e";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  randrproto = (stdenv.mkDerivation {
    name = "randrproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/randrproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "bcf36d524f6f50aa16ee8e183350f7b8";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  recordproto = (stdenv.mkDerivation {
    name = "recordproto-1.13.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/recordproto-X11R7.0-1.13.2.tar.bz2;
      md5 = "6f41a40e8cf4452f1c1725d46b08eb2e";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  renderproto = (stdenv.mkDerivation {
    name = "renderproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/renderproto-X11R7.0-0.9.2.tar.bz2;
      md5 = "a7f3be0960c92ecb6a06a1022fe957df";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  resourceproto = (stdenv.mkDerivation {
    name = "resourceproto-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/resourceproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "e13d7b0aa5c591224f073bbbd9d1b038";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  rgb = (stdenv.mkDerivation {
    name = "rgb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/rgb-X11R7.1-1.0.1.tar.bz2;
      md5 = "5b37afc6009cb754afb79847555d1aee";
    };
    buildInputs = [pkgconfig xproto ];
  }) // {inherit xproto ;};
    
  rstart = (stdenv.mkDerivation {
    name = "rstart-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/rstart-X11R7.1-1.0.2.tar.bz2;
      md5 = "5efe197e5ffc2ffb576714a8d6054f53";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scripts = (stdenv.mkDerivation {
    name = "scripts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/scripts-X11R7.0-1.0.1.tar.bz2;
      md5 = "b5b43aa53372b78f1d67c86301e3dc02";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  scrnsaverproto = (stdenv.mkDerivation {
    name = "scrnsaverproto-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/scrnsaverproto-X11R7.1-1.1.0.tar.bz2;
      md5 = "567152e8b564c220f5eefa2e8464e550";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  sessreg = (stdenv.mkDerivation {
    name = "sessreg-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/sessreg-X11R7.0-1.0.0.tar.bz2;
      md5 = "8289a5b947165449c23bdfad9af02b4c";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  setxkbmap = (stdenv.mkDerivation {
    name = "setxkbmap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/setxkbmap-X11R7.1-1.0.2.tar.bz2;
      md5 = "350180a6e4132a2b1262c7a15162c007";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  showfont = (stdenv.mkDerivation {
    name = "showfont-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/showfont-X11R7.0-1.0.1.tar.bz2;
      md5 = "334cb5133960108ac2c24ee27e16bb8e";
    };
    buildInputs = [pkgconfig libFS ];
  }) // {inherit libFS ;};
    
  smproxy = (stdenv.mkDerivation {
    name = "smproxy-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/smproxy-X11R7.1-1.0.2.tar.bz2;
      md5 = "668d00f87fe1123bb5bf0b22dec3e32e";
    };
    buildInputs = [pkgconfig libXmu libXt ];
  }) // {inherit libXmu libXt ;};
    
  trapproto = (stdenv.mkDerivation {
    name = "trapproto-3.4.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/trapproto-X11R7.0-3.4.3.tar.bz2;
      md5 = "84ab290758d2c177df5924e10bff4835";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  twm = (stdenv.mkDerivation {
    name = "twm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/twm-X11R7.0-1.0.1.tar.bz2;
      md5 = "cd525ca3ac5e29d21a61deebc1e0c376";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  utilmacros = (stdenv.mkDerivation {
    name = "util-macros-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/util-macros-X11R7.1-1.0.2.tar.bz2;
      md5 = "6ce5a6e85653afdd10c48b89b4bcc8aa";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  videoproto = (stdenv.mkDerivation {
    name = "videoproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/videoproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "de9e16a8a464531a54a36211d2f983bd";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  viewres = (stdenv.mkDerivation {
    name = "viewres-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/viewres-X11R7.0-1.0.1.tar.bz2;
      md5 = "004bf8dd4646aca86faf5aa22b0c3f2f";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  windowswmproto = (stdenv.mkDerivation {
    name = "windowswmproto-1.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/windowswmproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "ea2f71075f68371fec22eb98a6af8074";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  x11perf = (stdenv.mkDerivation {
    name = "x11perf-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/x11perf-X11R7.1-1.4.1.tar.bz2;
      md5 = "23e2b7b53125d75820fa66db905a6a74";
    };
    buildInputs = [pkgconfig libX11 libXext libXft libXmu libXrender ];
  }) // {inherit libX11 libXext libXft libXmu libXrender ;};
    
  xauth = (stdenv.mkDerivation {
    name = "xauth-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xauth-X11R7.0-1.0.1.tar.bz2;
      md5 = "ef2359ddaaea6ffaf9072fa342d6eb09";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  }) // {inherit libX11 libXau libXext libXmu ;};
    
  xbiff = (stdenv.mkDerivation {
    name = "xbiff-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xbiff-X11R7.0-1.0.1.tar.bz2;
      md5 = "c4eb71a3187586d02365a67fc1445e54";
    };
    buildInputs = [pkgconfig libXaw xbitmaps libXext ];
  }) // {inherit libXaw xbitmaps libXext ;};
    
  xbitmaps = (stdenv.mkDerivation {
    name = "xbitmaps-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xbitmaps-X11R7.0-1.0.1.tar.bz2;
      md5 = "22c6f4a17220cd6b41d9799905f8e357";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcalc = (stdenv.mkDerivation {
    name = "xcalc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcalc-X11R7.0-1.0.1.tar.bz2;
      md5 = "c1ecea85be15f746a59931e288768bdb";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xclipboard = (stdenv.mkDerivation {
    name = "xclipboard-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xclipboard-X11R7.0-1.0.1.tar.bz2;
      md5 = "a661b0f922cbdc62514bfd3e700d00fd";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xclock = (stdenv.mkDerivation {
    name = "xclock-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xclock-X11R7.1-1.0.2.tar.bz2;
      md5 = "349447c4398be41856f5cc8b67d5d6f4";
    };
    buildInputs = [pkgconfig libXaw libX11 libXft libxkbfile libXrender libXt ];
  }) // {inherit libXaw libX11 libXft libxkbfile libXrender libXt ;};
    
  xcmiscproto = (stdenv.mkDerivation {
    name = "xcmiscproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcmiscproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "77f3ba0cbef119e0230d235507a1d916";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xcmsdb = (stdenv.mkDerivation {
    name = "xcmsdb-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcmsdb-X11R7.0-1.0.1.tar.bz2;
      md5 = "1c8396ed5c416e3a6658394ff6c415ad";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xconsole = (stdenv.mkDerivation {
    name = "xconsole-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xconsole-X11R7.1-1.0.2.tar.bz2;
      md5 = "dd817a0fabe11b1b463492b37247b013";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xcursorgen = (stdenv.mkDerivation {
    name = "xcursorgen-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xcursorgen-X11R7.1-1.0.1.tar.bz2;
      md5 = "59d8d79fb950a55722c0089496fd18b1";
    };
    buildInputs = [pkgconfig libpng libX11 libXcursor ];
  }) // {inherit libpng libX11 libXcursor ;};
    
  xcursorthemes = (stdenv.mkDerivation {
    name = "xcursor-themes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcursor-themes-X11R7.0-1.0.1.tar.bz2;
      md5 = "c39afeae55a7d330297b2fec3d113634";
    };
    buildInputs = [pkgconfig libXcursor ];
  }) // {inherit libXcursor ;};
    
  xdbedizzy = (stdenv.mkDerivation {
    name = "xdbedizzy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdbedizzy-X11R7.0-1.0.1.tar.bz2;
      md5 = "ceaccde801650ffbffc1e5b0657960d2";
    };
    buildInputs = [pkgconfig libXau libXext libXp libXprintUtil ];
  }) // {inherit libXau libXext libXp libXprintUtil ;};
    
  xditview = (stdenv.mkDerivation {
    name = "xditview-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xditview-X11R7.0-1.0.1.tar.bz2;
      md5 = "21887fe4ec1965d637e82b7840650a6f";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xdm = (stdenv.mkDerivation {
    name = "xdm-1.0.4";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xdm-X11R7.1-1.0.4.tar.bz2;
      md5 = "03ca4af9bd9c96ce5240c87cad4f7157";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXdmcp libXext libXinerama libXmu libXpm libXt ];
  }) // {inherit libXaw libX11 libXau libXdmcp libXext libXinerama libXmu libXpm libXt ;};
    
  xdpyinfo = (stdenv.mkDerivation {
    name = "xdpyinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdpyinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "2b08e9ca783e3aa91d7fb84fdd716e93";
    };
    buildInputs = [pkgconfig libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ];
  }) // {inherit libdmx libX11 libXext libXi libXinerama libXp libXrender libXtst libXxf86dga libXxf86misc libXxf86vm ;};
    
  xdriinfo = (stdenv.mkDerivation {
    name = "xdriinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xdriinfo-X11R7.1-1.0.1.tar.bz2;
      md5 = "36cc576a71bca1177ce793003ed78f32";
    };
    buildInputs = [pkgconfig glproto libX11 ];
  }) // {inherit glproto libX11 ;};
    
  xedit = (stdenv.mkDerivation {
    name = "xedit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xedit-X11R7.1-1.0.2.tar.bz2;
      md5 = "591f578f37e0654cc7d1bb0923191797";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xev = (stdenv.mkDerivation {
    name = "xev-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xev-X11R7.0-1.0.1.tar.bz2;
      md5 = "5d0d3c13b03e9516eafe536e6bd756c7";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xextproto = (stdenv.mkDerivation {
    name = "xextproto-7.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xextproto-X11R7.0-7.0.2.tar.bz2;
      md5 = "c0e88fc3483d90a7fea6a399298d90ea";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xeyes = (stdenv.mkDerivation {
    name = "xeyes-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xeyes-X11R7.0-1.0.1.tar.bz2;
      md5 = "3ffafa7f222ea799bcd9fcd85c60ab98";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu libXt ];
  }) // {inherit libX11 libXext libXmu libXt ;};
    
  xf86bigfontproto = (stdenv.mkDerivation {
    name = "xf86bigfontproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86bigfontproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "5509d420a2bc898ca7d817cd8bf1b2a7";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86dga = (stdenv.mkDerivation {
    name = "xf86dga-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86dga-X11R7.0-1.0.1.tar.bz2;
      md5 = "f518fd7ebef3d9e8dbaa57e50a3e2631";
    };
    buildInputs = [pkgconfig libX11 libXaw libXmu libXt libXxf86dga ];
  }) // {inherit libX11 libXaw libXmu libXt libXxf86dga ;};
    
  xf86dgaproto = (stdenv.mkDerivation {
    name = "xf86dgaproto-2.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86dgaproto-X11R7.0-2.0.2.tar.bz2;
      md5 = "48ddcc6b764dba7e711f8e25596abdb0";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86driproto = (stdenv.mkDerivation {
    name = "xf86driproto-2.0.3";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86driproto-X11R7.0-2.0.3.tar.bz2;
      md5 = "839a70dfb8d5b02bcfc24996ab99a618";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86inputacecad = (stdenv.mkDerivation {
    name = "xf86-input-acecad-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-acecad-X11R7.1-1.1.0.tar.bz2;
      md5 = "7ed47ca8feb1fbbe305f3a6732181550";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputaiptek = (stdenv.mkDerivation {
    name = "xf86-input-aiptek-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-aiptek-X11R7.1-1.0.1.tar.bz2;
      md5 = "e4ede86a636263c02530005ba958b65b";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputcalcomp = (stdenv.mkDerivation {
    name = "xf86-input-calcomp-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-calcomp-X11R7.1-1.1.0.tar.bz2;
      md5 = "40a557a54cc8ff58cbc4dc1abd37bb18";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputcitron = (stdenv.mkDerivation {
    name = "xf86-input-citron-2.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-citron-X11R7.1-2.2.0.tar.bz2;
      md5 = "9d33544dc2beb9643cf329f5f4ab295b";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputdigitaledge = (stdenv.mkDerivation {
    name = "xf86-input-digitaledge-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-digitaledge-X11R7.1-1.1.0.tar.bz2;
      md5 = "e98d51c032e9324ab961a1353f65b6b2";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputdmc = (stdenv.mkDerivation {
    name = "xf86-input-dmc-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-dmc-X11R7.1-1.1.0.tar.bz2;
      md5 = "d26f4abbb4c14a64cb5d19676edc1a58";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputdynapro = (stdenv.mkDerivation {
    name = "xf86-input-dynapro-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-dynapro-X11R7.1-1.1.0.tar.bz2;
      md5 = "5121ef14108585c902753ae6e4b813f7";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputelo2300 = (stdenv.mkDerivation {
    name = "xf86-input-elo2300-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-elo2300-X11R7.1-1.1.0.tar.bz2;
      md5 = "7eeb9f2018aef32299c37ad2b3744b8d";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputelographics = (stdenv.mkDerivation {
    name = "xf86-input-elographics-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-elographics-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "24c33f833bb2db72a07c3d28bfc0aae9";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputevdev = (stdenv.mkDerivation {
    name = "xf86-input-evdev-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-evdev-X11R7.1-1.1.2.tar.bz2;
      md5 = "6eba3b46ff77b99c44f93d2a08cc6935";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver xproto ];
  }) // {inherit inputproto kbproto randrproto xorgserver xproto ;};
    
  xf86inputfpit = (stdenv.mkDerivation {
    name = "xf86-input-fpit-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-fpit-X11R7.1-1.1.0.tar.bz2;
      md5 = "223ef71e07b18e140ef227feef965ef2";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputhyperpen = (stdenv.mkDerivation {
    name = "xf86-input-hyperpen-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-hyperpen-X11R7.1-1.1.0.tar.bz2;
      md5 = "8f1d96c97e48c794a61d2e81dcc1d06a";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputjamstudio = (stdenv.mkDerivation {
    name = "xf86-input-jamstudio-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-jamstudio-X11R7.1-1.1.0.tar.bz2;
      md5 = "ca01cca63fa57600c1cf6b307bb9aa8c";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputjoystick = (stdenv.mkDerivation {
    name = "xf86-input-joystick-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-joystick-X11R7.1-1.1.0.tar.bz2;
      md5 = "6c702a255a1753bb10a3f219a3ac227a";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputkeyboard = (stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-keyboard-X11R7.1-1.1.0.tar.bz2;
      md5 = "d81490c79db78b0c182f0b2a37e02756";
    };
    buildInputs = [pkgconfig inputproto kbproto randrproto xorgserver ];
  }) // {inherit inputproto kbproto randrproto xorgserver ;};
    
  xf86inputmagellan = (stdenv.mkDerivation {
    name = "xf86-input-magellan-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-magellan-X11R7.1-1.1.0.tar.bz2;
      md5 = "9e4bde8bbc56e99f43164bbe79343360";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputmagictouch = (stdenv.mkDerivation {
    name = "xf86-input-magictouch-1.0.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-magictouch-X11R7.1-1.0.0.5.tar.bz2;
      md5 = "b3ed11fd57bf99ca515d72a16875cf68";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver xproto ];
  }) // {inherit inputproto randrproto xorgserver xproto ;};
    
  xf86inputmicrotouch = (stdenv.mkDerivation {
    name = "xf86-input-microtouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-microtouch-X11R7.1-1.1.0.tar.bz2;
      md5 = "cc96f2553c3c94dc963c07bc45a8ebb9";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputmouse = (stdenv.mkDerivation {
    name = "xf86-input-mouse-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-mouse-X11R7.1-1.1.0.tar.bz2;
      md5 = "e427b9a1dfbed3d4c9de2bf01008fa60";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputmutouch = (stdenv.mkDerivation {
    name = "xf86-input-mutouch-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-mutouch-X11R7.1-1.1.0.tar.bz2;
      md5 = "1f15391dc1b24cd400ccb9c370f568d0";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputpalmax = (stdenv.mkDerivation {
    name = "xf86-input-palmax-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-palmax-X11R7.1-1.1.0.tar.bz2;
      md5 = "7a1404b2ca2d84856d1e43efef69ccfe";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputpenmount = (stdenv.mkDerivation {
    name = "xf86-input-penmount-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-penmount-X11R7.1-1.1.0.tar.bz2;
      md5 = "6093b35d21ce93029b2b28d8b69a1444";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputspaceorb = (stdenv.mkDerivation {
    name = "xf86-input-spaceorb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-spaceorb-X11R7.1-1.1.0.tar.bz2;
      md5 = "62c381b6c56d41a75858c16dccd06394";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputsumma = (stdenv.mkDerivation {
    name = "xf86-input-summa-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-summa-X11R7.1-1.1.0.tar.bz2;
      md5 = "56765c5ee99f67802bca8a1134ad7fc1";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputtek4957 = (stdenv.mkDerivation {
    name = "xf86-input-tek4957-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-tek4957-X11R7.1-1.1.0.tar.bz2;
      md5 = "4b6b9d67d2a7056a417d26115612ecc7";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputur98 = (stdenv.mkDerivation {
    name = "xf86-input-ur98-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-ur98-X11R7.1-1.1.0.tar.bz2;
      md5 = "7e8288f4f75bcba1e3aaf6ef68664b38";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputvmmouse = (stdenv.mkDerivation {
    name = "xf86-input-vmmouse-12.4.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-vmmouse-X11R7.1-12.4.0.tar.bz2;
      md5 = "f253663de03e0fbb377ce085947412b1";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86inputvoid = (stdenv.mkDerivation {
    name = "xf86-input-void-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-input-void-X11R7.1-1.1.0.tar.bz2;
      md5 = "3683affae738de5ef130b6720bdfd6dd";
    };
    buildInputs = [pkgconfig inputproto randrproto xorgserver ];
  }) // {inherit inputproto randrproto xorgserver ;};
    
  xf86miscproto = (stdenv.mkDerivation {
    name = "xf86miscproto-0.9.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86miscproto-X11R7.0-0.9.2.tar.bz2;
      md5 = "1cc082d8a6da5177ede354bedbacd4ed";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86rushproto = (stdenv.mkDerivation {
    name = "xf86rushproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86rushproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "1a6b258d72c3c3baccfd695d278e847c";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xf86videoapm = (stdenv.mkDerivation {
    name = "xf86-video-apm-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-apm-X11R7.1-1.1.1.tar.bz2;
      md5 = "a5320411ba92e637ffb233e9cbb80d13";
    };
    buildInputs = [pkgconfig randrproto renderproto videoproto xextproto xorgserver ];
  }) // {inherit randrproto renderproto videoproto xextproto xorgserver ;};
    
  xf86videoark = (stdenv.mkDerivation {
    name = "xf86-video-ark-0.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-ark-X11R7.1-0.6.0.tar.bz2;
      md5 = "a5bed67815b9e650182806da301b488c";
    };
    buildInputs = [pkgconfig randrproto renderproto xextproto xorgserver ];
  }) // {inherit randrproto renderproto xextproto xorgserver ;};
    
  xf86videoast = (stdenv.mkDerivation {
    name = "xf86-video-ast-0.81.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-ast-X11R7.1-0.81.0.tar.bz2;
      md5 = "ac1595de8397efd740038994b1e9ef67";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoati = (stdenv.mkDerivation {
    name = "xf86-video-ati-6.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-ati-X11R7.1-6.6.0.tar.bz2;
      md5 = "c490366e7a663b4d05acb45713be45ee";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videochips = (stdenv.mkDerivation {
    name = "xf86-video-chips-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-chips-X11R7.1-1.1.1.tar.bz2;
      md5 = "cae9b1b131c1fc1b45ad1a9604fdeb66";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocirrus = (stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-cirrus-X11R7.1-1.1.0.tar.bz2;
      md5 = "0af3af1dc5686e1f487815b231b3dc0a";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videocyrix = (stdenv.mkDerivation {
    name = "xf86-video-cyrix-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-cyrix-X11R7.1-1.1.0.tar.bz2;
      md5 = "adb1e6346efd8dfe5dcccd47d46869cb";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videodummy = (stdenv.mkDerivation {
    name = "xf86-video-dummy-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-dummy-X11R7.1-0.2.0.tar.bz2;
      md5 = "d53836ac3d6f99920dc168fc22a09413";
    };
    buildInputs = [pkgconfig randrproto renderproto videoproto xf86dgaproto xorgserver ];
  }) // {inherit randrproto renderproto videoproto xf86dgaproto xorgserver ;};
    
  xf86videofbdev = (stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.3.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-fbdev-X11R7.1-0.3.0.tar.bz2;
      md5 = "c209e54fa8dcd3cd3342e84d261b02db";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videoglint = (stdenv.mkDerivation {
    name = "xf86-video-glint-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-glint-X11R7.1-1.1.1.tar.bz2;
      md5 = "99073dcfdfa24df68879c7b01324e91a";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xorgserver xproto ;};
    
  xf86videoi128 = (stdenv.mkDerivation {
    name = "xf86-video-i128-1.1.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-i128-X11R7.1-1.1.0.5.tar.bz2;
      md5 = "9252e33d14c8869d995bf67e445ffb4e";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi740 = (stdenv.mkDerivation {
    name = "xf86-video-i740-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-i740-X11R7.1-1.1.0.tar.bz2;
      md5 = "d20c7155266f67c588ecb5c4ada446d2";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videoi810 = (stdenv.mkDerivation {
    name = "xf86-video-i810-1.6.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-i810-X11R7.1-1.6.0.tar.bz2;
      md5 = "fe6cc3eab247c7f0a1d152de0ee0fc80";
    };
    buildInputs = [pkgconfig fontsproto glproto libdrm mesa randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto glproto libdrm mesa randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videoimstt = (stdenv.mkDerivation {
    name = "xf86-video-imstt-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-imstt-X11R7.1-1.1.0.tar.bz2;
      md5 = "4d76953e97ee760efb7627e7ac721dbf";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videomga = (stdenv.mkDerivation {
    name = "xf86-video-mga-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-mga-X11R7.1-1.4.1.tar.bz2;
      md5 = "b42cab6a2742bf90a205a991c281f4e2";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videoneomagic = (stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-neomagic-X11R7.1-1.1.1.tar.bz2;
      md5 = "7a0830940a0a8e99db1b5c1536b5d212";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonewport = (stdenv.mkDerivation {
    name = "xf86-video-newport-0.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-newport-X11R7.1-0.2.0.tar.bz2;
      md5 = "6fa1d4b5f009999284374df1aba92b10";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xorgserver xproto ;};
    
  xf86videonsc = (stdenv.mkDerivation {
    name = "xf86-video-nsc-2.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-nsc-X11R7.1-2.8.1.tar.bz2;
      md5 = "47a9691971e267073f99dbacf27f0ffc";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videonv = (stdenv.mkDerivation {
    name = "xf86-video-nv-1.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-nv-X11R7.1-1.1.1.tar.bz2;
      md5 = "b5c7144231652242ef8436ec8898138c";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videorendition = (stdenv.mkDerivation {
    name = "xf86-video-rendition-4.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-rendition-X11R7.1-4.1.0.tar.bz2;
      md5 = "6db91a9a10042424830c094ca870fe65";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videos3 = (stdenv.mkDerivation {
    name = "xf86-video-s3-0.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-s3-X11R7.1-0.4.1.tar.bz2;
      md5 = "3083c03884d44468e395d26a8d990c53";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videos3virge = (stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-s3virge-X11R7.1-1.9.1.tar.bz2;
      md5 = "a7c74570041b2dc9346bfdd6d2a1c582";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosavage = (stdenv.mkDerivation {
    name = "xf86-video-savage-2.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-savage-X11R7.1-2.1.1.tar.bz2;
      md5 = "7df6bc61424a566325e48e5eb89a21e2";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosiliconmotion = (stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.4.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-siliconmotion-X11R7.1-1.4.1.tar.bz2;
      md5 = "559b7eeeb598b38afeb1542db6b48a0a";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videosis = (stdenv.mkDerivation {
    name = "xf86-video-sis-0.9.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-sis-X11R7.1-0.9.1.tar.bz2;
      md5 = "f3ed22290e677381dd6236ef3bbfc7ac";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86dgaproto xf86driproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosisusb = (stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.8.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-sisusb-X11R7.1-0.8.1.tar.bz2;
      md5 = "11d580e2cc795b902b6f1a326962190b";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86miscproto xineramaproto xorgserver xproto ;};
    
  xf86videosunbw2 = (stdenv.mkDerivation {
    name = "xf86-video-sunbw2-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-sunbw2-X11R7.1-1.1.0.tar.bz2;
      md5 = "cae0b4709a2cc489182392094fe0bba3";
    };
    buildInputs = [pkgconfig randrproto xorgserver xproto ];
  }) // {inherit randrproto xorgserver xproto ;};
    
  xf86videosuncg14 = (stdenv.mkDerivation {
    name = "xf86-video-suncg14-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-suncg14-X11R7.1-1.1.0.tar.bz2;
      md5 = "3d95d9bf985bcf13c0d040a5136334a1";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg3 = (stdenv.mkDerivation {
    name = "xf86-video-suncg3-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-suncg3-X11R7.1-1.1.0.tar.bz2;
      md5 = "b719d82950a39e33903882c7b878415e";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuncg6 = (stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-suncg6-X11R7.1-1.1.0.tar.bz2;
      md5 = "de3773fe837b633cd7841546358a90b0";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosunffb = (stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-sunffb-X11R7.1-1.1.0.tar.bz2;
      md5 = "5bcb5b90c679a046d604d4f98d804d0d";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videosunleo = (stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-sunleo-X11R7.1-1.1.0.tar.bz2;
      md5 = "821ddc77ada3cd3efb0a2a7bc70bf825";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videosuntcx = (stdenv.mkDerivation {
    name = "xf86-video-suntcx-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-suntcx-X11R7.1-1.1.0.tar.bz2;
      md5 = "fff6932624c93d8e208422913521bb4a";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xorgserver xproto ;};
    
  xf86videotdfx = (stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-tdfx-X11R7.1-1.2.1.tar.bz2;
      md5 = "21500d264bccecde3122835bc39c7793";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ];
  }) // {inherit fontsproto libdrm randrproto renderproto videoproto xextproto xf86driproto xorgserver xproto ;};
    
  xf86videotga = (stdenv.mkDerivation {
    name = "xf86-video-tga-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-tga-X11R7.1-1.1.0.tar.bz2;
      md5 = "0a9356394373e42b96e9500b51f6c45c";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotrident = (stdenv.mkDerivation {
    name = "xf86-video-trident-1.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-trident-X11R7.1-1.2.1.tar.bz2;
      md5 = "d08a761111bbfef8d60131d0dc46d784";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86videotseng = (stdenv.mkDerivation {
    name = "xf86-video-tseng-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-tseng-X11R7.1-1.1.0.tar.bz2;
      md5 = "62d58d822fdd32e67658bb86ab4e4390";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto videoproto xextproto xorgserver xproto ;};
    
  xf86videov4l = (stdenv.mkDerivation {
    name = "xf86-video-v4l-0.1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-v4l-X11R7.1-0.1.1.tar.bz2;
      md5 = "fac76ca4a56380f0765d884e1b20a487";
    };
    buildInputs = [pkgconfig randrproto videoproto xorgserver xproto ];
  }) // {inherit randrproto videoproto xorgserver xproto ;};
    
  xf86videovesa = (stdenv.mkDerivation {
    name = "xf86-video-vesa-1.2.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-vesa-X11R7.1-1.2.0.tar.bz2;
      md5 = "16a20d6bf7ba858d511e96daaf43700c";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovga = (stdenv.mkDerivation {
    name = "xf86-video-vga-4.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-vga-X11R7.1-4.1.0.tar.bz2;
      md5 = "b08b488f1b98d9152f5416091bc85055";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovia = (stdenv.mkDerivation {
    name = "xf86-video-via-0.2.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-via-X11R7.1-0.2.1.tar.bz2;
      md5 = "f3ee13a05c62dd5298bd773dd0e5e951";
    };
    buildInputs = [pkgconfig fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ];
  }) // {inherit fontsproto libdrm randrproto renderproto libX11 xextproto xf86driproto xorgserver xproto libXvMC ;};
    
  xf86videovmware = (stdenv.mkDerivation {
    name = "xf86-video-vmware-10.13.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-vmware-X11R7.1-10.13.0.tar.bz2;
      md5 = "ee3c0f3130a68c6833084db5deb441ca";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xorgserver xproto ;};
    
  xf86videovoodoo = (stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xf86-video-voodoo-X11R7.1-1.1.0.tar.bz2;
      md5 = "0c96fac2d303dd5981de78e704d3a067";
    };
    buildInputs = [pkgconfig fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ];
  }) // {inherit fontsproto randrproto renderproto xextproto xf86dgaproto xorgserver xproto ;};
    
  xf86vidmodeproto = (stdenv.mkDerivation {
    name = "xf86vidmodeproto-2.2.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86vidmodeproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "475f19a2ffbfab9a0886791c5f89c978";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xfd = (stdenv.mkDerivation {
    name = "xfd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfd-X11R7.0-1.0.1.tar.bz2;
      md5 = "26c83a6fe245906cc05055abf877d0f2";
    };
    buildInputs = [pkgconfig fontconfig freetype libXaw libXft libXt ];
  }) // {inherit fontconfig freetype libXaw libXft libXt ;};
    
  xfindproxy = (stdenv.mkDerivation {
    name = "xfindproxy-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfindproxy-X11R7.0-1.0.1.tar.bz2;
      md5 = "5ef22b8876bb452f670e0fc425a12504";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol libXt ];
  }) // {inherit libICE libX11 xproxymanagementprotocol libXt ;};
    
  xfontsel = (stdenv.mkDerivation {
    name = "xfontsel-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfontsel-X11R7.0-1.0.1.tar.bz2;
      md5 = "d1df7b8622b7f8ebca4b2463118d7073";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xfs = (stdenv.mkDerivation {
    name = "xfs-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xfs-X11R7.1-1.0.2.tar.bz2;
      md5 = "b1650e876b19741762b654dcdb98be47";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  }) // {inherit libFS libXfont xtrans ;};
    
  xfsinfo = (stdenv.mkDerivation {
    name = "xfsinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfsinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "55ca0cfd09b1c1555d492d6961d9af46";
    };
    buildInputs = [pkgconfig libFS libX11 ];
  }) // {inherit libFS libX11 ;};
    
  xfwp = (stdenv.mkDerivation {
    name = "xfwp-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfwp-X11R7.0-1.0.1.tar.bz2;
      md5 = "e1ef3fef10d1f7fbd936794982a8f0be";
    };
    buildInputs = [pkgconfig libICE libX11 xproxymanagementprotocol ];
  }) // {inherit libICE libX11 xproxymanagementprotocol ;};
    
  xgamma = (stdenv.mkDerivation {
    name = "xgamma-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xgamma-X11R7.0-1.0.1.tar.bz2;
      md5 = "07167da3f6b21985e27174ec70f213c0";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  }) // {inherit libX11 libXxf86vm ;};
    
  xgc = (stdenv.mkDerivation {
    name = "xgc-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xgc-X11R7.0-1.0.1.tar.bz2;
      md5 = "8cd01cf558c3eed738115abcf720277d";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xhost = (stdenv.mkDerivation {
    name = "xhost-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xhost-X11R7.1-1.0.1.tar.bz2;
      md5 = "d12efb18c7e3025c5e6a6f63144c2145";
    };
    buildInputs = [pkgconfig libX11 libXau libXmu ];
  }) // {inherit libX11 libXau libXmu ;};
    
  xineramaproto = (stdenv.mkDerivation {
    name = "xineramaproto-1.1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xineramaproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "80516ad305063f4e6c6c3ccf42ea2142";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xinit = (stdenv.mkDerivation {
    name = "xinit-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xinit-X11R7.1-1.0.2.tar.bz2;
      md5 = "05ae7771d2245bf325ff30b13da92666";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xkbcomp = (stdenv.mkDerivation {
    name = "xkbcomp-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xkbcomp-X11R7.1-1.0.2.tar.bz2;
      md5 = "ed19a000dc13dae9ee45df8f26cebfc5";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbdata = (stdenv.mkDerivation {
    name = "xkbdata-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbdata-X11R7.0-1.0.1.tar.bz2;
      md5 = "1f706f92334ee65818512b3b45d7be65";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xkbevd = (stdenv.mkDerivation {
    name = "xkbevd-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xkbevd-X11R7.1-1.0.2.tar.bz2;
      md5 = "af4fb106610b4ee3e36ddfdfe213f40f";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbprint = (stdenv.mkDerivation {
    name = "xkbprint-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbprint-X11R7.0-1.0.1.tar.bz2;
      md5 = "6235c39690968d0a9a4c1b1c16c8905a";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  }) // {inherit libX11 libxkbfile ;};
    
  xkbutils = (stdenv.mkDerivation {
    name = "xkbutils-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbutils-X11R7.0-1.0.1.tar.bz2;
      md5 = "798502eca0c6c3e8c02d76fabb910532";
    };
    buildInputs = [pkgconfig libXaw libX11 libxkbfile ];
  }) // {inherit libXaw libX11 libxkbfile ;};
    
  xkill = (stdenv.mkDerivation {
    name = "xkill-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkill-X11R7.0-1.0.1.tar.bz2;
      md5 = "35f47fd58d75c1ea5f414b21a10bdbf3";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xload = (stdenv.mkDerivation {
    name = "xload-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xload-X11R7.0-1.0.1.tar.bz2;
      md5 = "11080456822146ebc0118b15f4b911d9";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xlogo = (stdenv.mkDerivation {
    name = "xlogo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlogo-X11R7.0-1.0.1.tar.bz2;
      md5 = "0314b2f5173da64957031400638fa5f8";
    };
    buildInputs = [pkgconfig libXaw libXext libXft libXp libXprintUtil libXrender libXt ];
  }) // {inherit libXaw libXext libXft libXp libXprintUtil libXrender libXt ;};
    
  xlsatoms = (stdenv.mkDerivation {
    name = "xlsatoms-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsatoms-X11R7.0-1.0.1.tar.bz2;
      md5 = "737b4d7893aa886e8e4181c94380a421";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsclients = (stdenv.mkDerivation {
    name = "xlsclients-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsclients-X11R7.0-1.0.1.tar.bz2;
      md5 = "cc0d64e90eab0b90b38355e841824588";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xlsfonts = (stdenv.mkDerivation {
    name = "xlsfonts-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsfonts-X11R7.0-1.0.1.tar.bz2;
      md5 = "e8681e5671e7f01922ce6c8f2327e602";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmag = (stdenv.mkDerivation {
    name = "xmag-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmag-X11R7.0-1.0.1.tar.bz2;
      md5 = "38ac487ac1b75be0253fe7f973947386";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xman = (stdenv.mkDerivation {
    name = "xman-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xman-X11R7.1-1.0.2.tar.bz2;
      md5 = "89761d6047acca5fb6fb69eb2633afe9";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xmessage = (stdenv.mkDerivation {
    name = "xmessage-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmessage-X11R7.0-1.0.1.tar.bz2;
      md5 = "5a17607184fd348c2b36b5499ae9d2e6";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmh = (stdenv.mkDerivation {
    name = "xmh-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmh-X11R7.0-1.0.1.tar.bz2;
      md5 = "53af2f87dc096d84f11ca6fbd6748b34";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xmodmap = (stdenv.mkDerivation {
    name = "xmodmap-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xmodmap-X11R7.1-1.0.1.tar.bz2;
      md5 = "0e11f78c00e27e775c4606c7e021cbf4";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xmore = (stdenv.mkDerivation {
    name = "xmore-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmore-X11R7.0-1.0.1.tar.bz2;
      md5 = "99a48c50d486b7c9098b4f5598782cac";
    };
    buildInputs = [pkgconfig libXaw libXp libXprintUtil libXt ];
  }) // {inherit libXaw libXp libXprintUtil libXt ;};
    
  xorgcffiles = (stdenv.mkDerivation {
    name = "xorg-cf-files-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg-cf-files-X11R7.1-1.0.2.tar.bz2;
      md5 = "073c1b4f0029249a05800900abd13077";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgdocs = (stdenv.mkDerivation {
    name = "xorg-docs-1.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg-docs-X11R7.1-1.2.tar.bz2;
      md5 = "a7c05bf0897ba99fe01af528c0831183";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xorgserver = (stdenv.mkDerivation {
    name = "xorg-server-1.1.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg-server-X11R7.1-1.1.0.tar.bz2;
      md5 = "59bc20bcade0293042edc8a99aa2c832";
    };
    buildInputs = [pkgconfig bigreqsproto compositeproto damageproto libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto inputproto liblbxutil libdrm mesa perl printproto randrproto recordproto renderproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ];
  }) // {inherit bigreqsproto compositeproto damageproto libdmx dmxproto evieext fixesproto fontcacheproto libfontenc fontsproto freetype glproto inputproto liblbxutil libdrm mesa perl printproto randrproto recordproto renderproto resourceproto scrnsaverproto trapproto videoproto libX11 libXau libXaw xcmiscproto libXdmcp libXext xextproto xf86bigfontproto xf86dgaproto xf86driproto xf86miscproto xf86vidmodeproto libXfont libXi xineramaproto libxkbfile libxkbui libXmu libXpm xproto libXrender libXres libXt xtrans libXtst libXxf86misc libXxf86vm zlib ;};
    
  xorgsgmldoctools = (stdenv.mkDerivation {
    name = "xorg-sgml-doctools-1.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg-sgml-doctools-X11R7.1-1.1.tar.bz2;
      md5 = "2b820facb5658160a08ff4d9ca906ad5";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xphelloworld = (stdenv.mkDerivation {
    name = "xphelloworld-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xphelloworld-X11R7.0-1.0.1.tar.bz2;
      md5 = "80c9a23c7efb72b9674d7af6b7346992";
    };
    buildInputs = [pkgconfig libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ];
  }) // {inherit libX11 libXaw libXp libXprintAppUtil libXprintUtil libXt ;};
    
  xplsprinters = (stdenv.mkDerivation {
    name = "xplsprinters-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xplsprinters-X11R7.0-1.0.1.tar.bz2;
      md5 = "1d0a68dada5e14ab07d7660abd4d03e3";
    };
    buildInputs = [pkgconfig libX11 libXp libXprintUtil ];
  }) // {inherit libX11 libXp libXprintUtil ;};
    
  xpr = (stdenv.mkDerivation {
    name = "xpr-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xpr-X11R7.0-1.0.1.tar.bz2;
      md5 = "487b5ab96b373acb80808758ce23eb49";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xprehashprinterlist = (stdenv.mkDerivation {
    name = "xprehashprinterlist-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xprehashprinterlist-X11R7.0-1.0.1.tar.bz2;
      md5 = "3907bce78d304dedb2a5dd6944bd2ed5";
    };
    buildInputs = [pkgconfig libX11 libXp ];
  }) // {inherit libX11 libXp ;};
    
  xprop = (stdenv.mkDerivation {
    name = "xprop-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xprop-X11R7.0-1.0.1.tar.bz2;
      md5 = "6730f0fbad6969825580de46e66b44dd";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xproto = (stdenv.mkDerivation {
    name = "xproto-7.0.5";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xproto-X11R7.1-7.0.5.tar.bz2;
      md5 = "930c4c618a6523fec1095827d8117fed";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xproxymanagementprotocol = (stdenv.mkDerivation {
    name = "xproxymanagementprotocol-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xproxymanagementprotocol-X11R7.0-1.0.2.tar.bz2;
      md5 = "977ee3fd1525418aaa8bfc55ffbf6fc9";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xrandr = (stdenv.mkDerivation {
    name = "xrandr-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xrandr-X11R7.1-1.0.2.tar.bz2;
      md5 = "e148e9ba69092127598c8d72debeae90";
    };
    buildInputs = [pkgconfig libX11 libXrandr libXrender ];
  }) // {inherit libX11 libXrandr libXrender ;};
    
  xrdb = (stdenv.mkDerivation {
    name = "xrdb-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xrdb-X11R7.1-1.0.2.tar.bz2;
      md5 = "2187897f97f0c818b27f8b8d33f31fa8";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xrefresh = (stdenv.mkDerivation {
    name = "xrefresh-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xrefresh-X11R7.1-1.0.2.tar.bz2;
      md5 = "16df4b8f3d844236dfd24efd88e8ea99";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
  xrx = (stdenv.mkDerivation {
    name = "xrx-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xrx-X11R7.0-1.0.1.tar.bz2;
      md5 = "9de3b04392c98df59c79a34fd51c385f";
    };
    buildInputs = [pkgconfig libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ];
  }) // {inherit libXaw libX11 libXau libXext xproxymanagementprotocol libXt xtrans ;};
    
  xset = (stdenv.mkDerivation {
    name = "xset-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xset-X11R7.1-1.0.2.tar.bz2;
      md5 = "ba1e928daa7146e44e3c55db323884f4";
    };
    buildInputs = [pkgconfig libX11 libXext libXfontcache libXmu libXp libXxf86misc ];
  }) // {inherit libX11 libXext libXfontcache libXmu libXp libXxf86misc ;};
    
  xsetmode = (stdenv.mkDerivation {
    name = "xsetmode-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetmode-X11R7.0-1.0.0.tar.bz2;
      md5 = "d83d6ef0b73762feab724aab95d9a4a2";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetpointer = (stdenv.mkDerivation {
    name = "xsetpointer-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetpointer-X11R7.0-1.0.0.tar.bz2;
      md5 = "195614431e2431508e07a42a3b6d4568";
    };
    buildInputs = [pkgconfig libX11 libXi ];
  }) // {inherit libX11 libXi ;};
    
  xsetroot = (stdenv.mkDerivation {
    name = "xsetroot-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetroot-X11R7.0-1.0.1.tar.bz2;
      md5 = "e2831b39cd395d6f6f4824b0e25f55ed";
    };
    buildInputs = [pkgconfig libX11 xbitmaps libXmu ];
  }) // {inherit libX11 xbitmaps libXmu ;};
    
  xsm = (stdenv.mkDerivation {
    name = "xsm-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsm-X11R7.0-1.0.1.tar.bz2;
      md5 = "e3588272ce3b7dc21d42ead683135a8a";
    };
    buildInputs = [pkgconfig libXaw libXt ];
  }) // {inherit libXaw libXt ;};
    
  xstdcmap = (stdenv.mkDerivation {
    name = "xstdcmap-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xstdcmap-X11R7.0-1.0.1.tar.bz2;
      md5 = "e276aa02d44dcacf5ac13aa0cabd404d";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xtrans = (stdenv.mkDerivation {
    name = "xtrans-1.0.0";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xtrans-X11R7.0-1.0.0.tar.bz2;
      md5 = "153642136a003871a9093c8103d6ac5a";
    };
    buildInputs = [pkgconfig ];
  }) // {inherit ;};
    
  xtrap = (stdenv.mkDerivation {
    name = "xtrap-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xtrap-X11R7.1-1.0.2.tar.bz2;
      md5 = "435778018128f2b9402252c9022b44fa";
    };
    buildInputs = [pkgconfig libX11 libXTrap ];
  }) // {inherit libX11 libXTrap ;};
    
  xvidtune = (stdenv.mkDerivation {
    name = "xvidtune-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xvidtune-X11R7.0-1.0.1.tar.bz2;
      md5 = "a12e27fb732cb115b6adc4c724c44c5d";
    };
    buildInputs = [pkgconfig libXaw libXt libXxf86vm ];
  }) // {inherit libXaw libXt libXxf86vm ;};
    
  xvinfo = (stdenv.mkDerivation {
    name = "xvinfo-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xvinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "39d79590345bed51da6df838f6490cbf";
    };
    buildInputs = [pkgconfig libX11 libXv ];
  }) // {inherit libX11 libXv ;};
    
  xwd = (stdenv.mkDerivation {
    name = "xwd-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xwd-X11R7.0-1.0.1.tar.bz2;
      md5 = "596c443465ab9ab67c59c794261d4571";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  }) // {inherit libX11 libXmu ;};
    
  xwininfo = (stdenv.mkDerivation {
    name = "xwininfo-1.0.2";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xwininfo-X11R7.1-1.0.2.tar.bz2;
      md5 = "6a80a6512b9286f15a5bc47d3a019bc9";
    };
    buildInputs = [pkgconfig libX11 libXext libXmu ];
  }) // {inherit libX11 libXext libXmu ;};
    
  xwud = (stdenv.mkDerivation {
    name = "xwud-1.0.1";
    builder = ./builder.sh;
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xwud-X11R7.0-1.0.1.tar.bz2;
      md5 = "e08d2ee04abb89a6348f47c84a1ff3ed";
    };
    buildInputs = [pkgconfig libX11 ];
  }) // {inherit libX11 ;};
    
}
