{ lib
, stdenv
, fetchurl
, cmake
, ninja
, p7zip
, pkg-config
, asciidoctor
, gettext

, SDL2
, libtheora
, libvorbis
, libopus
, openal
, openalSoft
, physfs
, miniupnpc
, libsodium
, curl
, libpng
, freetype
, harfbuzz
, sqlite
, which
, vulkan-headers
, vulkan-loader
, shaderc

, testers
, warzone2100
, nixosTests

, gitUpdater

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
  inherit pname;
  version  = "4.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/releases/${version}/${pname}_src.tar.xz";
    sha256 = "sha256-l4QAF+mTaWi/BNPizqpTPw0KdcrYjw71K+D325/BKdo=";
  };

  buildInputs = [
    SDL2
    libtheora
    libvorbis
    libopus
    openal
    openalSoft
    physfs
    miniupnpc
    libsodium
    curl
    libpng
    freetype
    harfbuzz
    sqlite
  ] ++ lib.optionals (!stdenv.isDarwin) [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    p7zip
    asciidoctor
    gettext
    shaderc
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
    # path, but this results in an error:
    #
    # > An absolute CMAKE_INSTALL_BINDIR path cannot be used if the following
    # > are not also absolute paths: WZ_DATADIR
    #
    # WZ_DATADIR is based on CMAKE_INSTALL_DATAROOTDIR, so we set that.
    #
    # Alternatively, we could have set CMAKE_INSTALL_BINDIR to "bin".
    "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"
  ] ++ lib.optional stdenv.isDarwin "-P../configure_mac.cmake";

  postInstall = lib.optionalString withVideos ''
    cp ${sequences_src} $out/share/warzone2100/sequences.wz
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = warzone2100;
      # The command always exits with code 1
      command = "(warzone2100 --version || [ $? -eq 1 ])";
    };
    nixosTest = nixosTests.warzone2100;
  };

  passthru.updateScript = gitUpdater {
    url = "https://github.com/Warzone2100/warzone2100";
  };

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
    homepage = "https://wz2100.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl fgaz ];
    platforms = platforms.all;
    # configure_mac.cmake tries to download stuff
    # https://github.com/Warzone2100/warzone2100/blob/master/macosx/README.md
    broken = stdenv.isDarwin;
  };
}
