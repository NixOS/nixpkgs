{ lib
, mkDerivation
, fetchurl
, cmake
, ninja
, zip, unzip
, pkg-config
, asciidoctor
, gettext

, qtbase
, qtscript
, SDL2
, libtheora
, libvorbis
, openal
, openalSoft
, glew
, physfs
, fribidi
, libXrandr
, miniupnpc
, libsodium
, curl
, libpng
, freetype
, harfbuzz
, sqlite
, which

, withVideos ? false
}:

let
  pname = "warzone2100";
  sequences_src = fetchurl {
    url = "mirror://sourceforge/${pname}/warzone2100/Videos/high-quality-en/sequences.wz";
    sha256 = "90ff552ca4a70e2537e027e22c5098ea4ed1bc11bb7fc94138c6c941a73d29fa";
  };
in

mkDerivation rec {
  inherit pname;
  version  = "3.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/releases/${version}/${pname}_src.tar.xz";
    sha256 = "0savalmw1kp1sf8vg5aqrl5hc77p4jacxy5y9qj8k2hi2vqdfb7a";
  };

  buildInputs = [
    qtbase
    qtscript
    SDL2
    libtheora
    libvorbis
    openal
    openalSoft
    glew
    physfs
    fribidi
    libXrandr
    miniupnpc
    libsodium
    curl
    libpng
    freetype
    harfbuzz
    sqlite
  ];

  nativeBuildInputs = [
    cmake
    ninja
    zip unzip
    asciidoctor
    gettext
  ];

  postPatch = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace '"which "' '"${which}/bin/which "'
    substituteInPlace lib/exceptionhandler/exceptionhandler.cpp \
                      --replace "which %s" "${which}/bin/which %s"
  '';

  cmakeFlags = [
    "-DWZ_DISTRIBUTOR=NixOS"
    # The cmake builder automatically sets CMAKE_INSTALL_BINDIR to an absolute
    # path, but this results in an error.
    # By resetting it, we let the CMakeLists set it to an accepted value
    # based on prefix.
    "-DCMAKE_INSTALL_BINDIR="
  ];

  postInstall = lib.optionalString withVideos ''
    cp ${sequences_src} $out/share/warzone2100/sequences.wz
  '';

  meta = with lib; {
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
    homepage = "http://wz2100.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl fgaz ];
    platforms = platforms.linux;
  };
}
