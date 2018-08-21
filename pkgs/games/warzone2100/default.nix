{ stdenv, lib, fetchurl, perl, unzip, zip, which, pkgconfig
, qtbase, qtscript, SDL2, libtheora, openal, glew, physfs, fribidi, libXrandr
, withVideos ? false
}:

let
  pname = "warzone2100";
  sequences_src = fetchurl {
    url = "mirror://sourceforge/${pname}/warzone2100/Videos/high-quality-en/sequences.wz";
    sha256 = "90ff552ca4a70e2537e027e22c5098ea4ed1bc11bb7fc94138c6c941a73d29fa";
  };
in

stdenv.mkDerivation rec {
  version = "3.2.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/releases/${version}/${name}.tar.xz";
    sha256 = "10kmpr4cby95zwqsl1zwx95d9achli6khq7flv6xmrq30a39xazw";
  };

  buildInputs = [ qtbase qtscript SDL2 libtheora openal glew physfs fribidi libXrandr ];
  nativeBuildInputs = [ perl zip unzip pkgconfig ];

  postPatch = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace "which %s" "${which}/bin/which %s"
    substituteInPlace lib/exceptionhandler/exceptionhandler.cpp \
                      --replace "which %s" "${which}/bin/which %s"
  '';

  preConfigure = ''
    CC=${stdenv.cc.targetPrefix}cc
    CXX=${stdenv.cc.targetPrefix}c++
  '';

  configureFlags = [ "--with-distributor=NixOS" ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString withVideos "cp ${sequences_src} $out/share/warzone2100/sequences.wz";

  meta = with stdenv.lib; {
    description = "A free RTS game, originally developed by Pumpkin Studios";
    longDescription = ''
        Warzone 2100 is an open source real-time strategy and real-time tactics
      hybrid computer game, originally developed by Pumpkin Studios and
      published by Eidos Interactive.
        In Warzone 2100, you command the forces of The Project in a battle to
      rebuild the world after mankind has almost been destroyed by nuclear
      missiles. The game offers campaign, multi-player, and single-player
      skirmish modes. An extensive tech tree with over 400 different
      technologies, combined with the unit design system, allows for a wide
      variety of possible units and tactics.
    '';
    homepage = http://wz2100.net;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
