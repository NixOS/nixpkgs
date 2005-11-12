# This is a generated file.  Do not edit!
{ stdenv, fetchurl, pkgconfig, freetype, fontconfig
, expat, libdrm, libpng
, zlib, perl, mesa
}:

rec {

  xf86bigfontproto = stdenv.mkDerivation {
    name = "xf86bigfontproto-1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86bigfontproto-1.1.1.tar.bz2;
      md5 = "2094b427cfeb7b4efd24709ead752202";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputfpit = stdenv.mkDerivation {
    name = "xf86-input-fpit-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-fpit-1.0.0.1.tar.bz2;
      md5 = "06e99b7891a7217dfba60a24841a756d";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontadobe75dpi = stdenv.mkDerivation {
    name = "font-adobe-75dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-adobe-75dpi-0.99.1.tar.bz2;
      md5 = "15812ce5711317909351ab1612287e4e";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  xf86videosavage = stdenv.mkDerivation {
    name = "xf86-video-savage-2.0.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-savage-2.0.1.1.tar.bz2;
      md5 = "3ec4c313056367919d6164ec5e2f5b02";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  compositeproto = stdenv.mkDerivation {
    name = "compositeproto-0.2.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/compositeproto-0.2.1.tar.bz2;
      md5 = "d3f305df7a840335c37884b0b27653db";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videosunleo = stdenv.mkDerivation {
    name = "xf86-video-sunleo-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-sunleo-1.0.0.1.tar.bz2;
      md5 = "31432370c6bef5fb650ffb3435892321";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  scripts = stdenv.mkDerivation {
    name = "scripts-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/scripts-0.99.1.tar.bz2;
      md5 = "f93f3c3d91313e60e6ce94462a0efde9";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  bigreqsproto = stdenv.mkDerivation {
    name = "bigreqsproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/bigreqsproto-1.0.1.tar.bz2;
      md5 = "8c95cefe2fa6723f96670123c1bc8bba";
    };
    buildInputs = [pkgconfig ];
  };
    
  xwd = stdenv.mkDerivation {
    name = "xwd-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xwd-0.99.1.tar.bz2;
      md5 = "28ee7e7e9cf3f3f5d57415fffd91dbb9";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  fontbitstream100dpi = stdenv.mkDerivation {
    name = "font-bitstream-100dpi-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bitstream-100dpi-0.99.0.tar.bz2;
      md5 = "4fd1dbb3e62481f3ffd1e826ffb00267";
    };
    buildInputs = [pkgconfig ];
  };
    
  xsetpointer = stdenv.mkDerivation {
    name = "xsetpointer-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xsetpointer-0.99.1.tar.bz2;
      md5 = "ef37cb3b6d8554caeb7e1f02ecaf3434";
    };
    buildInputs = [pkgconfig libXi libX11 ];
  };
    
  libXdmcp = stdenv.mkDerivation {
    name = "libXdmcp-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXdmcp-0.99.1.tar.bz2;
      md5 = "616a9f01d5204d372922a14c3a209fa6";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  libXprintUtil = stdenv.mkDerivation {
    name = "libXprintUtil-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXprintUtil-0.99.1.tar.bz2;
      md5 = "de33d1024133b1d3b2afc33c5e9bdf47";
    };
    buildInputs = [pkgconfig libX11 libXp libXt ];
  };
    
  smproxy = stdenv.mkDerivation {
    name = "smproxy-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/smproxy-0.99.1.tar.bz2;
      md5 = "251b41f4582c2b55532ec48e47d1a3f5";
    };
    buildInputs = [pkgconfig libXt libXmu ];
  };
    
  fslsfonts = stdenv.mkDerivation {
    name = "fslsfonts-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fslsfonts-0.99.1.tar.bz2;
      md5 = "316737ee49fb85ba7e0ce8955bcd7da5";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  xf86videov4l = stdenv.mkDerivation {
    name = "xf86-video-v4l-0.0.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-v4l-0.0.1.1.tar.bz2;
      md5 = "30c7e6bebf3ae5ba9f3dfadd5dbc3338";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputcalcomp = stdenv.mkDerivation {
    name = "xf86-input-calcomp-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-calcomp-1.0.0.1.tar.bz2;
      md5 = "3220d46c9e24cf2d7e34651a7eb62a03";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  ico = stdenv.mkDerivation {
    name = "ico-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/ico-0.99.2.tar.bz2;
      md5 = "a244a9c7645f90b158409daaab216fcc";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  fontscreencyrillic = stdenv.mkDerivation {
    name = "font-screen-cyrillic-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-screen-cyrillic-0.99.0.tar.bz2;
      md5 = "0391b7b1a35b59b4e692ad33ed8a93fe";
    };
    buildInputs = [pkgconfig ];
  };
    
  windowswmproto = stdenv.mkDerivation {
    name = "windowswmproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/windowswmproto-1.0.1.tar.bz2;
      md5 = "3e1bbd12b6fb91095fac84f6db064e92";
    };
    buildInputs = [pkgconfig ];
  };
    
  xtrans = stdenv.mkDerivation {
    name = "xtrans-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xtrans-0.99.1.tar.bz2;
      md5 = "09f19c8fa017306a3cfb614d90b665ea";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videoi740 = stdenv.mkDerivation {
    name = "xf86-video-i740-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-i740-1.0.0.1.tar.bz2;
      md5 = "f4327e32147ba8e1a207d53c19498f21";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputhyperpen = stdenv.mkDerivation {
    name = "xf86-input-hyperpen-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-hyperpen-1.0.0.1.tar.bz2;
      md5 = "bae491946753f4431f9315ba5a0f6dd3";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videonv = stdenv.mkDerivation {
    name = "xf86-video-nv-1.0.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-nv-1.0.1.1.tar.bz2;
      md5 = "55ddc763e67ef4dbc6808cef00ee9719";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontmiscethiopic = stdenv.mkDerivation {
    name = "font-misc-ethiopic-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-misc-ethiopic-0.99.1.tar.bz2;
      md5 = "57456ef69c6fc7d6133076c248704125";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputdynapro = stdenv.mkDerivation {
    name = "xf86-input-dynapro-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-dynapro-1.0.0.1.tar.bz2;
      md5 = "f58a104ff01d56dc2b0b1903c9db7423";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86dgaproto = stdenv.mkDerivation {
    name = "xf86dgaproto-2.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86dgaproto-2.0.1.tar.bz2;
      md5 = "1dd58688aff1af4be66b1553376c9560";
    };
    buildInputs = [pkgconfig ];
  };
    
  xdbedizzy = stdenv.mkDerivation {
    name = "xdbedizzy-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xdbedizzy-0.99.1.tar.bz2;
      md5 = "7955db459cb69c63e4ed18e7ffbf434e";
    };
    buildInputs = [pkgconfig libXp libXext libXprintUtil ];
  };
    
  xf86inputdigitaledge = stdenv.mkDerivation {
    name = "xf86-input-digitaledge-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-digitaledge-1.0.0.1.tar.bz2;
      md5 = "c48acca06f918252e000e55966268d08";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xwud = stdenv.mkDerivation {
    name = "xwud-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xwud-0.99.1.tar.bz2;
      md5 = "b25b8fa47cce2bf0206c244dfe617ed9";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xmag = stdenv.mkDerivation {
    name = "xmag-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmag-0.99.1.tar.bz2;
      md5 = "ff2bd7baef9fb864550bf6854e25d6ce";
    };
    buildInputs = [pkgconfig libXaw ];
  };
    
  xfd = stdenv.mkDerivation {
    name = "xfd-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfd-0.99.1.tar.bz2;
      md5 = "d1404167dd6040b11066d0b738d21662";
    };
    buildInputs = [pkgconfig freetype fontconfig libXft ];
  };
    
  xf86videoi810 = stdenv.mkDerivation {
    name = "xf86-video-i810-1.4.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-i810-1.4.0.1.tar.bz2;
      md5 = "9672a46773966c72d2d46e515c0324be";
    };
    buildInputs = [pkgconfig xorgserver xproto libXvMC libdrm xf86driproto randrproto renderproto mesa glproto fontsproto  ];
    # !!! possible "randrproto renderproto" should be propagated by xorg-server
  };
    
  libXtst = stdenv.mkDerivation {
    name = "libXtst-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXtst-0.99.1.tar.bz2;
      md5 = "c968b5f2df8b306d515c1b63b1e96851";
    };
    buildInputs = [pkgconfig libX11 libXext recordproto xextproto inputproto ];
  };
    
  xlsfonts = stdenv.mkDerivation {
    name = "xlsfonts-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xlsfonts-0.99.1.tar.bz2;
      md5 = "c060717cc4ad6a9eac4235721c043293";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xfwp = stdenv.mkDerivation {
    name = "xfwp-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfwp-0.99.1.tar.bz2;
      md5 = "9bbad1be138f872a4bbdd78cb72b4b27";
    };
    buildInputs = [pkgconfig libX11 libICE xproxymanagementprotocol ];
  };
    
  libXrender = stdenv.mkDerivation {
    name = "libXrender-0.9.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXrender-0.9.0.tar.bz2;
      md5 = "c226b737371595fb20743c3741534259";
    };
    buildInputs = [pkgconfig libX11 renderproto ];
  };
    
  xextproto = stdenv.mkDerivation {
    name = "xextproto-7.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xextproto-7.0.1.tar.bz2;
      md5 = "acf940f28d8f827cb4ffa8490e6a29e3";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videosis = stdenv.mkDerivation {
    name = "xf86-video-sis-0.8.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-sis-0.8.0.1.tar.bz2;
      md5 = "ac0723c894c7defa85ddaa6a35bbb537";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  fontmisccyrillic = stdenv.mkDerivation {
    name = "font-misc-cyrillic-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-misc-cyrillic-0.99.0.tar.bz2;
      md5 = "7d07c72c1ca740caf1d7c211a6fc7115";
    };
    buildInputs = [pkgconfig ];
  };
    
  fonttosfnt = stdenv.mkDerivation {
    name = "fonttosfnt-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fonttosfnt-0.99.1.tar.bz2;
      md5 = "d03539430985d45db534b0273e3d964f";
    };
    buildInputs = [pkgconfig libX11 freetype libfontenc ];
  };
    
  fontarabicmisc = stdenv.mkDerivation {
    name = "font-arabic-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-arabic-misc-0.99.0.tar.bz2;
      md5 = "d2190624e9895fdeea800b41c678078a";
    };
    buildInputs = [pkgconfig ];
  };
    
  lbxproxy = stdenv.mkDerivation {
    name = "lbxproxy-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/lbxproxy-0.99.1.tar.bz2;
      md5 = "0c3b5d6017f6d6d6288909d2cca29335";
    };
    buildInputs = [pkgconfig xtrans libXext liblbxutil libX11 libICE xproxymanagementprotocol ];
  };
    
  xauth = stdenv.mkDerivation {
    name = "xauth-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xauth-0.99.1.tar.bz2;
      md5 = "574215048f5693811cf9d590f0c796c0";
    };
    buildInputs = [pkgconfig libX11 libXau libXext libXmu ];
  };
    
  xsetroot = stdenv.mkDerivation {
    name = "xsetroot-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xsetroot-0.99.1.tar.bz2;
      md5 = "a2c7e1e929204c6d158dcea8d00747c7";
    };
    buildInputs = [pkgconfig libXmu libX11 xbitmaps ];
  };
    
  libXprintAppUtil = stdenv.mkDerivation {
    name = "libXprintAppUtil-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXprintAppUtil-0.99.1.tar.bz2;
      md5 = "3fa7ae8be391da9dde4133f9745d5181";
    };
    buildInputs = [pkgconfig libX11 libXp libXprintUtil ];
  };
    
  xfindproxy = stdenv.mkDerivation {
    name = "xfindproxy-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfindproxy-0.99.1.tar.bz2;
      md5 = "05d9003e93bba4ea6cfd5e4b54dbfc3a";
    };
    buildInputs = [pkgconfig libX11 libICE libXt ];
  };
    
  xf86inputmouse = stdenv.mkDerivation {
    name = "xf86-input-mouse-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-mouse-1.0.0.1.tar.bz2;
      md5 = "43712cd2961c22103827af04a228b4ff";
    };
    buildInputs = [pkgconfig xorgserver xproto randrproto inputproto ];
  };
    
  trapproto = stdenv.mkDerivation {
    name = "trapproto-3.4.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/trapproto-3.4.1.tar.bz2;
      md5 = "68d206a7d8f0e0424b7c2b02a19fc640";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputsumma = stdenv.mkDerivation {
    name = "xf86-input-summa-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-summa-1.0.0.1.tar.bz2;
      md5 = "a32b1813b6da13a72b5e9541f01447b1";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xlsclients = stdenv.mkDerivation {
    name = "xlsclients-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xlsclients-0.99.1.tar.bz2;
      md5 = "7013590b956b3091fa277bb51c6f7928";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  libXevie = stdenv.mkDerivation {
    name = "libXevie-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXevie-0.99.2.tar.bz2;
      md5 = "2198aa2ce5677cc90bd142637aa14ae3";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext evieext ];
  };
    
  fontsunmisc = stdenv.mkDerivation {
    name = "font-sun-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-sun-misc-0.99.0.tar.bz2;
      md5 = "253b7cd19d0885938e2e89e846f94d98";
    };
    buildInputs = [pkgconfig ];
  };
    
  xphelloworld = stdenv.mkDerivation {
    name = "xphelloworld-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xphelloworld-0.99.1.tar.bz2;
      md5 = "b3aa155f1cd27f75cb352a0de0d228ed";
    };
    buildInputs = [pkgconfig libX11 libXaw libXprintUtil libXprintAppUtil libXt ];
  };
    
  fontbhlucidatypewriter75dpi = stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-75dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-lucidatypewriter-75dpi-0.99.1.tar.bz2;
      md5 = "58e384a0f54599989191363f5e95d1d2";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontisasmisc = stdenv.mkDerivation {
    name = "font-isas-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-isas-misc-0.99.0.tar.bz2;
      md5 = "2dca3516341f7f79579f44bcf6f72b36";
    };
    buildInputs = [pkgconfig ];
  };
    
  applewmproto = stdenv.mkDerivation {
    name = "applewmproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/applewmproto-1.0.1.tar.bz2;
      md5 = "d29019f10bc82e14e7e38c85afadb3ca";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videofbdev = stdenv.mkDerivation {
    name = "xf86-video-fbdev-0.1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-fbdev-0.1.0.1.tar.bz2;
      md5 = "53e3959977e18f91ea4ee1a04af14438";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  mkcfm = stdenv.mkDerivation {
    name = "mkcfm-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/mkcfm-0.99.1.tar.bz2;
      md5 = "109a62f57b56cdd087e1db9a104dadca";
    };
    buildInputs = [pkgconfig libX11 libXfont libFS fontsproto ];
  };
    
  libXi = stdenv.mkDerivation {
    name = "libXi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXi-0.99.1.tar.bz2;
      md5 = "614215424104f693ea3b2c959c867e06";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext inputproto ];
  };
    
  xpr = stdenv.mkDerivation {
    name = "xpr-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xpr-0.99.1.tar.bz2;
      md5 = "f3ffc50ea2e7eb94a0b9a3f767149e34";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  fstobdf = stdenv.mkDerivation {
    name = "fstobdf-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fstobdf-0.99.1.tar.bz2;
      md5 = "b9d1b5ce5df31c716a18375abae16c48";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  xwininfo = stdenv.mkDerivation {
    name = "xwininfo-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xwininfo-0.99.1.tar.bz2;
      md5 = "fae69f678cf478e418b1f0534623b760";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xf86videomga = stdenv.mkDerivation {
    name = "xf86-video-mga-1.2.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-mga-1.2.0.1.tar.bz2;
      md5 = "4a3e5716a73580f027fa05bb008c54d9";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  libAppleWM = stdenv.mkDerivation {
    name = "libAppleWM-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libAppleWM-0.99.1.tar.bz2;
      md5 = "690e50700a4a421a4f21946ae51fe15a";
    };
    buildInputs = [pkgconfig libX11 libXext ];
  };
    
  rstart = stdenv.mkDerivation {
    name = "rstart-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/rstart-0.99.1.tar.bz2;
      md5 = "8e503f349437961ef0699f51a51958f3";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  libXvMC = stdenv.mkDerivation {
    name = "libXvMC-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXvMC-0.99.1.tar.bz2;
      md5 = "ef5e74d3b2e325017a40d9a09b4893ec";
    };
    buildInputs = [pkgconfig libX11 libXext libXv xextproto videoproto ];
  };
    
  fixesproto = stdenv.mkDerivation {
    name = "fixesproto-3.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fixesproto-3.0.1.tar.bz2;
      md5 = "b30b9210f32c80d31b75980cf4359abc";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86vidmodeproto = stdenv.mkDerivation {
    name = "xf86vidmodeproto-2.2.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86vidmodeproto-2.2.1.tar.bz2;
      md5 = "83c0bfe0208e85c597016f49e53b1b53";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontjismisc = stdenv.mkDerivation {
    name = "font-jis-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-jis-misc-0.99.0.tar.bz2;
      md5 = "f0a05c4cb5f40751d205568f38913696";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbhlucidatypewriter100dpi = stdenv.mkDerivation {
    name = "font-bh-lucidatypewriter-100dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-lucidatypewriter-100dpi-0.99.1.tar.bz2;
      md5 = "0621e8a31c8ec3dd324e961c03b3c369";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontwinitzkicyrillic = stdenv.mkDerivation {
    name = "font-winitzki-cyrillic-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-winitzki-cyrillic-0.99.0.tar.bz2;
      md5 = "89a4dd3ab5b5ed4a55ef8dbcbb3fb4c0";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontcacheproto = stdenv.mkDerivation {
    name = "fontcacheproto-0.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fontcacheproto-0.1.1.tar.bz2;
      md5 = "7fe13f559df135a37066156536152117";
    };
    buildInputs = [pkgconfig ];
  };
    
  xrx = stdenv.mkDerivation {
    name = "xrx-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xrx-0.99.1.tar.bz2;
      md5 = "ca55528465596a4cb7ef7167c499318a";
    };
    buildInputs = [pkgconfig libX11 libXt libXext ];
  };
    
  xf86videocirrus = stdenv.mkDerivation {
    name = "xf86-video-cirrus-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-cirrus-1.0.0.1.tar.bz2;
      md5 = "cf159e6fbb3aac5efa6993106587f86d";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontutil = stdenv.mkDerivation {
    name = "font-util-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-util-0.99.1.tar.bz2;
      md5 = "c7e2f6c5290f49edeb44ef0ce97fb626";
    };
    buildInputs = [pkgconfig ];
  };
    
  xprehashprinterlist = stdenv.mkDerivation {
    name = "xprehashprinterlist-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xprehashprinterlist-0.99.1.tar.bz2;
      md5 = "b2301cdb55ba664c31063974e99ae785";
    };
    buildInputs = [pkgconfig libXp libX11 ];
  };
    
  fontadobe100dpi = stdenv.mkDerivation {
    name = "font-adobe-100dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-adobe-100dpi-0.99.1.tar.bz2;
      md5 = "e608ea0c66d9c1bb36ce600a4698a498";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  xf86videoimstt = stdenv.mkDerivation {
    name = "xf86-video-imstt-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-imstt-1.0.0.1.tar.bz2;
      md5 = "b9706c21ee180a89bc4d90f7f645ef08";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  dmxproto = stdenv.mkDerivation {
    name = "dmxproto-2.2.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/dmxproto-2.2.1.tar.bz2;
      md5 = "0ad84d81f2e2d7522c2ee52ac1b2dd11";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videovga = stdenv.mkDerivation {
    name = "xf86-video-vga-4.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-vga-4.0.0.1.tar.bz2;
      md5 = "205d1d1aee4cbfa56514a59631294e95";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXxf86vm = stdenv.mkDerivation {
    name = "libXxf86vm-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXxf86vm-0.99.1.tar.bz2;
      md5 = "7ef000e1f41f03d0d0d94385aa223110";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86vidmodeproto ];
  };
    
  xf86videoglint = stdenv.mkDerivation {
    name = "xf86-video-glint-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-glint-1.0.0.1.tar.bz2;
      md5 = "8faedf800d015bc101f2197bb15e9736";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  listres = stdenv.mkDerivation {
    name = "listres-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/listres-0.99.1.tar.bz2;
      md5 = "07afee7042af7f9d1c47de4769e29b67";
    };
    buildInputs = [pkgconfig libX11 libXt libXmu ];
  };
    
  xf86inputkeyboard = stdenv.mkDerivation {
    name = "xf86-input-keyboard-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-keyboard-1.0.0.1.tar.bz2;
      md5 = "6d85c8ef6dd037f8824f0fe339383913";
    };
    buildInputs = [pkgconfig xorgserver xproto randrproto inputproto kbproto ];
    # real bug: inputproto kbproto 
  };
    
  xclipboard = stdenv.mkDerivation {
    name = "xclipboard-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xclipboard-0.99.1.tar.bz2;
      md5 = "ba0f16fe39a57491f9fefcd6fc4b52d1";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videoneomagic = stdenv.mkDerivation {
    name = "xf86-video-neomagic-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-neomagic-1.0.0.1.tar.bz2;
      md5 = "bac01a98f0b67534b1e2c826f11e391e";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  bdftopcf = stdenv.mkDerivation {
    name = "bdftopcf-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/bdftopcf-0.99.1.tar.bz2;
      md5 = "0ec978ead9753cc8e2b7778364c7e91e";
    };
    buildInputs = [pkgconfig libXfont ];
  };
    
  xf86inputmicrotouch = stdenv.mkDerivation {
    name = "xf86-input-microtouch-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-microtouch-1.0.0.1.tar.bz2;
      md5 = "7de65bd9909717139caeacb5f481846a";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXres = stdenv.mkDerivation {
    name = "libXres-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXres-0.99.1.tar.bz2;
      md5 = "de1a8676b870e28651b0fb2d05d6524c";
    };
    buildInputs = [pkgconfig libX11 libXext resourceproto xproto xextproto ];
  };
    
  fontbh100dpi = stdenv.mkDerivation {
    name = "font-bh-100dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-100dpi-0.99.1.tar.bz2;
      md5 = "bf1fe9990be94890d8fc71eda7a44777";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  libXfontcache = stdenv.mkDerivation {
    name = "libXfontcache-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXfontcache-0.99.1.tar.bz2;
      md5 = "b899e6a5b6910d432907990a98fe61db";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto fontcacheproto ];
  };
    
  xf86videosisusb = stdenv.mkDerivation {
    name = "xf86-video-sisusb-0.7.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-sisusb-0.7.0.1.tar.bz2;
      md5 = "878470be32ccd67b41ca0013d4b1133e";
    };
    buildInputs = [pkgconfig xorgserver xproto xineramaproto ];
  };
    
  xvidtune = stdenv.mkDerivation {
    name = "xvidtune-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xvidtune-0.99.1.tar.bz2;
      md5 = "9b74bc47016d867be74c76d212c176f7";
    };
    buildInputs = [pkgconfig libXxf86vm ];
  };
    
  fontmuttmisc = stdenv.mkDerivation {
    name = "font-mutt-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-mutt-misc-0.99.0.tar.bz2;
      md5 = "5b98c48d37776edf2e2d009200992939";
    };
    buildInputs = [pkgconfig ];
  };
    
  libfontenc = stdenv.mkDerivation {
    name = "libfontenc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libfontenc-0.99.1.tar.bz2;
      md5 = "eaef10ae712ac16ad52a65a70a15f8d8";
    };
    buildInputs = [pkgconfig xproto zlib ];
  };
    
  xf86inputjoystick = stdenv.mkDerivation {
    name = "xf86-input-joystick-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-joystick-1.0.0.1.tar.bz2;
      md5 = "92badfdc5b843ade8ccb3ade29ee3e31";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xrandr = stdenv.mkDerivation {
    name = "xrandr-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xrandr-0.99.1.tar.bz2;
      md5 = "25e219c4a29c0cb9d242c8b23ec60463";
    };
    buildInputs = [pkgconfig libXrandr libX11 ];
  };
    
  xtrap = stdenv.mkDerivation {
    name = "xtrap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xtrap-0.99.1.tar.bz2;
      md5 = "d0a612825ebf9918c2e42b36b1027674";
    };
    buildInputs = [pkgconfig libX11 libXTrap ];
  };
    
  xf86videorendition = stdenv.mkDerivation {
    name = "xf86-video-rendition-4.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-rendition-4.0.0.1.tar.bz2;
      md5 = "10864fed3e34019f12eced3edda2d394";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputdmc = stdenv.mkDerivation {
    name = "xf86-input-dmc-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-dmc-1.0.0.1.tar.bz2;
      md5 = "2b33d4b50d36483db40938a2258da810";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videos3 = stdenv.mkDerivation {
    name = "xf86-video-s3-0.3.5.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-s3-0.3.5.1.tar.bz2;
      md5 = "d8ed3d627bafb086ba1d4474c0ffc485";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputacecad = stdenv.mkDerivation {
    name = "xf86-input-acecad-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-acecad-1.0.0.1.tar.bz2;
      md5 = "7b91a62fe50f3d4641bd1be120c1806f";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontbitstreamspeedo = stdenv.mkDerivation {
    name = "font-bitstream-speedo-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bitstream-speedo-0.99.1.tar.bz2;
      md5 = "2a235fe6754ee8980f75a8e1007fd448";
    };
    buildInputs = [pkgconfig ];
  };
    
  renderproto = stdenv.mkDerivation {
    name = "renderproto-0.9.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/renderproto-0.9.1.tar.bz2;
      md5 = "e3cd4dd27085e02212095ca2f6d711ed";
    };
    buildInputs = [pkgconfig ];
  };
    
  inputproto = stdenv.mkDerivation {
    name = "inputproto-1.3.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/inputproto-1.3.1.tar.bz2;
      md5 = "a0ad117956edc9975a83c2571c26b686";
    };
    buildInputs = [pkgconfig ];
  };
    
  xkbevd = stdenv.mkDerivation {
    name = "xkbevd-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkbevd-0.99.1.tar.bz2;
      md5 = "ab5ab99a86418328100556ca5f699ada";
    };
    buildInputs = [pkgconfig libxkbfile ];
  };
    
  beforelight = stdenv.mkDerivation {
    name = "beforelight-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/beforelight-0.99.1.tar.bz2;
      md5 = "28e701c1978db6de57cfabff3df837ee";
    };
    buildInputs = [pkgconfig libX11 libXScrnSaver libXt ];
  };
    
  imake = stdenv.mkDerivation {
    name = "imake-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/imake-0.99.1.tar.bz2;
      md5 = "bf900c63573539732fe3f1211b69280b";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  fontcursormisc = stdenv.mkDerivation {
    name = "font-cursor-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-cursor-misc-0.99.0.tar.bz2;
      md5 = "3835613ee302786e426bd24bcf692e63";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86miscproto = stdenv.mkDerivation {
    name = "xf86miscproto-0.9.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86miscproto-0.9.1.tar.bz2;
      md5 = "1dbdee0696dcbc18338369452fb1c90a";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videocyrix = stdenv.mkDerivation {
    name = "xf86-video-cyrix-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-cyrix-1.0.0.1.tar.bz2;
      md5 = "53c2ed7e2886d9846a7ca46275445c84";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libxkbui = stdenv.mkDerivation {
    name = "libxkbui-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libxkbui-0.99.1.tar.bz2;
      md5 = "29fd7c47ecc89579ad9f0fa2f4a1f014";
    };
    buildInputs = [pkgconfig libX11 libXt libxkbfile ];
  };
    
  xf86rushproto = stdenv.mkDerivation {
    name = "xf86rushproto-1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86rushproto-1.1.1.tar.bz2;
      md5 = "7fbf63d9167965b431e445ae9af3cea9";
    };
    buildInputs = [pkgconfig ];
  };
    
  libXft = stdenv.mkDerivation {
    name = "libXft-2.1.8";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXft-2.1.8.tar.bz2;
      md5 = "18e7a98444ece30ea5b51a24269f8c7c";
    };
    buildInputs = [pkgconfig libXrender libX11 ];
    propagatedBuildInputs = [freetype fontconfig ];
  };
    
  xsm = stdenv.mkDerivation {
    name = "xsm-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xsm-0.99.1.tar.bz2;
      md5 = "6e8ae56836c00892bdf48376887e004b";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputevdev = stdenv.mkDerivation {
    name = "xf86-input-evdev-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-evdev-1.0.0.1.tar.bz2;
      md5 = "9de7c0f8bcdab1528459d5fe0ef3a226";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputelo2300 = stdenv.mkDerivation {
    name = "xf86-input-elo2300-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-elo2300-1.0.0.1.tar.bz2;
      md5 = "4bf7fb70e958dba3b5463ae08843e1e0";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videosunbw2 = stdenv.mkDerivation {
    name = "xf86-video-sunbw2-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-sunbw2-1.0.0.1.tar.bz2;
      md5 = "ce7b7227c3c5786099381ef033909765";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  liboldX = stdenv.mkDerivation {
    name = "liboldX-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/liboldX-0.99.1.tar.bz2;
      md5 = "3534a7571a62de08b1a4e8056ec3aef9";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  liblbxutil = stdenv.mkDerivation {
    name = "liblbxutil-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/liblbxutil-0.99.1.tar.bz2;
      md5 = "cf88ba52b6dbc00693f9711bd2b3bcd8";
    };
    buildInputs = [pkgconfig xproto xextproto zlib ];
  };
    
  randrproto = stdenv.mkDerivation {
    name = "randrproto-1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/randrproto-1.1.1.tar.bz2;
      md5 = "d1f245b2c12f418fc4be10e541c221b9";
    };
    buildInputs = [pkgconfig ];
  };
    
  xrefresh = stdenv.mkDerivation {
    name = "xrefresh-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xrefresh-0.99.1.tar.bz2;
      md5 = "0ad6f76dce84ac8cd66c0d1e4d9d0347";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  libICE = stdenv.mkDerivation {
    name = "libICE-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libICE-0.99.0.tar.bz2;
      md5 = "6a437911a6f88860536f32065a3e4019";
    };
    buildInputs = [pkgconfig xproto xtrans ];
  };
    
  utilmacros = stdenv.mkDerivation {
    name = "util-macros-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/util-macros-0.99.1.tar.bz2;
      md5 = "32713d3c4070b949afdc11bf559d2c61";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmiscmeltho = stdenv.mkDerivation {
    name = "font-misc-meltho-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-misc-meltho-0.99.1.tar.bz2;
      md5 = "84362b96a539b09c0c3a0357e76467c5";
    };
    buildInputs = [pkgconfig ];
  };
    
  xrdb = stdenv.mkDerivation {
    name = "xrdb-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xrdb-0.99.1.tar.bz2;
      md5 = "f324cd3b733efb9a27a894b86aea9696";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xf86videoark = stdenv.mkDerivation {
    name = "xf86-video-ark-0.5.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-ark-0.5.0.1.tar.bz2;
      md5 = "0303df2259e14bd4faaf768ae725d86a";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXv = stdenv.mkDerivation {
    name = "libXv-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXv-0.99.1.tar.bz2;
      md5 = "28de5dc16d38bb61bcb7adbf384a6b93";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto videoproto ];
  };
    
  makedepend = stdenv.mkDerivation {
    name = "makedepend-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/makedepend-0.99.1.tar.bz2;
      md5 = "1e66d034f7e6c47d620c0731531d35af";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  xf86videosiliconmotion = stdenv.mkDerivation {
    name = "xf86-video-siliconmotion-1.3.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-siliconmotion-1.3.1.1.tar.bz2;
      md5 = "cc301bc6a48679d420040a2bd719c3bf";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontmicromisc = stdenv.mkDerivation {
    name = "font-micro-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-micro-misc-0.99.0.tar.bz2;
      md5 = "99c37238d351e555c699df67443abb17";
    };
    buildInputs = [pkgconfig ];
  };
    
  libXTrap = stdenv.mkDerivation {
    name = "libXTrap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXTrap-0.99.1.tar.bz2;
      md5 = "4466f9d0b129fc6aed994ff96aed2f43";
    };
    buildInputs = [pkgconfig libX11 libXt trapproto libXext xextproto ];
  };
    
  proxymngr = stdenv.mkDerivation {
    name = "proxymngr-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/proxymngr-0.99.1.tar.bz2;
      md5 = "af4be82acc787c7e63f956deac436618";
    };
    buildInputs = [pkgconfig libICE libXt libX11 xproxymanagementprotocol ];
  };
    
  xf86videosuncg6 = stdenv.mkDerivation {
    name = "xf86-video-suncg6-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-suncg6-1.0.0.1.tar.bz2;
      md5 = "5dbd7ba3c934625778a79611bec846b1";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontsonymisc = stdenv.mkDerivation {
    name = "font-sony-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-sony-misc-0.99.0.tar.bz2;
      md5 = "23ea0121bb3610253df1fad423f052f7";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontibmtype1 = stdenv.mkDerivation {
    name = "font-ibm-type1-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-ibm-type1-0.99.0.tar.bz2;
      md5 = "9dcb4de80c546b95ea3393eeb489aeb5";
    };
    buildInputs = [pkgconfig ];
  };
    
  xedit = stdenv.mkDerivation {
    name = "xedit-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xedit-0.99.1.tar.bz2;
      md5 = "437e28d886da20181aa879d1f8855f36";
    };
    buildInputs = [pkgconfig libXprintUtil libXaw ];
  };
    
  fontadobeutopiatype1 = stdenv.mkDerivation {
    name = "font-adobe-utopia-type1-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-adobe-utopia-type1-0.99.0.tar.bz2;
      md5 = "9b77d3d9bd71a77d1c053998699926ea";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontmiscmisc = stdenv.mkDerivation {
    name = "font-misc-misc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-misc-misc-0.99.1.tar.bz2;
      md5 = "262866521d8f1f4bfd48a8bdcc8ef73e";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  libXau = stdenv.mkDerivation {
    name = "libXau-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXau-0.99.1.tar.bz2;
      md5 = "e9f8e470b4bb2f87c3989ae4f995edb8";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  xineramaproto = stdenv.mkDerivation {
    name = "xineramaproto-1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xineramaproto-1.1.1.tar.bz2;
      md5 = "bdb8a5c7acb543c72386de3b1da3cc14";
    };
    buildInputs = [pkgconfig ];
  };
    
  xplsprinters = stdenv.mkDerivation {
    name = "xplsprinters-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xplsprinters-0.99.1.tar.bz2;
      md5 = "9a7356c9f11c5f66985da0de36faac56";
    };
    buildInputs = [pkgconfig libXp libXprintUtil libX11 ];
  };
    
  kbproto = stdenv.mkDerivation {
    name = "kbproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/kbproto-1.0.1.tar.bz2;
      md5 = "f60e8038389a8fec9870fd73aae4b0cd";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontschumachermisc = stdenv.mkDerivation {
    name = "font-schumacher-misc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-schumacher-misc-0.99.1.tar.bz2;
      md5 = "264b86f213a42f2d4f2acf96f42e1c02";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  fontbh75dpi = stdenv.mkDerivation {
    name = "font-bh-75dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-75dpi-0.99.1.tar.bz2;
      md5 = "4dc742afa7d50c1a8bb6e2503f7ae7e5";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  oclock = stdenv.mkDerivation {
    name = "oclock-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/oclock-0.99.1.tar.bz2;
      md5 = "608013e4de3017b2aed30f1327a5c16d";
    };
    buildInputs = [pkgconfig libX11 libXmu libXext ];
  };
    
  xcalc = stdenv.mkDerivation {
    name = "xcalc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xcalc-0.99.1.tar.bz2;
      md5 = "8a2fc226ae835aab7be5babceb57da10";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videonsc = stdenv.mkDerivation {
    name = "xf86-video-nsc-2.7.6.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-nsc-2.7.6.1.tar.bz2;
      md5 = "e38a368f00c0dbda4f933892d207b98f";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xkill = stdenv.mkDerivation {
    name = "xkill-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkill-0.99.1.tar.bz2;
      md5 = "148c0addb15b16e7e7890af66a51e3ea";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xman = stdenv.mkDerivation {
    name = "xman-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xman-0.99.1.tar.bz2;
      md5 = "6ff3551d51b1d32e8f802106cfb45cef";
    };
    buildInputs = [pkgconfig libXprintUtil ];
  };
    
  xf86inputelographics = stdenv.mkDerivation {
    name = "xf86-input-elographics-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-elographics-1.0.0.1.tar.bz2;
      md5 = "a0bce2237c674dab111c85bea3a60961";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  evieext = stdenv.mkDerivation {
    name = "evieext-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/evieext-1.0.1.tar.bz2;
      md5 = "e3dfec2dec02857e4710e0fda752ec57";
    };
    buildInputs = [pkgconfig ];
  };
    
  libXinerama = stdenv.mkDerivation {
    name = "libXinerama-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXinerama-0.99.1.tar.bz2;
      md5 = "9845c81794ea3ca7a3b39cb3c19be040";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto xineramaproto ];
  };
    
  fontbitstream75dpi = stdenv.mkDerivation {
    name = "font-bitstream-75dpi-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bitstream-75dpi-0.99.0.tar.bz2;
      md5 = "3da671b588aa93f8338d4db03b02952e";
    };
    buildInputs = [pkgconfig ];
  };
    
  videoproto = stdenv.mkDerivation {
    name = "videoproto-2.2.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/videoproto-2.2.1.tar.bz2;
      md5 = "697225b241331fba0f90c072252a8669";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videovesa = stdenv.mkDerivation {
    name = "xf86-video-vesa-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-vesa-1.0.0.1.tar.bz2;
      md5 = "a99a640c5c4ed24bc6ac5ea363af4da1";
    };
    buildInputs = [pkgconfig xorgserver xproto randrproto xextproto renderproto fontsproto ];
  };
    
  xf86inputmagictouch = stdenv.mkDerivation {
    name = "xf86-input-magictouch-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-magictouch-1.0.0.1.tar.bz2;
      md5 = "96a0f5582e8d92cc2df081d0f2643a48";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontbitstreamtype1 = stdenv.mkDerivation {
    name = "font-bitstream-type1-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bitstream-type1-0.99.0.tar.bz2;
      md5 = "3ce4e030ca1b2591bfa971492d8cff4c";
    };
    buildInputs = [pkgconfig ];
  };
    
  mkfontdir = stdenv.mkDerivation {
    name = "mkfontdir-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/mkfontdir-0.99.1.tar.bz2;
      md5 = "a0e7abcef59422e87f56d71add67e74b";
    };
    buildInputs = [pkgconfig ];
  };
    
  xcmiscproto = stdenv.mkDerivation {
    name = "xcmiscproto-1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xcmiscproto-1.1.1.tar.bz2;
      md5 = "283d1b2712a6c82faded9ec01e582c9c";
    };
    buildInputs = [pkgconfig ];
  };
    
  xstdcmap = stdenv.mkDerivation {
    name = "xstdcmap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xstdcmap-0.99.1.tar.bz2;
      md5 = "a33c371c9b7ecd66e39e6e2824bf172b";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xkbdata = stdenv.mkDerivation {
    name = "xkbdata-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkbdata-0.99.1.tar.bz2;
      md5 = "ac4b6c4415d5cfb47f2454438048dd8d";
    };
    buildInputs = [pkgconfig ];
  };
    
  appres = stdenv.mkDerivation {
    name = "appres-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/appres-0.99.1.tar.bz2;
      md5 = "4eae4f301d5a9e316da71c8928c1015c";
    };
    buildInputs = [pkgconfig libX11 libXt ];
  };
    
  recordproto = stdenv.mkDerivation {
    name = "recordproto-1.13.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/recordproto-1.13.1.tar.bz2;
      md5 = "b8f32deca1741af534c9544c451752d2";
    };
    buildInputs = [pkgconfig ];
  };
    
  xdpyinfo = stdenv.mkDerivation {
    name = "xdpyinfo-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xdpyinfo-0.99.1.tar.bz2;
      md5 = "086fe5235a5ea200fc41a7cc3e961805";
    };
    buildInputs = [pkgconfig libXext libX11 libXtst xextproto kbproto xf86vidmodeproto libXxf86vm xf86dgaproto libXxf86dga xf86miscproto libXxf86misc inputproto libXi renderproto libXrender xineramaproto libXinerama dmxproto libdmx printproto libXp ];
  };
    
  xf86videosunffb = stdenv.mkDerivation {
    name = "xf86-video-sunffb-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-sunffb-1.0.0.1.tar.bz2;
      md5 = "c2e9426b5d105b2d20ba546a03aad79a";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  xf86videotrident = stdenv.mkDerivation {
    name = "xf86-video-trident-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-trident-1.0.0.1.tar.bz2;
      md5 = "08aeefd115c2ed6e172d9225ec22468e";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputjamstudio = stdenv.mkDerivation {
    name = "xf86-input-jamstudio-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-jamstudio-1.0.0.1.tar.bz2;
      md5 = "872a5616bf5ef91f7a7ce4866aa0ca22";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xload = stdenv.mkDerivation {
    name = "xload-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xload-0.99.1.tar.bz2;
      md5 = "87425195df0c04a186ecbc111e32b736";
    };
    buildInputs = [pkgconfig ];
  };
    
  encodings = stdenv.mkDerivation {
    name = "encodings-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/encodings-0.99.1.tar.bz2;
      md5 = "2fcf2fc59ba25424ffd967477e98ed7b";
    };
    buildInputs = [pkgconfig ];
  };
    
  glproto = stdenv.mkDerivation {
    name = "glproto-1.4.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/glproto-1.4.1.tar.bz2;
      md5 = "77f91c775e5a957c33b3ecf7162e3d2a";
    };
    buildInputs = [pkgconfig ];
  };
    
  scrnsaverproto = stdenv.mkDerivation {
    name = "scrnsaverproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/scrnsaverproto-1.0.1.tar.bz2;
      md5 = "8e065d1f938ec2df89e8a7cf8dc74093";
    };
    buildInputs = [pkgconfig ];
  };
    
  damageproto = stdenv.mkDerivation {
    name = "damageproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/damageproto-1.0.1.tar.bz2;
      md5 = "5949cade56a91679305b8a0e079e1f92";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videoi128 = stdenv.mkDerivation {
    name = "xf86-video-i128-1.1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-i128-1.1.0.1.tar.bz2;
      md5 = "958f339ade6697ed6b7e9838535377dd";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xgc = stdenv.mkDerivation {
    name = "xgc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xgc-0.99.1.tar.bz2;
      md5 = "0d3bbc77e4862c84db5fdff9de291929";
    };
    buildInputs = [pkgconfig ];
  };
    
  viewres = stdenv.mkDerivation {
    name = "viewres-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/viewres-0.99.1.tar.bz2;
      md5 = "01a7c2b4bfb941e35493b0897d65bd32";
    };
    buildInputs = [pkgconfig ];
  };
    
  xeyes = stdenv.mkDerivation {
    name = "xeyes-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xeyes-0.99.1.tar.bz2;
      md5 = "dd11f3fab80ee34a1b9ad0a52d42744e";
    };
    buildInputs = [pkgconfig libX11 libXt libXext libXmu ];
  };
    
  resourceproto = stdenv.mkDerivation {
    name = "resourceproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/resourceproto-1.0.1.tar.bz2;
      md5 = "8fbe50b8a2c61a9b7f6a9d1cca635137";
    };
    buildInputs = [pkgconfig ];
  };
    
  xinit = stdenv.mkDerivation {
    name = "xinit-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xinit-0.99.2.tar.bz2;
      md5 = "a9b07d984176d0282937a4d820acae17";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xf86inputtek4957 = stdenv.mkDerivation {
    name = "xf86-input-tek4957-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-tek4957-1.0.0.1.tar.bz2;
      md5 = "ae3c74bb2899765e22376c256834fa08";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videovia = stdenv.mkDerivation {
    name = "xf86-video-via-0.1.31.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-via-0.1.31.1.tar.bz2;
      md5 = "acaab775571c212ebec0634bd8eb8d84";
    };
    buildInputs = [pkgconfig xorgserver xproto libXvMC libdrm xf86driproto ];
  };
    
  xf86inputmagellan = stdenv.mkDerivation {
    name = "xf86-input-magellan-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-magellan-1.0.0.1.tar.bz2;
      md5 = "b313d8fe2388a6515ffaeef13cfca5e1";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xproxymanagementprotocol = stdenv.mkDerivation {
    name = "xproxymanagementprotocol-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xproxymanagementprotocol-1.0.1.tar.bz2;
      md5 = "0a0d5505283b24c1845c40a9c2a41438";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videotga = stdenv.mkDerivation {
    name = "xf86-video-tga-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-tga-1.0.0.1.tar.bz2;
      md5 = "2ff549257a0215cafb0520f4ca789649";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontbhtype1 = stdenv.mkDerivation {
    name = "font-bh-type1-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-type1-0.99.0.tar.bz2;
      md5 = "153a616911d4bcd85a7d5e6fe6cf4cf5";
    };
    buildInputs = [pkgconfig ];
  };
    
  xfs = stdenv.mkDerivation {
    name = "xfs-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfs-0.99.1.tar.bz2;
      md5 = "5be3ea3592f54b4300befccd803419b9";
    };
    buildInputs = [pkgconfig libFS fontsproto libXfont ];
  };
    
  xorgserver = stdenv.mkDerivation {
    name = "xorg-server-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xorg-server-0.99.2.tar.bz2;
      md5 = "a1b532b00400a77217e287d6fd2706fe";
    };
    buildInputs = [pkgconfig liblbxutil xf86driproto libdrm glproto libXdmcp libXmu libXext libX11 libXrender libXfont libXi dmxproto libXau libXaw libXmu libXt libXpm libdmx libXtst libXres printproto libxkbfile randrproto renderproto fixesproto damageproto xcmiscproto xextproto xproto xtrans xf86miscproto xf86vidmodeproto xf86bigfontproto scrnsaverproto bigreqsproto resourceproto libfontenc fontsproto videoproto compositeproto recordproto resourceproto xineramaproto perl libxkbui libXxf86misc libXxf86vm inputproto xf86dgaproto mesa libSM libICE zlib ];
    # Strange: randrproto renderproto etc.
    # Proper bug: inputproto xf86dgaproto libSM libICE
    # maybe libICE should be propagated by libSM
  };
    
  fontdaewoomisc = stdenv.mkDerivation {
    name = "font-daewoo-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-daewoo-misc-0.99.0.tar.bz2;
      md5 = "5f1d4ce4f6bd2aeb45135ce5d721928f";
    };
    buildInputs = [pkgconfig ];
  };
    
  libXxf86misc = stdenv.mkDerivation {
    name = "libXxf86misc-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXxf86misc-0.99.1.tar.bz2;
      md5 = "70ef1e9d85a3544d0b7179c4b8a90c67";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86miscproto ];
  };
    
  printproto = stdenv.mkDerivation {
    name = "printproto-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/printproto-1.0.1.tar.bz2;
      md5 = "384b0d42f6fcf7f1a93c7e6ae449da84";
    };
    buildInputs = [pkgconfig ];
  };
    
  fontbhttf = stdenv.mkDerivation {
    name = "font-bh-ttf-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-bh-ttf-0.99.0.tar.bz2;
      md5 = "91a64778869d638ef5383597ed9d1a44";
    };
    buildInputs = [pkgconfig ];
  };
    
  xmore = stdenv.mkDerivation {
    name = "xmore-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmore-0.99.1.tar.bz2;
      md5 = "d080831a31496fb167d4221bfea95063";
    };
    buildInputs = [pkgconfig libXprintUtil ];
  };
    
  libXxf86dga = stdenv.mkDerivation {
    name = "libXxf86dga-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXxf86dga-0.99.1.tar.bz2;
      md5 = "1ff5df00261dc8c11e9942c2191ec9c8";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXext xf86dgaproto ];
  };
    
  libdmx = stdenv.mkDerivation {
    name = "libdmx-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libdmx-0.99.1.tar.bz2;
      md5 = "1e3c93b00223a99494c802b9e38ff4df";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto dmxproto ];
  };
    
  fontadobeutopia100dpi = stdenv.mkDerivation {
    name = "font-adobe-utopia-100dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-adobe-utopia-100dpi-0.99.1.tar.bz2;
      md5 = "79bf5da7ec818bc522072500d675b1c9";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  bitmap = stdenv.mkDerivation {
    name = "bitmap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/bitmap-0.99.1.tar.bz2;
      md5 = "4c5c83995902f2f967bd548d68d35429";
    };
    buildInputs = [pkgconfig libX11 libXmu xbitmaps ];
  };
    
  xmkmf = stdenv.mkDerivation {
    name = "xmkmf-0.99.1";
    builder = ./xmkmf.sh;
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmkmf-0.99.1.tar.bz2;
      md5 = "75013b6eeed99fd7b4e7913144a9de22";
    };
    buildInputs = [pkgconfig ];
    propagatedBuildInputs = [imake];
    inherit xorgcffiles;
  };
    
  xorgcffiles = stdenv.mkDerivation {
    name = "xorg-cf-files-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xorg-cf-files-0.99.1.tar.bz2;
      md5 = "8ad3c7e473f5fe5c467ee0f5602c76d9";
    };
    buildInputs = [pkgconfig ];
  };
    
  xproto = stdenv.mkDerivation {
    name = "xproto-7.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xproto-7.0.1.tar.bz2;
      md5 = "66267ac1cddfe54018e33fade13f2ca0";
    };
    buildInputs = [pkgconfig ];
  };
    
  iceauth = stdenv.mkDerivation {
    name = "iceauth-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/iceauth-0.99.1.tar.bz2;
      md5 = "2119a44507e738d085047e313cd0e8e6";
    };
    buildInputs = [pkgconfig libX11 libICE ];
  };
    
  libXrandr = stdenv.mkDerivation {
    name = "libXrandr-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXrandr-0.99.1.tar.bz2;
      md5 = "b85d1d0bb241fdfd455605e0a5b26e09";
    };
    buildInputs = [pkgconfig libX11 randrproto libXext libXrender renderproto ];
  };
    
  twm = stdenv.mkDerivation {
    name = "twm-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/twm-0.99.1.tar.bz2;
      md5 = "ed67ddb7759659875f0fdca9846b1a98";
    };
    buildInputs = [pkgconfig libX11 libXt libXmu ];
  };
    
  xf86videosuncg3 = stdenv.mkDerivation {
    name = "xf86-video-suncg3-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-suncg3-1.0.0.1.tar.bz2;
      md5 = "09e5ad599ef590ab560c11cfbd3bc723";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXfont = stdenv.mkDerivation {
    name = "libXfont-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXfont-0.99.1.tar.bz2;
      md5 = "5896d187833e5f55d50397f9e8be3cd5";
    };
    buildInputs = [pkgconfig freetype fontcacheproto xproto xtrans fontsproto libfontenc zlib ];
  };
    
  libXp = stdenv.mkDerivation {
    name = "libXp-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXp-0.99.1.tar.bz2;
      md5 = "63d2af9c41b863aa0004ee520204bbe9";
    };
    buildInputs = [pkgconfig libX11 libXext libXau printproto ];
  };
    
  xprop = stdenv.mkDerivation {
    name = "xprop-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xprop-0.99.1.tar.bz2;
      md5 = "7502472d560bdf01330deb057bd0ef0e";
    };
    buildInputs = [pkgconfig libXmu libX11 ];
  };
    
  xf86videosuntcx = stdenv.mkDerivation {
    name = "xf86-video-suntcx-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-suntcx-1.0.0.1.tar.bz2;
      md5 = "99083cc0a5e259422e874fa466fa6ceb";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videovmware = stdenv.mkDerivation {
    name = "xf86-video-vmware-10.11.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-vmware-10.11.0.1.tar.bz2;
      md5 = "9148f56a12269cf2f74bf77fef44d64c";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXcomposite = stdenv.mkDerivation {
    name = "libXcomposite-0.2.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXcomposite-0.2.1.tar.bz2;
      md5 = "2039221efe4fa52be5551dde96aee0a0";
    };
    buildInputs = [pkgconfig compositeproto ];
  };
    
  libXScrnSaver = stdenv.mkDerivation {
    name = "libXScrnSaver-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXScrnSaver-0.99.2.tar.bz2;
      md5 = "91ccc3a94a5ac611d5faab8c1fda8056";
    };
    buildInputs = [pkgconfig libX11 libXext xextproto scrnsaverproto ];
  };
    
  xcmsdb = stdenv.mkDerivation {
    name = "xcmsdb-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xcmsdb-0.99.1.tar.bz2;
      md5 = "0f26f8759ebaffe061b13695270fdb8b";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xf86inputspaceorb = stdenv.mkDerivation {
    name = "xf86-input-spaceorb-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-spaceorb-1.0.0.1.tar.bz2;
      md5 = "53b1b074cdad065ca900f93757f8d17f";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86inputpenmount = stdenv.mkDerivation {
    name = "xf86-input-penmount-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-penmount-1.0.0.1.tar.bz2;
      md5 = "d876e53d39f94b3d640d5b04f812c2aa";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libXpm = stdenv.mkDerivation {
    name = "libXpm-3.5.3";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXpm-3.5.3.tar.bz2;
      md5 = "7830c7b5030607b7a0de393f8717aad0";
    };
    buildInputs = [pkgconfig xproto libX11 libXt libXext ];
  };
    
  xfsinfo = stdenv.mkDerivation {
    name = "xfsinfo-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfsinfo-0.99.1.tar.bz2;
      md5 = "a60686cee66253818c3743d076976e0c";
    };
    buildInputs = [pkgconfig libX11 libFS ];
  };
    
  xcursorgen = stdenv.mkDerivation {
    name = "xcursorgen-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xcursorgen-0.99.0.tar.bz2;
      md5 = "438a8156e42c9d3aabaa1c1daa85fa85";
    };
    buildInputs = [pkgconfig libX11 libXcursor libpng ];
  };
    
  libFS = stdenv.mkDerivation {
    name = "libFS-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libFS-0.99.1.tar.bz2;
      md5 = "874d771539ed056e6bdc3372601e73ca";
    };
    buildInputs = [pkgconfig xproto fontsproto xtrans ];
  };
    
  fontadobeutopia75dpi = stdenv.mkDerivation {
    name = "font-adobe-utopia-75dpi-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-adobe-utopia-75dpi-0.99.1.tar.bz2;
      md5 = "206dc25f8ea6a86c582da29aefade8e0";
    };
    buildInputs = [pkgconfig fontutil ];
  };
    
  xclock = stdenv.mkDerivation {
    name = "xclock-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xclock-0.99.1.tar.bz2;
      md5 = "ec54b47ee229318cef76a3c86da9ef94";
    };
    buildInputs = [pkgconfig libX11 libXrender libXft libxkbfile libXaw ];
  };
    
  xf86videoati = stdenv.mkDerivation {
    name = "xf86-video-ati-6.5.6.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-ati-6.5.6.1.tar.bz2;
      md5 = "ebc1718e6eb215cec331d11e86802b5f";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  xf86videodummy = stdenv.mkDerivation {
    name = "xf86-video-dummy-0.1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-dummy-0.1.0.1.tar.bz2;
      md5 = "66c0427661a1468debe2b17e065c5b0a";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libxkbfile = stdenv.mkDerivation {
    name = "libxkbfile-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libxkbfile-0.99.1.tar.bz2;
      md5 = "09f12f4177f7172912f74e488ff20e95";
    };
    buildInputs = [pkgconfig libX11 kbproto ];
  };
    
  libXext = stdenv.mkDerivation {
    name = "libXext-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXext-0.99.1.tar.bz2;
      md5 = "7dbf302396434d4b74a40c4e9c8a1fb2";
    };
    buildInputs = [pkgconfig xproto libX11 xextproto libXau ];
  };
    
  xf86inputaiptek = stdenv.mkDerivation {
    name = "xf86-input-aiptek-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-aiptek-1.0.0.1.tar.bz2;
      md5 = "4ee82eabd3ccc05894de5213423510f3";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xmh = stdenv.mkDerivation {
    name = "xmh-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmh-0.99.1.tar.bz2;
      md5 = "469d536e8b1933bfb5bf6ecfc9b9c920";
    };
    buildInputs = [pkgconfig ];
  };
    
  xcursorthemes = stdenv.mkDerivation {
    name = "xcursor-themes-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xcursor-themes-0.99.1.tar.bz2;
      md5 = "f6eb25fab260b7ae0add3e0c2030abb5";
    };
    buildInputs = [pkgconfig ];
  };
    
  xset = stdenv.mkDerivation {
    name = "xset-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xset-0.99.2.tar.bz2;
      md5 = "8babe3fa82ef4a824610acee9a81dd4a";
    };
    buildInputs = [pkgconfig libXmu xextproto libXext kbproto libX11 xf86miscproto libXxf86misc fontcacheproto libXfontcache printproto libXp ];
  };
    
  xbitmaps = stdenv.mkDerivation {
    name = "xbitmaps-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xbitmaps-0.99.1.tar.bz2;
      md5 = "941c8694c17566401e45e16b52fcf8ba";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputvoid = stdenv.mkDerivation {
    name = "xf86-input-void-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-void-1.0.0.1.tar.bz2;
      md5 = "731f40b90189aeb1a54d6403b41491b8";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videotseng = stdenv.mkDerivation {
    name = "xf86-video-tseng-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-tseng-1.0.0.1.tar.bz2;
      md5 = "bcd6fc8d485bbd0fd3aae513a98ec81c";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videoapm = stdenv.mkDerivation {
    name = "xf86-video-apm-1.0.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-apm-1.0.1.1.tar.bz2;
      md5 = "8e6637abe5178349b80637ca97284ade";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xgamma = stdenv.mkDerivation {
    name = "xgamma-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xgamma-0.99.1.tar.bz2;
      md5 = "6ea7dcdf5e12f5543eb06191178985fd";
    };
    buildInputs = [pkgconfig libXxf86vm ];
  };
    
  libXcursor = stdenv.mkDerivation {
    name = "libXcursor-1.1.4";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXcursor-1.1.4.tar.bz2;
      md5 = "f706908d7d03705a6ee64a84edcdc8af";
    };
    buildInputs = [pkgconfig libXrender libXfixes libX11 ];
  };
    
  xf86inputpalmax = stdenv.mkDerivation {
    name = "xf86-input-palmax-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-palmax-1.0.0.1.tar.bz2;
      md5 = "8fd274074fbf9de6efbcc50f4dab02c5";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  libX11 = stdenv.mkDerivation {
    name = "libX11-0.99.2";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libX11-0.99.2.tar.bz2;
      md5 = "01e7ab4166bffcba3392feab0c3cb789";
    };
    buildInputs = [pkgconfig bigreqsproto xproto xextproto xtrans libXau xcmiscproto libXdmcp xf86bigfontproto kbproto inputproto ];
  };
    
  fontdecmisc = stdenv.mkDerivation {
    name = "font-dec-misc-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-dec-misc-0.99.0.tar.bz2;
      md5 = "a13fbb8b64f1f852d67da92816b05ce6";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86videochips = stdenv.mkDerivation {
    name = "xf86-video-chips-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-chips-1.0.0.1.tar.bz2;
      md5 = "ed185559bc723cb90b8a12ea0e8453e1";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  fontcronyxcyrillic = stdenv.mkDerivation {
    name = "font-cronyx-cyrillic-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-cronyx-cyrillic-0.99.0.tar.bz2;
      md5 = "472392fa8eb82666bf4f48f57fffea46";
    };
    buildInputs = [pkgconfig ];
  };
    
  luit = stdenv.mkDerivation {
    name = "luit-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/luit-0.99.1.tar.bz2;
      md5 = "97550cc1456c85018c89c78c64c34b33";
    };
    buildInputs = [pkgconfig libX11 libfontenc ];
  };
    
  showfont = stdenv.mkDerivation {
    name = "showfont-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/showfont-0.99.1.tar.bz2;
      md5 = "4df4d11dcfe006827b8d1d3d8d512d2d";
    };
    buildInputs = [pkgconfig libFS ];
  };
    
  fontxfree86type1 = stdenv.mkDerivation {
    name = "font-xfree86-type1-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-xfree86-type1-0.99.0.tar.bz2;
      md5 = "b57ab755e257d417aef3f2457e548763";
    };
    buildInputs = [pkgconfig ];
  };
    
  xditview = stdenv.mkDerivation {
    name = "xditview-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xditview-0.99.1.tar.bz2;
      md5 = "c365b07a47be067530af56d18ad3f724";
    };
    buildInputs = [pkgconfig ];
  };
    
  setxkbmap = stdenv.mkDerivation {
    name = "setxkbmap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/setxkbmap-0.99.1.tar.bz2;
      md5 = "78ebfdee2a5f2f0cb132f7609e254152";
    };
    buildInputs = [pkgconfig libxkbfile libX11 ];
  };
    
  xfontsel = stdenv.mkDerivation {
    name = "xfontsel-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xfontsel-0.99.1.tar.bz2;
      md5 = "32e91cc661725ccb24a27436c92720d4";
    };
    buildInputs = [pkgconfig ];
  };
    
  xkbcomp = stdenv.mkDerivation {
    name = "xkbcomp-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkbcomp-0.99.1.tar.bz2;
      md5 = "9e6d4fbbe842a7411de0a827cc6fff71";
    };
    buildInputs = [pkgconfig libX11 libxkbfile ];
  };
    
  xf86videonewport = stdenv.mkDerivation {
    name = "xf86-video-newport-0.1.3.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-newport-0.1.3.1.tar.bz2;
      md5 = "b3e1af53afe9604cd64758d13dba7aa9";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  sessreg = stdenv.mkDerivation {
    name = "sessreg-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/sessreg-0.99.1.tar.bz2;
      md5 = "d3aa65328fce867246a8ee5e37f688e4";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  xev = stdenv.mkDerivation {
    name = "xev-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xev-0.99.1.tar.bz2;
      md5 = "2ed91114c0079ab471e90284edd67874";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  xkbprint = stdenv.mkDerivation {
    name = "xkbprint-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkbprint-0.99.1.tar.bz2;
      md5 = "8199f38e7e9a80171ae9aa2a27946353";
    };
    buildInputs = [pkgconfig libxkbfile ];
  };
    
  xkbutils = stdenv.mkDerivation {
    name = "xkbutils-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xkbutils-0.99.0.tar.bz2;
      md5 = "055a0822597ef2cf5c792711effc6134";
    };
    buildInputs = [pkgconfig libxkbfile ];
  };
    
  xsetmode = stdenv.mkDerivation {
    name = "xsetmode-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xsetmode-0.99.1.tar.bz2;
      md5 = "4053ac1f8a7411945b8cdd2d4991e462";
    };
    buildInputs = [pkgconfig libXi libX11 ];
  };
    
  libXdamage = stdenv.mkDerivation {
    name = "libXdamage-1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXdamage-1.0.1.tar.bz2;
      md5 = "7bd8ce64967790ca9c0ef438105603e2";
    };
    buildInputs = [pkgconfig libX11 damageproto ];
  };
    
  xbiff = stdenv.mkDerivation {
    name = "xbiff-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xbiff-0.99.1.tar.bz2;
      md5 = "23e101120ee35579677612784f8bb81a";
    };
    buildInputs = [pkgconfig xbitmaps ];
  };
    
  libXmu = stdenv.mkDerivation {
    name = "libXmu-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXmu-0.99.1.tar.bz2;
      md5 = "0aa2e07630b5dc04964188354d631407";
    };
    buildInputs = [pkgconfig libXt libXext libX11 ];
  };
    
  xf86inputcitron = stdenv.mkDerivation {
    name = "xf86-input-citron-2.1.1.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-citron-2.1.1.1.tar.bz2;
      md5 = "6c1df5a945e98ebd5dad3db249c9dcbf";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videovoodoo = stdenv.mkDerivation {
    name = "xf86-video-voodoo-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-voodoo-1.0.0.1.tar.bz2;
      md5 = "b65be248324e2eef6ce92644cd1805d5";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  rgb = stdenv.mkDerivation {
    name = "rgb-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/rgb-0.99.1.tar.bz2;
      md5 = "e0582fba6e706541594122852b896f4d";
    };
    buildInputs = [pkgconfig xproto ];
  };
    
  libXt = stdenv.mkDerivation {
    name = "libXt-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXt-0.99.1.tar.bz2;
      md5 = "a3b65703a80cc0582757c595c0875612";
    };
    buildInputs = [pkgconfig libSM libX11 xproto kbproto ];
    # !!! prop libSM
  };
    
  editres = stdenv.mkDerivation {
    name = "editres-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/editres-0.99.1.tar.bz2;
      md5 = "081dc951b07f7f0639726d9effabe1ca";
    };
    buildInputs = [pkgconfig libX11 libXt libXmu ];
  };
    
  fontalias = stdenv.mkDerivation {
    name = "font-alias-0.99.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/font-alias-0.99.0.tar.bz2;
      md5 = "9b8fd1bee2fdf97b980d99fed43c7ec9";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86dga = stdenv.mkDerivation {
    name = "xf86dga-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86dga-0.99.1.tar.bz2;
      md5 = "88242630e45b341b3d49eb1a60e002bb";
    };
    buildInputs = [pkgconfig libX11 libXxf86dga ];
  };
    
  fontsproto = stdenv.mkDerivation {
    name = "fontsproto-2.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/fontsproto-2.0.1.tar.bz2;
      md5 = "d52b5df46f90337e0c297e0997641d3d";
    };
    buildInputs = [pkgconfig ];
  };
    
  libSM = stdenv.mkDerivation {
    name = "libSM-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libSM-0.99.1.tar.bz2;
      md5 = "f394a6bb09fc73839d0ac99408374be5";
    };
    buildInputs = [pkgconfig libICE xproto xtrans ];
  };
    
  xf86videos3virge = stdenv.mkDerivation {
    name = "xf86-video-s3virge-1.8.6.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-s3virge-1.8.6.1.tar.bz2;
      md5 = "2d0801d02ca902781257e36fb23523cb";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xmessage = stdenv.mkDerivation {
    name = "xmessage-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmessage-0.99.1.tar.bz2;
      md5 = "27fc3265ed21b15b01402e2f9f14fd98";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86inputmutouch = stdenv.mkDerivation {
    name = "xf86-input-mutouch-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-input-mutouch-1.0.0.1.tar.bz2;
      md5 = "9ab44ed3e1c9b7149de5b7ae6efaba11";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videosuncg14 = stdenv.mkDerivation {
    name = "xf86-video-suncg14-1.0.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-suncg14-1.0.0.1.tar.bz2;
      md5 = "3b5d58b303de5902004345f5a191a803";
    };
    buildInputs = [pkgconfig xorgserver xproto ];
  };
    
  xf86videotdfx = stdenv.mkDerivation {
    name = "xf86-video-tdfx-1.1.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86-video-tdfx-1.1.0.1.tar.bz2;
      md5 = "2bfd24a0c4152793e937ac0f84da2b7e";
    };
    buildInputs = [pkgconfig xorgserver xproto libdrm xf86driproto ];
  };
    
  libXaw = stdenv.mkDerivation {
    name = "libXaw-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXaw-0.99.1.tar.bz2;
      md5 = "731f8a6407765466d1170d609137a922";
    };
    buildInputs = [pkgconfig xproto libX11 libXext libXt libXpm libXp ];
    propagatedBuildInputs = [libXmu];
  };
    
  x11perf = stdenv.mkDerivation {
    name = "x11perf-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/x11perf-0.99.1.tar.bz2;
      md5 = "4be794c83012979dfa5ba30361b38a35";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  xvinfo = stdenv.mkDerivation {
    name = "xvinfo-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xvinfo-0.99.1.tar.bz2;
      md5 = "522e1c076d4d9ff29b26b3bd1b9bd85e";
    };
    buildInputs = [pkgconfig libXv libX11 ];
  };
    
  libXfixes = stdenv.mkDerivation {
    name = "libXfixes-3.0.0";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/libXfixes-3.0.0.tar.bz2;
      md5 = "cf114cbb35ecbf895a4b72f1270d9829";
    };
    buildInputs = [pkgconfig libX11 xproto fixesproto ];
  };
    
  xconsole = stdenv.mkDerivation {
    name = "xconsole-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xconsole-0.99.1.tar.bz2;
      md5 = "c528dbcaa996ea22a12ba31d99773406";
    };
    buildInputs = [pkgconfig ];
  };
    
  xf86driproto = stdenv.mkDerivation {
    name = "xf86driproto-2.0.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xf86driproto-2.0.1.tar.bz2;
      md5 = "a0520a0b77592d26311e876ca6b209a7";
    };
    buildInputs = [pkgconfig ];
  };
    
  xmodmap = stdenv.mkDerivation {
    name = "xmodmap-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xmodmap-0.99.1.tar.bz2;
      md5 = "06f98f189698e2d8059a907545c082f6";
    };
    buildInputs = [pkgconfig libX11 ];
  };
    
  pclcomp = stdenv.mkDerivation {
    name = "pclcomp-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/pclcomp-0.99.1.tar.bz2;
      md5 = "abd6e07a362aa2bd6083654bfb05beb5";
    };
    buildInputs = [pkgconfig ];
  };
    
  xhost = stdenv.mkDerivation {
    name = "xhost-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/xhost-0.99.1.tar.bz2;
      md5 = "806ec511fa1d495c9c22dc82fd7384ee";
    };
    buildInputs = [pkgconfig libX11 libXmu ];
  };
    
  mkfontscale = stdenv.mkDerivation {
    name = "mkfontscale-0.99.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/xorg/mkfontscale-0.99.1.tar.bz2;
      md5 = "840005c72a9898383c6b5e2942a9f8bc";
    };
    buildInputs = [pkgconfig libfontenc freetype ];
  };
    
}
