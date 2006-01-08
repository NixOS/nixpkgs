# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, expat, libdrm, libpng, zlib, perl, mesa
}:

rec {

  applewmproto = stdenv.mkDerivation {
    name = "applewmproto-1.0.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/applewmproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "2acf46c814a27c40acd3e448ed17fee3";
    };
    buildInputs = [pkgconfig ];
  };
    
  appres = stdenv.mkDerivation {
    name = "appres-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/appres-X11R7.0-1.0.0.tar.bz2;
      md5 = "3327357fc851a49e8e5dc44405e7b862";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  };
    
  bdftopcf = stdenv.mkDerivation {
    name = "bdftopcf-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/bdftopcf-X11R7.0-1.0.0.tar.bz2;
      md5 = "f43667fcf613054cae0679f5dc5a1e7a";
    };
    buildInputs = [pkgconfig libXfont ];
  };
    
  beforelight = stdenv.mkDerivation {
    name = "beforelight-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/beforelight-X11R7.0-1.0.1.tar.bz2;
      md5 = "e0326eff9d1bd4e3a1af9e615a0048b3";
    };
    buildInputs = [pkgconfig libX11 libXScrnSaver libXt libXaw ];
  };
    
  bigreqsproto = stdenv.mkDerivation {
    name = "bigreqsproto-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/bigreqsproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "ec15d17e3f04ddb5870ef7239b4ab367";
    };
    buildInputs = [pkgconfig ];
  };
    
  bitmap = stdenv.mkDerivation {
    name = "bitmap-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/bitmap-X11R7.0-1.0.1.tar.bz2;
      md5 = "bbb3df097821d3edb4d5a4b2ae731de6";
    };
    buildInputs = [pkgconfig libX11 libXmu xbitmaps libXt ];
  };
    
  compositeproto = stdenv.mkDerivation {
    name = "compositeproto-0.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/compositeproto-X11R7.0-0.2.2.tar.bz2;
      md5 = "4de13ee64fdfd409134dfee9b184e6a9";
    };
    buildInputs = [pkgconfig ];
  };
    
  damageproto = stdenv.mkDerivation {
    name = "damageproto-1.0.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/damageproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "b906344d68e09a5639deb0097bd74224";
    };
    buildInputs = [pkgconfig ];
  };
    
  dmxproto = stdenv.mkDerivation {
    name = "dmxproto-2.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/dmxproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "21c79302beb868a078490549f558cdcf";
    };
    buildInputs = [pkgconfig ];
  };
    
  editres = stdenv.mkDerivation {
    name = "editres-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/editres-X11R7.0-1.0.1.tar.bz2;
      md5 = "a9dc7f3b0cb59f08ab1e6554a5e60721";
    };
    buildInputs = [pkgconfig libX11 libXt libXmu ];
  };
    
  encodings = stdenv.mkDerivation {
    name = "encodings-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/encodings-X11R7.0-1.0.0.tar.bz2;
      md5 = "385cbd4093b610610ca54c06cbb0f497";
    };
    buildInputs = [pkgconfig ];
  };
    
  evieext = stdenv.mkDerivation {
    name = "evieext-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/evieext-X11R7.0-1.0.2.tar.bz2;
      md5 = "411c0d4f9eaa7d220a8d13edc790e3de";
    };
    buildInputs = [pkgconfig ];
  };
    
  fixesproto = stdenv.mkDerivation {
    name = "fixesproto-3.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fixesproto-X11R7.0-3.0.2.tar.bz2;
      md5 = "ff8899d2325ed8a5787cde372ca8f80f";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontadobe100dpi = stdenv.mkDerivation {
    name = "font-adobe-100dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "f5de34fa63976de9263f032453348f6c";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontadobe75dpi = stdenv.mkDerivation {
    name = "font-adobe-75dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "361fc4c9da3c34c5105df4f4688029d0";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontadobeutopia100dpi = stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-100dpi-X11R7.0-1.0.1.tar.bz2;
      md5 = "b720eed8eba0e4c5bcb9fdf6c2003355";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontadobeutopia75dpi = stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-75dpi-X11R7.0-1.0.1.tar.bz2;
      md5 = "a6d5d355b92a7e640698c934b0b79b53";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontadobeutopiatype1 = stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-adobe-utopia-type1-X11R7.0-1.0.1.tar.bz2;
      md5 = "db1cc2f707cffd08a461f093b55ced5e";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontalias = stdenv.mkDerivation {
    name = "font-alias-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-alias-X11R7.0-1.0.1.tar.bz2;
      md5 = "de7035b15ba7edc36f8685ab3c17a9cf";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontarabicmisc = stdenv.mkDerivation {
    name = "font-arabic-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-arabic-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "b95dc750ddc7d511e1f570034d9e1b27";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbh100dpi = stdenv.mkDerivation {
    name = "font-bh-100dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "29eeed0ad42653f27b929119581deb3e";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontbh75dpi = stdenv.mkDerivation {
    name = "font-bh-75dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "7546c97560eb325400365adbc426308b";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontbhlucidatypewriter100dpi = stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-lucidatypewriter-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "8a56f4cbea74f4dbbf9bdac95686dca8";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontbhlucidatypewriter75dpi = stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-lucidatypewriter-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "e5cccf93f4f1f793cd32adfa81cc1b40";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontbhttf = stdenv.mkDerivation {
    name = "font-bh-ttf-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-ttf-X11R7.0-1.0.0.tar.bz2;
      md5 = "53b984889aec3c0c2eb07f8aaa49dba9";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbhtype1 = stdenv.mkDerivation {
    name = "font-bh-type1-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bh-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "302111513d1e94303c0ec0139d5ae681";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbitstream100dpi = stdenv.mkDerivation {
    name = "font-bitstream-100dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-100dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "dc595e77074de890974726769f25e123";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbitstream75dpi = stdenv.mkDerivation {
    name = "font-bitstream-75dpi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-75dpi-X11R7.0-1.0.0.tar.bz2;
      md5 = "408515646743d14e1e2e240da4fffdc2";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbitstreamspeedo = stdenv.mkDerivation {
    name = "font-bitstream-speedo-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-speedo-X11R7.0-1.0.0.tar.bz2;
      md5 = "068c78ce48e5e6c4f25e0bba839a6b7a";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbitstreamtype1 = stdenv.mkDerivation {
    name = "font-bitstream-type1-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-bitstream-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "f4881a7e28eaeb7580d5eaf0f09239da";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontcacheproto = stdenv.mkDerivation {
    name = "fontcacheproto-0.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fontcacheproto-X11R7.0-0.1.2.tar.bz2;
      md5 = "116997d63cf6f65b75593ff5ae7afecb";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontcronyxcyrillic = stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-cronyx-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "447163fff74b57968fc5139d8b2ad988";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontcursormisc = stdenv.mkDerivation {
    name = "font-cursor-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-cursor-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "82e89de0e1b9c95f32b0fc12f5131d2c";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontdaewoomisc = stdenv.mkDerivation {
    name = "font-daewoo-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-daewoo-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "2fd7e6c8c21990ad906872efd02f3873";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontdecmisc = stdenv.mkDerivation {
    name = "font-dec-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-dec-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "7ff9aba4c65aa226bda7528294c7998c";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontibmtype1 = stdenv.mkDerivation {
    name = "font-ibm-type1-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-ibm-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "fab2c49cb0f9fcee0bc0ac77e510d4e5";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontisasmisc = stdenv.mkDerivation {
    name = "font-isas-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-isas-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "c0981507c9276c22956c7bfe932223d9";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontjismisc = stdenv.mkDerivation {
    name = "font-jis-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-jis-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "3732ca6c34d03e44c73f0c103512ef26";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmicromisc = stdenv.mkDerivation {
    name = "font-micro-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-micro-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "eb0050d73145c5b9fb6b9035305edeb6";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmisccyrillic = stdenv.mkDerivation {
    name = "font-misc-cyrillic-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "58d31311e8e51efbe16517adaf1a239d";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmiscethiopic = stdenv.mkDerivation {
    name = "font-misc-ethiopic-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-ethiopic-X11R7.0-1.0.0.tar.bz2;
      md5 = "190738980705826a27fbf4685650d3b9";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmiscmeltho = stdenv.mkDerivation {
    name = "font-misc-meltho-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-meltho-X11R7.0-1.0.0.tar.bz2;
      md5 = "8812c57220bcd139b4ba6266eafbd712";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmiscmisc = stdenv.mkDerivation {
    name = "font-misc-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-misc-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "4a5a7987183a9e1ea232c8391ae4c244";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontmuttmisc = stdenv.mkDerivation {
    name = "font-mutt-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-mutt-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "139b368edecf8185d16a33b4a7c09657";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontschumachermisc = stdenv.mkDerivation {
    name = "font-schumacher-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-schumacher-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "d51808138ef63b84363f7d82ed8bb681";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontscreencyrillic = stdenv.mkDerivation {
    name = "font-screen-cyrillic-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-screen-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "c08da585feb173e1b27c3fbf8f90ba45";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontsonymisc = stdenv.mkDerivation {
    name = "font-sony-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-sony-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "014725f97635da9e5e9b303ab796817e";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontsproto = stdenv.mkDerivation {
    name = "fontsproto-2.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fontsproto-X11R7.0-2.0.2.tar.bz2;
      md5 = "e2ca22df3a20177f060f04f15b8ce19b";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontsunmisc = stdenv.mkDerivation {
    name = "font-sun-misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-sun-misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "0259436c430034f24f3b239113c9630e";
    };
    buildInputs = [pkgconfig ];
  };
    
  fonttosfnt = stdenv.mkDerivation {
    name = "fonttosfnt-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fonttosfnt-X11R7.0-1.0.1.tar.bz2;
      md5 = "89b65e010acaa3c5d370e1cc0ea9fce9";
    };
    buildInputs = [pkgconfig xproto freetype libfontenc ];
  };
    
  fontutil = stdenv.mkDerivation {
    name = "font-util-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-util-X11R7.0-1.0.0.tar.bz2;
      md5 = "73cc445cb20a658037ad3a7ac571f525";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontwinitzkicyrillic = stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-winitzki-cyrillic-X11R7.0-1.0.0.tar.bz2;
      md5 = "6dc447609609e4e2454ad7da29873501";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontxfree86type1 = stdenv.mkDerivation {
    name = "font-xfree86-type1-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/font-xfree86-type1-X11R7.0-1.0.0.tar.bz2;
      md5 = "27a6bbf5c8bbe998ff7e8537929ccbc8";
    };
    buildInputs = [pkgconfig ];
  };
    
  fslsfonts = stdenv.mkDerivation {
    name = "fslsfonts-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fslsfonts-X11R7.0-1.0.1.tar.bz2;
      md5 = "c500b96cfec485e362204a8fc0bdfd44";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  fstobdf = stdenv.mkDerivation {
    name = "fstobdf-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/fstobdf-X11R7.0-1.0.1.tar.bz2;
      md5 = "233615dca862b64c69bc212090a22b4c";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  gccmakedep = stdenv.mkDerivation {
    name = "gccmakedep-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/gccmakedep-X11R7.0-1.0.1.tar.bz2;
      md5 = "328eea864d27b2d3a88ceb2fa66eca6d";
    };
    buildInputs = [pkgconfig ];
  };
    
  glproto = stdenv.mkDerivation {
    name = "glproto-1.4.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/glproto-X11R7.0-1.4.3.tar.bz2;
      md5 = "0ecb98487d7457f0592298fe9b8688f0";
    };
    buildInputs = [pkgconfig ];
  };
    
  iceauth = stdenv.mkDerivation {
    name = "iceauth-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/iceauth-X11R7.0-1.0.1.tar.bz2;
      md5 = "92035bd69b4c9aba47607ba0efcc8530";
    };
    buildInputs = [pkgconfig xproto libICE ];
  };
    
  ico = stdenv.mkDerivation {
    name = "ico-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/ico-X11R7.0-1.0.1.tar.bz2;
      md5 = "9c63d68a779819ba79e45d9b15d26b1f";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  imake = stdenv.mkDerivation {
    name = "imake-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/imake-X11R7.0-1.0.1.tar.bz2;
      md5 = "487b4b86b2bd0c09e6d220a85d94efae";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  inputproto = stdenv.mkDerivation {
    name = "inputproto-1.3.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/inputproto-X11R7.0-1.3.2.tar.bz2;
      md5 = "0da271f396bede5b8d09a61f6d1c4484";
    };
    buildInputs = [pkgconfig ];
  };
    
  kbproto = stdenv.mkDerivation {
    name = "kbproto-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/kbproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "403f56d717b3fefe465ddd03d9c7bc81";
    };
    buildInputs = [pkgconfig ];
  };
    
  lbxproxy = stdenv.mkDerivation {
    name = "lbxproxy-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/lbxproxy-X11R7.0-1.0.1.tar.bz2;
      md5 = "d9c05283660eae742a77dcbc0091841a";
    };
    buildInputs = [pkgconfig xtrans libXext liblbxutil libX11 libICE xproxymanagementprotocol bigreqsproto ];
  };
    
  libAppleWM = stdenv.mkDerivation {
    name = "libAppleWM-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libAppleWM-X11R7.0-1.0.0.tar.bz2;
      md5 = "8af30932ebc278835375fca34a2790f5";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto applewmproto ];
  };
    
  libFS = stdenv.mkDerivation {
    name = "libFS-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libFS-X11R7.0-1.0.0.tar.bz2;
      md5 = "12d2d89e7eb6ab0eb5823c3296f4e7a5";
    };
    buildInputs = [pkgconfig xproto fontsproto xtrans ];
  };
    
  libICE = stdenv.mkDerivation {
    name = "libICE-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libICE-X11R7.0-1.0.0.tar.bz2;
      md5 = "c778084b135311726da8dc74a16b3555";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  };
    
  libSM = stdenv.mkDerivation {
    name = "libSM-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libSM-X11R7.0-1.0.0.tar.bz2;
      md5 = "8a4eec299e8f14e26200718af7b2dcfc";
    };
    buildInputs = [pkgconfig libICE xproto xtrans ];
  };
    
  libWindowsWM = stdenv.mkDerivation {
    name = "libWindowsWM-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libWindowsWM-X11R7.0-1.0.0.tar.bz2;
      md5 = "d94f0389cd655b50e2987d5b988b82a5";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto windowswmproto ];
  };
    
  libX11 = stdenv.mkDerivation {
    name = "libX11-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libX11-X11R7.0-1.0.0.tar.bz2;
      md5 = "dcf59f148c978816ebbe3fbc5c9ef0e1";
    };
    buildInputs = [pkgconfig bigreqsproto xproto xextproto xtrans libXau xcmiscproto libXdmcp xf86bigfontproto kbproto inputproto ];
  };
    
  libXScrnSaver = stdenv.mkDerivation {
    name = "libXScrnSaver-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXScrnSaver-X11R7.0-1.0.1.tar.bz2;
      md5 = "b9deb6ac3194aeab15d8f6220481af6d";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto scrnsaverproto ];
  };
    
  libXTrap = stdenv.mkDerivation {
    name = "libXTrap-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXTrap-X11R7.0-1.0.0.tar.bz2;
      md5 = "8f2f1cc3b35f005e9030e162d89e2bdd";
    };
    buildInputs = [pkgconfig libX11 libXt trapproto libXext xextproto ];
  };
    
  libXau = stdenv.mkDerivation {
    name = "libXau-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXau-X11R7.0-1.0.0.tar.bz2;
      md5 = "51ceac78ae0eaf40ffb77b3cccc028cc";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  libXaw = stdenv.mkDerivation {
    name = "libXaw-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXaw-X11R7.0-1.0.1.tar.bz2;
      md5 = "ded3c7ed6d6ca2c5e257f60079a1a824";
    };
    buildInputs = [pkgconfig xproto libX11 libXext xextproto libXt libXmu libXpm libXp printproto libXau ];
  };
    
  libXcomposite = stdenv.mkDerivation {
    name = "libXcomposite-0.2.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXcomposite-X11R7.0-0.2.2.2.tar.bz2;
      md5 = "5773fe74d0f44b7264bd37c874efc7b1";
    };
    buildInputs = [pkgconfig compositeproto ];
  };
    
  libXcursor = stdenv.mkDerivation {
    name = "libXcursor-1.1.5.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXcursor-X11R7.0-1.1.5.2.tar.bz2;
      md5 = "048e15b725d8e081ac520e021af9a62c";
    };
    buildInputs = [pkgconfig libXrender libXfixes libX11 fixesproto ];
  };
    
  libXdamage = stdenv.mkDerivation {
    name = "libXdamage-1.0.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXdamage-X11R7.0-1.0.2.2.tar.bz2;
      md5 = "e98c6cc1075db5f6e7e6c8aef303c562";
    };
    buildInputs = [pkgconfig libX11 damageproto ];
  };
    
  libXdmcp = stdenv.mkDerivation {
    name = "libXdmcp-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXdmcp-X11R7.0-1.0.0.tar.bz2;
      md5 = "509390dc46af61e3a6d07656fc5ad0ec";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  libXevie = stdenv.mkDerivation {
    name = "libXevie-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXevie-X11R7.0-1.0.0.tar.bz2;
      md5 = "70b1787315d8d5f961edac05fef95fd6";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext evieext ];
  };
    
  libXext = stdenv.mkDerivation {
    name = "libXext-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXext-X11R7.0-1.0.0.tar.bz2;
      md5 = "9e47f574ac747446ac58ff9f6f402ceb";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXau ];
  };
    
  libXfixes = stdenv.mkDerivation {
    name = "libXfixes-3.0.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXfixes-X11R7.0-3.0.1.2.tar.bz2;
      md5 = "5a027e5959dae32b69dce42118938544";
    };
    buildInputs = [pkgconfig libX11 xproto fixesproto ];
  };
    
  libXfont = stdenv.mkDerivation {
    name = "libXfont-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXfont-X11R7.0-1.0.0.tar.bz2;
      md5 = "955c41694772c9fd214e3e206f5d2178";
    };
    buildInputs = [pkgconfig freetype fontcacheproto xproto xtrans fontsproto libfontenc ];
  };
    
  libXfontcache = stdenv.mkDerivation {
    name = "libXfontcache-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXfontcache-X11R7.0-1.0.1.tar.bz2;
      md5 = "1e3c7718ffaf4f617d3f67ada5a7601e";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto fontcacheproto ];
  };
    
  libXft = stdenv.mkDerivation {
    name = "libXft-2.1.8.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXft-X11R7.0-2.1.8.2.tar.bz2;
      md5 = "c42292b35325a9eeb24eb0f8d3a6ec52";
    };
    buildInputs = [pkgconfig libXrender freetype fontconfig ];
  };
    
  libXi = stdenv.mkDerivation {
    name = "libXi-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXi-X11R7.0-1.0.0.tar.bz2;
      md5 = "99503799b4d52ec0cac8e203341bb7b3";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext inputproto ];
  };
    
  libXinerama = stdenv.mkDerivation {
    name = "libXinerama-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXinerama-X11R7.0-1.0.1.tar.bz2;
      md5 = "1a1be870bb106193a4acc73c8c584dbc";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  };
    
  libXmu = stdenv.mkDerivation {
    name = "libXmu-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXmu-X11R7.0-1.0.0.tar.bz2;
      md5 = "df62f44da82c6780f07dc475a68dd9fa";
    };
    buildInputs = [pkgconfig libXt libXext xextproto libX11 ];
  };
    
  libXp = stdenv.mkDerivation {
    name = "libXp-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXp-X11R7.0-1.0.0.tar.bz2;
      md5 = "63c3048e06da4f6a033c5ce25217b0c3";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto libXau printproto ];
  };
    
  libXpm = stdenv.mkDerivation {
    name = "libXpm-3.5.4.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXpm-X11R7.0-3.5.4.2.tar.bz2;
      md5 = "f3b3b6e687f567bbff7688d60edc81ba";
    };
    buildInputs = [pkgconfig xproto libX11 libXt libXext xextproto ];
  };
    
  libXprintAppUtil = stdenv.mkDerivation {
    name = "libXprintAppUtil-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXprintAppUtil-X11R7.0-1.0.1.tar.bz2;
      md5 = "6d3f5d8d1f6c2c380bfc739128f41909";
    };
    buildInputs = [pkgconfig libX11 libXp libXprintUtil printproto libXau ];
  };
    
  libXprintUtil = stdenv.mkDerivation {
    name = "libXprintUtil-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXprintUtil-X11R7.0-1.0.1.tar.bz2;
      md5 = "47f1863042a53a48b40c2fb0aa55a8f7";
    };
    buildInputs = [pkgconfig libX11 libXp libXt printproto libXau ];
  };
    
  libXrandr = stdenv.mkDerivation {
    name = "libXrandr-1.1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXrandr-X11R7.0-1.1.0.2.tar.bz2;
      md5 = "e10aed44c2e1e5d9e6848a62ff2c90c7";
    };
    buildInputs = [pkgconfig libX11 randrproto libXext xextproto libXrender renderproto ];
  };
    
  libXrender = stdenv.mkDerivation {
    name = "libXrender-0.9.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXrender-X11R7.0-0.9.0.2.tar.bz2;
      md5 = "3f0fa590dd84df07568631c91fbe68ab";
    };
    buildInputs = [pkgconfig libX11 renderproto ];
  };
    
  libXres = stdenv.mkDerivation {
    name = "libXres-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXres-X11R7.0-1.0.0.tar.bz2;
      md5 = "cc5c4f130c9305e5bd973fbb7c56a254";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto resourceproto ];
  };
    
  libXt = stdenv.mkDerivation {
    name = "libXt-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXt-X11R7.0-1.0.0.tar.bz2;
      md5 = "d9c1c161f086a4d6c7510a924ee35c94";
    };
    buildInputs = [pkgconfig libSM libX11 xproto kbproto ];
  };
    
  libXtst = stdenv.mkDerivation {
    name = "libXtst-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXtst-X11R7.0-1.0.1.tar.bz2;
      md5 = "3a3a3b88b4bc2a82f0b6de8ff526cc8c";
    };
    buildInputs = [pkgconfig libX11 libXext recordproto xextproto inputproto ];
  };
    
  libXv = stdenv.mkDerivation {
    name = "libXv-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXv-X11R7.0-1.0.1.tar.bz2;
      md5 = "9f0075619fc8d8df460be8aaa9d9ab5d";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto videoproto ];
  };
    
  libXvMC = stdenv.mkDerivation {
    name = "libXvMC-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXvMC-X11R7.0-1.0.1.tar.bz2;
      md5 = "c3eb4f526f08862489355a99e3eda1bd";
    };
    buildInputs = [pkgconfig libX11 libXext libXv xextproto videoproto ];
  };
    
  libXxf86dga = stdenv.mkDerivation {
    name = "libXxf86dga-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXxf86dga-X11R7.0-1.0.0.tar.bz2;
      md5 = "d2154a588953d8db4ae6252ebc7db439";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86dgaproto ];
  };
    
  libXxf86misc = stdenv.mkDerivation {
    name = "libXxf86misc-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXxf86misc-X11R7.0-1.0.0.tar.bz2;
      md5 = "338568c9ca48b801f314c89c97327397";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86miscproto ];
  };
    
  libXxf86vm = stdenv.mkDerivation {
    name = "libXxf86vm-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libXxf86vm-X11R7.0-1.0.0.tar.bz2;
      md5 = "ed59db622581b33ec2a62e12b2f9c274";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86vidmodeproto ];
  };
    
  libdmx = stdenv.mkDerivation {
    name = "libdmx-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libdmx-X11R7.0-1.0.1.tar.bz2;
      md5 = "ae6b3c48f1349fc5dfa7d7c4b9cf4718";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto dmxproto ];
  };
    
  libfontenc = stdenv.mkDerivation {
    name = "libfontenc-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libfontenc-X11R7.0-1.0.1.tar.bz2;
      md5 = "d7971cbb2d1000737bba86a4bd70b900";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  liblbxutil = stdenv.mkDerivation {
    name = "liblbxutil-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/liblbxutil-X11R7.0-1.0.0.tar.bz2;
      md5 = "1bcffde85723f78243d1ba60e1ebaef6";
    };
    buildInputs = [pkgconfig xextproto xproto ];
  };
    
  liboldX = stdenv.mkDerivation {
    name = "liboldX-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/liboldX-X11R7.0-1.0.1.tar.bz2;
      md5 = "a443a2dc15aa96a3d18340a1617d1bae";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  libxkbfile = stdenv.mkDerivation {
    name = "libxkbfile-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libxkbfile-X11R7.0-1.0.1.tar.bz2;
      md5 = "0b1bb70a1df474c26dd83feab52e733d";
    };
    buildInputs = [pkgconfig libX11 kbproto ];
  };
    
  libxkbui = stdenv.mkDerivation {
    name = "libxkbui-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/libxkbui-X11R7.0-1.0.1.tar.bz2;
      md5 = "1992547d377b510517fc7681207eead5";
    };
    buildInputs = [pkgconfig libX11 libXt libxkbfile ];
  };
    
  listres = stdenv.mkDerivation {
    name = "listres-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/listres-X11R7.0-1.0.1.tar.bz2;
      md5 = "2eeb802272a7910bb8a52b308bf0d5f6";
    };
    buildInputs = [pkgconfig libX11 libXt libXmu ];
  };
    
  lndir = stdenv.mkDerivation {
    name = "lndir-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/lndir-X11R7.0-1.0.1.tar.bz2;
      md5 = "aa3616b9795e2445c85b2c79b0f94f7b";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  luit = stdenv.mkDerivation {
    name = "luit-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/luit-X11R7.0-1.0.1.tar.bz2;
      md5 = "30428b8ff783a0cfd61dab05a17cfaa7";
    };
    buildInputs = [pkgconfig libX11 libfontenc ];
  };
    
  makedepend = stdenv.mkDerivation {
    name = "makedepend-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/makedepend-X11R7.0-1.0.0.tar.bz2;
      md5 = "7494c7ff65d8c31ef8db13661487b54c";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  mkcfm = stdenv.mkDerivation {
    name = "mkcfm-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/mkcfm-X11R7.0-1.0.1.tar.bz2;
      md5 = "912e6305998441c26852309403742bec";
    };
    buildInputs = [pkgconfig libX11 libXfont libFS libfontenc ];
  };
    
  mkfontdir = stdenv.mkDerivation {
    name = "mkfontdir-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/mkfontdir-X11R7.0-1.0.1.tar.bz2;
      md5 = "29e6e5e8e7a29ed49abf33af192693cb";
    };
    buildInputs = [pkgconfig ];
  };
    
  mkfontscale = stdenv.mkDerivation {
    name = "mkfontscale-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/mkfontscale-X11R7.0-1.0.1.tar.bz2;
      md5 = "75bbd1dc425849e415a60afd9e74d2ff";
    };
    buildInputs = [pkgconfig libfontenc freetype libX11 ];
  };
    
  oclock = stdenv.mkDerivation {
    name = "oclock-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/oclock-X11R7.0-1.0.1.tar.bz2;
      md5 = "e35af9699c49f0b77fad45a3b942c3b1";
    };
    buildInputs = [pkgconfig libX11 libXmu libXext libXt ];
  };
    
  printproto = stdenv.mkDerivation {
    name = "printproto-1.0.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/printproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "15c629a109b074d669886b1c6b7b319e";
    };
    buildInputs = [pkgconfig ];
  };
    
  proxymngr = stdenv.mkDerivation {
    name = "proxymngr-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/proxymngr-X11R7.0-1.0.1.tar.bz2;
      md5 = "0d2ca6876d84302f966fd105a3b69a8e";
    };
    buildInputs = [pkgconfig libICE libXt libX11 xproxymanagementprotocol ];
  };
    
  randrproto = stdenv.mkDerivation {
    name = "randrproto-1.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/randrproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "bcf36d524f6f50aa16ee8e183350f7b8";
    };
    buildInputs = [pkgconfig ];
  };
    
  recordproto = stdenv.mkDerivation {
    name = "recordproto-1.13.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/recordproto-X11R7.0-1.13.2.tar.bz2;
      md5 = "6f41a40e8cf4452f1c1725d46b08eb2e";
    };
    buildInputs = [pkgconfig ];
  };
    
  renderproto = stdenv.mkDerivation {
    name = "renderproto-0.9.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/renderproto-X11R7.0-0.9.2.tar.bz2;
      md5 = "a7f3be0960c92ecb6a06a1022fe957df";
    };
    buildInputs = [pkgconfig ];
  };
    
  resourceproto = stdenv.mkDerivation {
    name = "resourceproto-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/resourceproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "e13d7b0aa5c591224f073bbbd9d1b038";
    };
    buildInputs = [pkgconfig ];
  };
    
  rgb = stdenv.mkDerivation {
    name = "rgb-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/rgb-X11R7.0-1.0.0.tar.bz2;
      md5 = "675e72f221714c3db8730daf0b50f69f";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  rstart = stdenv.mkDerivation {
    name = "rstart-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/rstart-X11R7.0-1.0.1.tar.bz2;
      md5 = "6f33a1bd8e99372b7544ddfcad456369";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  scripts = stdenv.mkDerivation {
    name = "scripts-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/scripts-X11R7.0-1.0.1.tar.bz2;
      md5 = "b5b43aa53372b78f1d67c86301e3dc02";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  scrnsaverproto = stdenv.mkDerivation {
    name = "scrnsaverproto-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/scrnsaverproto-X11R7.0-1.0.2.tar.bz2;
      md5 = "3185971597710d8843d986da3271b83f";
    };
    buildInputs = [pkgconfig ];
  };
    
  sessreg = stdenv.mkDerivation {
    name = "sessreg-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/sessreg-X11R7.0-1.0.0.tar.bz2;
      md5 = "8289a5b947165449c23bdfad9af02b4c";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  setxkbmap = stdenv.mkDerivation {
    name = "setxkbmap-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/setxkbmap-X11R7.0-1.0.1.tar.bz2;
      md5 = "28b141ab0b1c44a5e90d31ad73bd1078";
    };
    buildInputs = [pkgconfig libxkbfile libX11 ];
  };
    
  showfont = stdenv.mkDerivation {
    name = "showfont-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/showfont-X11R7.0-1.0.1.tar.bz2;
      md5 = "334cb5133960108ac2c24ee27e16bb8e";
    };
    buildInputs = [pkgconfig libFS ];
  };
    
  smproxy = stdenv.mkDerivation {
    name = "smproxy-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/smproxy-X11R7.0-1.0.1.tar.bz2;
      md5 = "60f54881b6fb27a8ba238629e4097c4d";
    };
    buildInputs = [pkgconfig libXt libXmu ];
  };
    
  trapproto = stdenv.mkDerivation {
    name = "trapproto-3.4.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/trapproto-X11R7.0-3.4.3.tar.bz2;
      md5 = "84ab290758d2c177df5924e10bff4835";
    };
    buildInputs = [pkgconfig ];
  };
    
  twm = stdenv.mkDerivation {
    name = "twm-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/twm-X11R7.0-1.0.1.tar.bz2;
      md5 = "cd525ca3ac5e29d21a61deebc1e0c376";
    };
    buildInputs = [pkgconfig libX11 libXext libXt libXmu ];
  };
    
  utilmacros = stdenv.mkDerivation {
    name = "util-macros-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/util-macros-X11R7.0-1.0.1.tar.bz2;
      md5 = "bc6be634532d4936eb753de54e1663d3";
    };
    buildInputs = [pkgconfig ];
  };
    
  videoproto = stdenv.mkDerivation {
    name = "videoproto-2.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/videoproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "de9e16a8a464531a54a36211d2f983bd";
    };
    buildInputs = [pkgconfig ];
  };
    
  viewres = stdenv.mkDerivation {
    name = "viewres-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/viewres-X11R7.0-1.0.1.tar.bz2;
      md5 = "004bf8dd4646aca86faf5aa22b0c3f2f";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  windowswmproto = stdenv.mkDerivation {
    name = "windowswmproto-1.0.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/windowswmproto-X11R7.0-1.0.3.tar.bz2;
      md5 = "ea2f71075f68371fec22eb98a6af8074";
    };
    buildInputs = [pkgconfig ];
  };
    
  x11perf = stdenv.mkDerivation {
    name = "x11perf-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/x11perf-X11R7.0-1.0.1.tar.bz2;
      md5 = "9986b20301c6a37bb144cb9733bf35a0";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xauth = stdenv.mkDerivation {
    name = "xauth-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xauth-X11R7.0-1.0.1.tar.bz2;
      md5 = "ef2359ddaaea6ffaf9072fa342d6eb09";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  };
    
  xbiff = stdenv.mkDerivation {
    name = "xbiff-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xbiff-X11R7.0-1.0.1.tar.bz2;
      md5 = "c4eb71a3187586d02365a67fc1445e54";
    };
    buildInputs = [pkgconfig xbitmaps libXext ];
  };
    
  xbitmaps = stdenv.mkDerivation {
    name = "xbitmaps-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xbitmaps-X11R7.0-1.0.1.tar.bz2;
      md5 = "22c6f4a17220cd6b41d9799905f8e357";
    };
    buildInputs = [pkgconfig ];
  };
    
  xcalc = stdenv.mkDerivation {
    name = "xcalc-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcalc-X11R7.0-1.0.1.tar.bz2;
      md5 = "c1ecea85be15f746a59931e288768bdb";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xclipboard = stdenv.mkDerivation {
    name = "xclipboard-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xclipboard-X11R7.0-1.0.1.tar.bz2;
      md5 = "a661b0f922cbdc62514bfd3e700d00fd";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xclock = stdenv.mkDerivation {
    name = "xclock-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xclock-X11R7.0-1.0.1.tar.bz2;
      md5 = "00444fed4bf5cd51624476ee11dd1fab";
    };
    buildInputs = [pkgconfig libX11 libXrender libXft libxkbfile libXt ];
  };
    
  xcmiscproto = stdenv.mkDerivation {
    name = "xcmiscproto-1.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcmiscproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "77f3ba0cbef119e0230d235507a1d916";
    };
    buildInputs = [pkgconfig ];
  };
    
  xcmsdb = stdenv.mkDerivation {
    name = "xcmsdb-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcmsdb-X11R7.0-1.0.1.tar.bz2;
      md5 = "1c8396ed5c416e3a6658394ff6c415ad";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xconsole = stdenv.mkDerivation {
    name = "xconsole-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xconsole-X11R7.0-1.0.1.tar.bz2;
      md5 = "f983b589ba9de198d90abee220a80f81";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xcursorgen = stdenv.mkDerivation {
    name = "xcursorgen-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcursorgen-X11R7.0-1.0.0.tar.bz2;
      md5 = "4d7b26dbb4442e89ec65c4147b31a5f7";
    };
    buildInputs = [pkgconfig libX11 libXcursor libpng ];
  };
    
  xcursorthemes = stdenv.mkDerivation {
    name = "xcursor-themes-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xcursor-themes-X11R7.0-1.0.1.tar.bz2;
      md5 = "c39afeae55a7d330297b2fec3d113634";
    };
    buildInputs = [pkgconfig libXcursor ];
  };
    
  xdbedizzy = stdenv.mkDerivation {
    name = "xdbedizzy-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdbedizzy-X11R7.0-1.0.1.tar.bz2;
      md5 = "ceaccde801650ffbffc1e5b0657960d2";
    };
    buildInputs = [pkgconfig libXp libXext libXprintUtil libXau ];
  };
    
  xditview = stdenv.mkDerivation {
    name = "xditview-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xditview-X11R7.0-1.0.1.tar.bz2;
      md5 = "21887fe4ec1965d637e82b7840650a6f";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xdm = stdenv.mkDerivation {
    name = "xdm-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdm-X11R7.0-1.0.1.tar.bz2;
      md5 = "9ac363721dbb8cd39aa1064b260624a6";
    };
    buildInputs = [pkgconfig libXmu libX11 libXau libXinerama libXpm libXdmcp libXt libXext ];
  };
    
  xdpyinfo = stdenv.mkDerivation {
    name = "xdpyinfo-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdpyinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "2b08e9ca783e3aa91d7fb84fdd716e93";
    };
    buildInputs = [pkgconfig libXext libX11 libXtst libXxf86vm libXxf86dga libXxf86misc libXi libXrender libXinerama libdmx libXp ];
  };
    
  xdriinfo = stdenv.mkDerivation {
    name = "xdriinfo-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xdriinfo-X11R7.0-1.0.0.tar.bz2;
      md5 = "75b8b53e29bb295f7fbae7909e0e9770";
    };
    buildInputs = [pkgconfig libX11 glproto ];
  };
    
  xedit = stdenv.mkDerivation {
    name = "xedit-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xedit-X11R7.0-1.0.1.tar.bz2;
      md5 = "19f607d033f62fb1ee5965f4236b19d4";
    };
    buildInputs = [pkgconfig libXprintUtil libXp libXt ];
  };
    
  xev = stdenv.mkDerivation {
    name = "xev-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xev-X11R7.0-1.0.1.tar.bz2;
      md5 = "5d0d3c13b03e9516eafe536e6bd756c7";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xextproto = stdenv.mkDerivation {
    name = "xextproto-7.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xextproto-X11R7.0-7.0.2.tar.bz2;
      md5 = "c0e88fc3483d90a7fea6a399298d90ea";
    };
    buildInputs = [pkgconfig ];
  };
    
  xeyes = stdenv.mkDerivation {
    name = "xeyes-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xeyes-X11R7.0-1.0.1.tar.bz2;
      md5 = "3ffafa7f222ea799bcd9fcd85c60ab98";
    };
    buildInputs = [pkgconfig libX11 libXt libXext libXmu ];
  };
    
  xf86bigfontproto = stdenv.mkDerivation {
    name = "xf86bigfontproto-1.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86bigfontproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "5509d420a2bc898ca7d817cd8bf1b2a7";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86dga = stdenv.mkDerivation {
    name = "xf86dga-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86dga-X11R7.0-1.0.1.tar.bz2;
      md5 = "f518fd7ebef3d9e8dbaa57e50a3e2631";
    };
    buildInputs = [pkgconfig libX11 libXxf86dga libXt libXaw libXmu ];
  };
    
  xf86dgaproto = stdenv.mkDerivation {
    name = "xf86dgaproto-2.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86dgaproto-X11R7.0-2.0.2.tar.bz2;
      md5 = "48ddcc6b764dba7e711f8e25596abdb0";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86driproto = stdenv.mkDerivation {
    name = "xf86driproto-2.0.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86driproto-X11R7.0-2.0.3.tar.bz2;
      md5 = "839a70dfb8d5b02bcfc24996ab99a618";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputacecad = stdenv.mkDerivation {
    name = "xf86-input-acecad-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-acecad-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "b35b1756579ebe296801622bdf063ab1";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputaiptek = stdenv.mkDerivation {
    name = "xf86-input-aiptek-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-aiptek-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "9ee5109ef33e281ce0784ad077f26cee";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputcalcomp = stdenv.mkDerivation {
    name = "xf86-input-calcomp-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-calcomp-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "f4199b5df063701462d5a8c84aadd190";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputcitron = stdenv.mkDerivation {
    name = "xf86-input-citron-2.1.1.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-citron-X11R7.0-2.1.1.5.tar.bz2;
      md5 = "62b5405d337bc055bc9345565cc0da8c";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputdigitaledge = stdenv.mkDerivation {
    name = "xf86-input-digitaledge-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-digitaledge-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "8342f3a0dcdaa1120af01dd25dabf0d7";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputdmc = stdenv.mkDerivation {
    name = "xf86-input-dmc-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-dmc-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "fdf127a2d419f7c2e02bec27273091d3";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputdynapro = stdenv.mkDerivation {
    name = "xf86-input-dynapro-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-dynapro-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "89dbb839ab4c5fca3dbc3c2805a7efb9";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputelo2300 = stdenv.mkDerivation {
    name = "xf86-input-elo2300-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-elo2300-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "6009a17f13a37bfde8b60c2fba5b0e5b";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputelographics = stdenv.mkDerivation {
    name = "xf86-input-elographics-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-elographics-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "24c33f833bb2db72a07c3d28bfc0aae9";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputevdev = stdenv.mkDerivation {
    name = "xf86-input-evdev-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-evdev-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "d982c6f185f4c75a4b65703ceed7be06";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputfpit = stdenv.mkDerivation {
    name = "xf86-input-fpit-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-fpit-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "fc0e11fefc322623914a2d819d5b6d51";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputhyperpen = stdenv.mkDerivation {
    name = "xf86-input-hyperpen-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-hyperpen-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "0c4f2a6390e3045e4c48a48b47b6332c";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputjamstudio = stdenv.mkDerivation {
    name = "xf86-input-jamstudio-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-jamstudio-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "49de35ca024be2cb785832ae37ec30d0";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputjoystick = stdenv.mkDerivation {
    name = "xf86-input-joystick-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-joystick-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "9e3ba60836f4c1d2e4cebc63a28321b4";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputkeyboard = stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-keyboard-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "8fb8a30fd9d7f152a1aef4eb8ef32b3f";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputmagellan = stdenv.mkDerivation {
    name = "xf86-input-magellan-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-magellan-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "fd7367f467dc3302604274cee59a7c7b";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputmagictouch = stdenv.mkDerivation {
    name = "xf86-input-magictouch-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-magictouch-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "a51d84792b8c0079d7c8d13eb17acf31";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputmicrotouch = stdenv.mkDerivation {
    name = "xf86-input-microtouch-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-microtouch-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "0c25e0340b6483fb2a600b0e885724a2";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputmouse = stdenv.mkDerivation {
    name = "xf86-input-mouse-1.0.3.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-mouse-X11R7.0-1.0.3.1.tar.bz2;
      md5 = "12a908e5a97b1b03e8717abf167f4f27";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputmutouch = stdenv.mkDerivation {
    name = "xf86-input-mutouch-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-mutouch-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "4758e667bfbba517df2a58d51270cfe2";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputpalmax = stdenv.mkDerivation {
    name = "xf86-input-palmax-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-palmax-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "d138024a20298304af883631d23c5338";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputpenmount = stdenv.mkDerivation {
    name = "xf86-input-penmount-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-penmount-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "065b1cf862864741aebcfefcc7c09539";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputspaceorb = stdenv.mkDerivation {
    name = "xf86-input-spaceorb-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-spaceorb-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "193ca7b1e87c3995b86f15a01b63b297";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputsumma = stdenv.mkDerivation {
    name = "xf86-input-summa-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-summa-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "61d780857e5dc139081718c075e74a01";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputtek4957 = stdenv.mkDerivation {
    name = "xf86-input-tek4957-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-tek4957-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "df633403c91a48c6a316c6a5f48e53e2";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputur98 = stdenv.mkDerivation {
    name = "xf86-input-ur98-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-ur98-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "9b1530b3dcbb77690ad0e61f60489899";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputvoid = stdenv.mkDerivation {
    name = "xf86-input-void-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-input-void-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "c7ae53dee1f3e95fa5ce9659b34d8446";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86miscproto = stdenv.mkDerivation {
    name = "xf86miscproto-0.9.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86miscproto-X11R7.0-0.9.2.tar.bz2;
      md5 = "1cc082d8a6da5177ede354bedbacd4ed";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86rushproto = stdenv.mkDerivation {
    name = "xf86rushproto-1.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86rushproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "1a6b258d72c3c3baccfd695d278e847c";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videoapm = stdenv.mkDerivation {
    name = "xf86-video-apm-1.0.1.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-apm-X11R7.0-1.0.1.5.tar.bz2;
      md5 = "323911ab16a6147d3cabceff9336a3d2";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videoark = stdenv.mkDerivation {
    name = "xf86-video-ark-0.5.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-ark-X11R7.0-0.5.0.5.tar.bz2;
      md5 = "342937e275dbc92f437417a3186a8222";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videoati = stdenv.mkDerivation {
    name = "xf86-video-ati-6.5.7.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-ati-X11R7.0-6.5.7.3.tar.bz2;
      md5 = "92525195a7a36f5ffbffcb4e6a564e50";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videochips = stdenv.mkDerivation {
    name = "xf86-video-chips-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-chips-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "90f23505faceac30d3f46ab94f7293e1";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videocirrus = stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-cirrus-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "7708693ad9d73cd76d4caef7c644a46f";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videocyrix = stdenv.mkDerivation {
    name = "xf86-video-cyrix-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-cyrix-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "14f868d16554b19fef4f30398a7b9cf1";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videodummy = stdenv.mkDerivation {
    name = "xf86-video-dummy-0.1.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-dummy-X11R7.0-0.1.0.5.tar.bz2;
      md5 = "462654f9be7e3022f97147e3390db97a";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videofbdev = stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.1.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-fbdev-X11R7.0-0.1.0.5.tar.bz2;
      md5 = "1cf374eeb9151ac16a7ec2cd38048737";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videoglint = stdenv.mkDerivation {
    name = "xf86-video-glint-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-glint-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "f14c2f1696c05760207adcaac856e5e5";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videoi128 = stdenv.mkDerivation {
    name = "xf86-video-i128-1.1.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-i128-X11R7.0-1.1.0.5.tar.bz2;
      md5 = "078eed8c3673488ee618dfc7a3ef101b";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videoi740 = stdenv.mkDerivation {
    name = "xf86-video-i740-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-i740-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "625448b13ebe2a13b7defad1efec05c4";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videoi810 = stdenv.mkDerivation {
    name = "xf86-video-i810-1.4.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-i810-X11R7.0-1.4.1.3.tar.bz2;
      md5 = "fe6bec726fc1657b537508bbe8c2005b";
    };
    buildInputs = [pkgconfig xorgserver xproto libXvMC fontsproto libdrm xf86driproto ];
  };
    
  xf86videoimstt = stdenv.mkDerivation {
    name = "xf86-video-imstt-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-imstt-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "cc949688918b78f830d78a9613e6896b";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videomga = stdenv.mkDerivation {
    name = "xf86-video-mga-1.2.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-mga-X11R7.0-1.2.1.3.tar.bz2;
      md5 = "cb0409782020b5cc7edc273624ffdd17";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videoneomagic = stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-neomagic-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "ffe9015678a41e97bdbd2825066bb47b";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videonewport = stdenv.mkDerivation {
    name = "xf86-video-newport-0.1.4.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-newport-X11R7.0-0.1.4.1.tar.bz2;
      md5 = "d74d9896d57c3caf224ba3472630d874";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videonsc = stdenv.mkDerivation {
    name = "xf86-video-nsc-2.7.6.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-nsc-X11R7.0-2.7.6.5.tar.bz2;
      md5 = "ab16611b3ec7d21503b16b0a31addae0";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videonv = stdenv.mkDerivation {
    name = "xf86-video-nv-1.0.1.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-nv-X11R7.0-1.0.1.5.tar.bz2;
      md5 = "9a88547fe550e20edcc5a938d31e22b1";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videorendition = stdenv.mkDerivation {
    name = "xf86-video-rendition-4.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-rendition-X11R7.0-4.0.1.3.tar.bz2;
      md5 = "f1a25db74a148dea45115e813027b932";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videos3 = stdenv.mkDerivation {
    name = "xf86-video-s3-0.3.5.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-s3-X11R7.0-0.3.5.5.tar.bz2;
      md5 = "83b9e8a9b8fc1c49bda2811358e5007c";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videos3virge = stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.8.6.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-s3virge-X11R7.0-1.8.6.5.tar.bz2;
      md5 = "d0164c37749ab5f565db9813487e1900";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosavage = stdenv.mkDerivation {
    name = "xf86-video-savage-2.0.2.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-savage-X11R7.0-2.0.2.3.tar.bz2;
      md5 = "6b638dd500d10dba1822d3ea5061fc65";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videosiliconmotion = stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.3.1.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-siliconmotion-X11R7.0-1.3.1.5.tar.bz2;
      md5 = "957de4e2a3c687dbb2e9e18582397804";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosis = stdenv.mkDerivation {
    name = "xf86-video-sis-0.8.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-sis-X11R7.0-0.8.1.3.tar.bz2;
      md5 = "e3bac5a208b8bacfbec236b5a5b0ef40";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto xf86dgaproto libdrm xf86driproto ];
  };
    
  xf86videosisusb = stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.7.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-sisusb-X11R7.0-0.7.1.3.tar.bz2;
      md5 = "781d726a0ca54b65521e383ab99043c8";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosunbw2 = stdenv.mkDerivation {
    name = "xf86-video-sunbw2-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-sunbw2-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "0cdda1ab939ea1190c142aa8aabfaf83";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videosuncg14 = stdenv.mkDerivation {
    name = "xf86-video-suncg14-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-suncg14-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "8f3a734d02ae716415f9c6344fa661bd";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosuncg3 = stdenv.mkDerivation {
    name = "xf86-video-suncg3-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-suncg3-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "799a54cef1f4435e00fa94a1d97d056f";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosuncg6 = stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-suncg6-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "2227f3fb86b02148f347e002662e53c8";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosunffb = stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-sunffb-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "bb5182e3b74b3baa6fee245ac8bbf09a";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videosunleo = stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-sunleo-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "deb17a74ba68ee9593ac774206bd3612";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videosuntcx = stdenv.mkDerivation {
    name = "xf86-video-suntcx-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-suntcx-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "74d6ba5e55afdfebff84db08b6589e26";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videotdfx = stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.1.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-tdfx-X11R7.0-1.1.1.3.tar.bz2;
      md5 = "0201415230bf0454384c3bad099520d2";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto libdrm xf86driproto ];
  };
    
  xf86videotga = stdenv.mkDerivation {
    name = "xf86-video-tga-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-tga-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "fa67bf34454888d38e15708395cfed87";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videotrident = stdenv.mkDerivation {
    name = "xf86-video-trident-1.0.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-trident-X11R7.0-1.0.1.2.tar.bz2;
      md5 = "69f28afc7b585d01bb06b1e2f872f8ea";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videotseng = stdenv.mkDerivation {
    name = "xf86-video-tseng-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-tseng-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "981f46914c1e54742418f0444ea2e092";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videov4l = stdenv.mkDerivation {
    name = "xf86-video-v4l-0.0.1.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-v4l-X11R7.0-0.0.1.5.tar.bz2;
      md5 = "e422c63bc83717ecd0686aef2036802b";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videovesa = stdenv.mkDerivation {
    name = "xf86-video-vesa-1.0.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-vesa-X11R7.0-1.0.1.3.tar.bz2;
      md5 = "049ada4df1abb5aa2b6633ba90353e78";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videovga = stdenv.mkDerivation {
    name = "xf86-video-vga-4.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-vga-X11R7.0-4.0.0.5.tar.bz2;
      md5 = "24437857707acc337cab331cc56f64e2";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videovia = stdenv.mkDerivation {
    name = "xf86-video-via-0.1.33.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-via-X11R7.0-0.1.33.2.tar.bz2;
      md5 = "4d3268d226a40f580ab105796bfed1f5";
    };
    buildInputs = [pkgconfig xorgserver xproto libXvMC fontsproto libdrm xf86driproto ];
  };
    
  xf86videovmware = stdenv.mkDerivation {
    name = "xf86-video-vmware-10.11.1.3";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-vmware-X11R7.0-10.11.1.3.tar.bz2;
      md5 = "4df79349e26add4c23f6be8bec347ad4";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto ];
  };
    
  xf86videovoodoo = stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.0.0.5";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86-video-voodoo-X11R7.0-1.0.0.5.tar.bz2;
      md5 = "e00cc814ebdb3f3067e075bc93b26199";
    };
    buildInputs = [pkgconfig xorgserver xproto fontsproto xf86dgaproto ];
  };
    
  xf86vidmodeproto = stdenv.mkDerivation {
    name = "xf86vidmodeproto-2.2.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xf86vidmodeproto-X11R7.0-2.2.2.tar.bz2;
      md5 = "475f19a2ffbfab9a0886791c5f89c978";
    };
    buildInputs = [pkgconfig ];
  };
    
  xfd = stdenv.mkDerivation {
    name = "xfd-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfd-X11R7.0-1.0.1.tar.bz2;
      md5 = "26c83a6fe245906cc05055abf877d0f2";
    };
    buildInputs = [pkgconfig freetype fontconfig libXft libXt ];
  };
    
  xfindproxy = stdenv.mkDerivation {
    name = "xfindproxy-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfindproxy-X11R7.0-1.0.1.tar.bz2;
      md5 = "5ef22b8876bb452f670e0fc425a12504";
    };
    buildInputs = [pkgconfig libX11 libICE libXt xproxymanagementprotocol ];
  };
    
  xfontsel = stdenv.mkDerivation {
    name = "xfontsel-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfontsel-X11R7.0-1.0.1.tar.bz2;
      md5 = "d1df7b8622b7f8ebca4b2463118d7073";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xfs = stdenv.mkDerivation {
    name = "xfs-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfs-X11R7.0-1.0.1.tar.bz2;
      md5 = "a297da3d906110e9c29ec56c5ea578a8";
    };
    buildInputs = [pkgconfig libFS libXfont xtrans ];
  };
    
  xfsinfo = stdenv.mkDerivation {
    name = "xfsinfo-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfsinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "55ca0cfd09b1c1555d492d6961d9af46";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  xfwp = stdenv.mkDerivation {
    name = "xfwp-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xfwp-X11R7.0-1.0.1.tar.bz2;
      md5 = "e1ef3fef10d1f7fbd936794982a8f0be";
    };
    buildInputs = [pkgconfig libX11 libICE xproxymanagementprotocol ];
  };
    
  xgamma = stdenv.mkDerivation {
    name = "xgamma-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xgamma-X11R7.0-1.0.1.tar.bz2;
      md5 = "07167da3f6b21985e27174ec70f213c0";
    };
    buildInputs = [pkgconfig libX11 libXxf86vm ];
  };
    
  xgc = stdenv.mkDerivation {
    name = "xgc-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xgc-X11R7.0-1.0.1.tar.bz2;
      md5 = "8cd01cf558c3eed738115abcf720277d";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xhost = stdenv.mkDerivation {
    name = "xhost-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xhost-X11R7.0-1.0.0.tar.bz2;
      md5 = "76c44e84aaf4ad8e97cf15f4dbe4a24a";
    };
    buildInputs = [pkgconfig libX11 libXmu libXau ];
  };
    
  xineramaproto = stdenv.mkDerivation {
    name = "xineramaproto-1.1.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xineramaproto-X11R7.0-1.1.2.tar.bz2;
      md5 = "80516ad305063f4e6c6c3ccf42ea2142";
    };
    buildInputs = [pkgconfig ];
  };
    
  xinit = stdenv.mkDerivation {
    name = "xinit-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xinit-X11R7.0-1.0.1.tar.bz2;
      md5 = "6d2df59fa328cbc99c0de98bc2e14597";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xkbcomp = stdenv.mkDerivation {
    name = "xkbcomp-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbcomp-X11R7.0-1.0.1.tar.bz2;
      md5 = "46d1e015897200d4dfed64990abaa8b9";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  };
    
  xkbdata = stdenv.mkDerivation {
    name = "xkbdata-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbdata-X11R7.0-1.0.1.tar.bz2;
      md5 = "1f706f92334ee65818512b3b45d7be65";
    };
    buildInputs = [pkgconfig ];
  };
    
  xkbevd = stdenv.mkDerivation {
    name = "xkbevd-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbevd-X11R7.0-1.0.1.tar.bz2;
      md5 = "7ba0496f079552d1918d73bd09bde9b2";
    };
    buildInputs = [pkgconfig libxkbfile libX11 ];
  };
    
  xkbprint = stdenv.mkDerivation {
    name = "xkbprint-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbprint-X11R7.0-1.0.1.tar.bz2;
      md5 = "6235c39690968d0a9a4c1b1c16c8905a";
    };
    buildInputs = [pkgconfig libxkbfile libX11 ];
  };
    
  xkbutils = stdenv.mkDerivation {
    name = "xkbutils-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkbutils-X11R7.0-1.0.1.tar.bz2;
      md5 = "798502eca0c6c3e8c02d76fabb910532";
    };
    buildInputs = [pkgconfig libxkbfile libX11 ];
  };
    
  xkill = stdenv.mkDerivation {
    name = "xkill-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xkill-X11R7.0-1.0.1.tar.bz2;
      md5 = "35f47fd58d75c1ea5f414b21a10bdbf3";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xload = stdenv.mkDerivation {
    name = "xload-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xload-X11R7.0-1.0.1.tar.bz2;
      md5 = "11080456822146ebc0118b15f4b911d9";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xlogo = stdenv.mkDerivation {
    name = "xlogo-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlogo-X11R7.0-1.0.1.tar.bz2;
      md5 = "0314b2f5173da64957031400638fa5f8";
    };
    buildInputs = [pkgconfig libXprintUtil libXp libXrender libXft libXext libXt ];
  };
    
  xlsatoms = stdenv.mkDerivation {
    name = "xlsatoms-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsatoms-X11R7.0-1.0.1.tar.bz2;
      md5 = "737b4d7893aa886e8e4181c94380a421";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xlsclients = stdenv.mkDerivation {
    name = "xlsclients-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsclients-X11R7.0-1.0.1.tar.bz2;
      md5 = "cc0d64e90eab0b90b38355e841824588";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xlsfonts = stdenv.mkDerivation {
    name = "xlsfonts-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xlsfonts-X11R7.0-1.0.1.tar.bz2;
      md5 = "e8681e5671e7f01922ce6c8f2327e602";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xmag = stdenv.mkDerivation {
    name = "xmag-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmag-X11R7.0-1.0.1.tar.bz2;
      md5 = "38ac487ac1b75be0253fe7f973947386";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xman = stdenv.mkDerivation {
    name = "xman-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xman-X11R7.0-1.0.1.tar.bz2;
      md5 = "a4f21547120952aeb8e5663ebd72e843";
    };
    buildInputs = [pkgconfig libXprintUtil libXp libXt ];
  };
    
  xmessage = stdenv.mkDerivation {
    name = "xmessage-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmessage-X11R7.0-1.0.1.tar.bz2;
      md5 = "5a17607184fd348c2b36b5499ae9d2e6";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xmh = stdenv.mkDerivation {
    name = "xmh-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmh-X11R7.0-1.0.1.tar.bz2;
      md5 = "53af2f87dc096d84f11ca6fbd6748b34";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xmodmap = stdenv.mkDerivation {
    name = "xmodmap-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmodmap-X11R7.0-1.0.0.tar.bz2;
      md5 = "240ed53111925e005d2f138ea98ef5e1";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xmore = stdenv.mkDerivation {
    name = "xmore-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xmore-X11R7.0-1.0.1.tar.bz2;
      md5 = "99a48c50d486b7c9098b4f5598782cac";
    };
    buildInputs = [pkgconfig libXprintUtil libXp libXt ];
  };
    
  xorgcffiles = stdenv.mkDerivation {
    name = "xorg-cf-files-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xorg-cf-files-X11R7.0-1.0.1.tar.bz2;
      md5 = "f2dd453c37386293fb207431b4a073dd";
    };
    buildInputs = [pkgconfig ];
  };
    
  xorgdocs = stdenv.mkDerivation {
    name = "xorg-docs-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xorg-docs-X11R7.0-1.0.1.tar.bz2;
      md5 = "ac0d76afa46ef5da9e1cf33558f4b303";
    };
    buildInputs = [pkgconfig ];
  };
    
  xorgserver = stdenv.mkDerivation {
    name = "xorg-server-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xorg-server-X11R7.0-1.0.1.tar.bz2;
      md5 = "0e7527480fb845a3c2e333bd0f47ff50";
    };
    buildInputs = [pkgconfig randrproto renderproto fixesproto damageproto xcmiscproto xextproto xproto xtrans xf86miscproto xf86vidmodeproto xf86bigfontproto scrnsaverproto bigreqsproto resourceproto fontsproto inputproto xf86dgaproto libXfont libXau libfontenc videoproto compositeproto trapproto recordproto libX11 liblbxutil xf86driproto libdrm glproto xineramaproto evieext fontcacheproto printproto libxkbfile libXdmcp libXmu libXext libXrender libXi dmxproto libXaw libXmu libXt libXpm libdmx libXtst libXres ];
  };
    
  xorgsgmldoctools = stdenv.mkDerivation {
    name = "xorg-sgml-doctools-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xorg-sgml-doctools-X11R7.0-1.0.1.tar.bz2;
      md5 = "d08d4fd10ac46d8b4636efe4d8c0de74";
    };
    buildInputs = [pkgconfig ];
  };
    
  xphelloworld = stdenv.mkDerivation {
    name = "xphelloworld-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xphelloworld-X11R7.0-1.0.1.tar.bz2;
      md5 = "80c9a23c7efb72b9674d7af6b7346992";
    };
    buildInputs = [pkgconfig libX11 libXaw libXprintUtil libXp libXprintAppUtil libXt ];
  };
    
  xplsprinters = stdenv.mkDerivation {
    name = "xplsprinters-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xplsprinters-X11R7.0-1.0.1.tar.bz2;
      md5 = "1d0a68dada5e14ab07d7660abd4d03e3";
    };
    buildInputs = [pkgconfig libXp libXprintUtil libX11 ];
  };
    
  xpr = stdenv.mkDerivation {
    name = "xpr-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xpr-X11R7.0-1.0.1.tar.bz2;
      md5 = "487b5ab96b373acb80808758ce23eb49";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xprehashprinterlist = stdenv.mkDerivation {
    name = "xprehashprinterlist-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xprehashprinterlist-X11R7.0-1.0.1.tar.bz2;
      md5 = "3907bce78d304dedb2a5dd6944bd2ed5";
    };
    buildInputs = [pkgconfig libXp libX11 ];
  };
    
  xprop = stdenv.mkDerivation {
    name = "xprop-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xprop-X11R7.0-1.0.1.tar.bz2;
      md5 = "6730f0fbad6969825580de46e66b44dd";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xproto = stdenv.mkDerivation {
    name = "xproto-7.0.4";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xproto-X11R7.0-7.0.4.tar.bz2;
      md5 = "643259d00e02db8e9a6f4c047281b5d9";
    };
    buildInputs = [pkgconfig ];
  };
    
  xproxymanagementprotocol = stdenv.mkDerivation {
    name = "xproxymanagementprotocol-1.0.2";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xproxymanagementprotocol-X11R7.0-1.0.2.tar.bz2;
      md5 = "977ee3fd1525418aaa8bfc55ffbf6fc9";
    };
    buildInputs = [pkgconfig ];
  };
    
  xrandr = stdenv.mkDerivation {
    name = "xrandr-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xrandr-X11R7.0-1.0.1.tar.bz2;
      md5 = "e433ccca3c4f9ab8609dfd1c9c8e36ea";
    };
    buildInputs = [pkgconfig libXrandr libXrender libX11 ];
  };
    
  xrdb = stdenv.mkDerivation {
    name = "xrdb-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xrdb-X11R7.0-1.0.1.tar.bz2;
      md5 = "a3c1fd6f5391de7f810239a912d39fa5";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xrefresh = stdenv.mkDerivation {
    name = "xrefresh-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xrefresh-X11R7.0-1.0.1.tar.bz2;
      md5 = "5a46d5fb82aeeb4d6aac58c9cc367439";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xrx = stdenv.mkDerivation {
    name = "xrx-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xrx-X11R7.0-1.0.1.tar.bz2;
      md5 = "9de3b04392c98df59c79a34fd51c385f";
    };
    buildInputs = [pkgconfig libX11 libXt libXext xtrans xproxymanagementprotocol libXau ];
  };
    
  xset = stdenv.mkDerivation {
    name = "xset-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xset-X11R7.0-1.0.1.tar.bz2;
      md5 = "a0350e334a215829166266e2ce504b1c";
    };
    buildInputs = [pkgconfig libXmu libX11 libXext libXxf86misc libXfontcache libXp ];
  };
    
  xsetmode = stdenv.mkDerivation {
    name = "xsetmode-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetmode-X11R7.0-1.0.0.tar.bz2;
      md5 = "d83d6ef0b73762feab724aab95d9a4a2";
    };
    buildInputs = [pkgconfig libXi libX11 ];
  };
    
  xsetpointer = stdenv.mkDerivation {
    name = "xsetpointer-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetpointer-X11R7.0-1.0.0.tar.bz2;
      md5 = "195614431e2431508e07a42a3b6d4568";
    };
    buildInputs = [pkgconfig libXi libX11 ];
  };
    
  xsetroot = stdenv.mkDerivation {
    name = "xsetroot-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsetroot-X11R7.0-1.0.1.tar.bz2;
      md5 = "e2831b39cd395d6f6f4824b0e25f55ed";
    };
    buildInputs = [pkgconfig libXmu libX11 xbitmaps ];
  };
    
  xsm = stdenv.mkDerivation {
    name = "xsm-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xsm-X11R7.0-1.0.1.tar.bz2;
      md5 = "e3588272ce3b7dc21d42ead683135a8a";
    };
    buildInputs = [pkgconfig libXt ];
  };
    
  xstdcmap = stdenv.mkDerivation {
    name = "xstdcmap-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xstdcmap-X11R7.0-1.0.1.tar.bz2;
      md5 = "e276aa02d44dcacf5ac13aa0cabd404d";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xtrans = stdenv.mkDerivation {
    name = "xtrans-1.0.0";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xtrans-X11R7.0-1.0.0.tar.bz2;
      md5 = "153642136a003871a9093c8103d6ac5a";
    };
    buildInputs = [pkgconfig ];
  };
    
  xtrap = stdenv.mkDerivation {
    name = "xtrap-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xtrap-X11R7.0-1.0.1.tar.bz2;
      md5 = "6d56946322d2875eb33f25f5e5f621a3";
    };
    buildInputs = [pkgconfig libX11 libXTrap ];
  };
    
  xvidtune = stdenv.mkDerivation {
    name = "xvidtune-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xvidtune-X11R7.0-1.0.1.tar.bz2;
      md5 = "a12e27fb732cb115b6adc4c724c44c5d";
    };
    buildInputs = [pkgconfig libXxf86vm libXt ];
  };
    
  xvinfo = stdenv.mkDerivation {
    name = "xvinfo-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xvinfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "39d79590345bed51da6df838f6490cbf";
    };
    buildInputs = [pkgconfig libXv libX11 ];
  };
    
  xwd = stdenv.mkDerivation {
    name = "xwd-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xwd-X11R7.0-1.0.1.tar.bz2;
      md5 = "596c443465ab9ab67c59c794261d4571";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xwininfo = stdenv.mkDerivation {
    name = "xwininfo-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xwininfo-X11R7.0-1.0.1.tar.bz2;
      md5 = "3ec67e4e1b9f5a1fe7e56b56ab931893";
    };
    buildInputs = [pkgconfig libXmu libXext libX11 ];
  };
    
  xwud = stdenv.mkDerivation {
    name = "xwud-1.0.1";
    src = fetchurl {
      url = http://mirror.switch.ch/ftp/mirror/X11/pub/X11R7.0/src/everything/xwud-X11R7.0-1.0.1.tar.bz2;
      md5 = "e08d2ee04abb89a6348f47c84a1ff3ed";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
}
