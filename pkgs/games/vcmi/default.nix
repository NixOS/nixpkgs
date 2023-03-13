{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, boost
, cmake
, ffmpeg
, innoextract
, luajit
, minizip
, ninja
, pkg-config
, python3
, qtbase
, tbb
, wrapQtAppsHook
, zlib
, testers
, vcmi
}:

stdenv.mkDerivation rec {
  pname = "vcmi";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "vcmi";
    repo = "vcmi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-/BHpAXOCLi6d0+/uE79g8p6YO1swizItAwVlPVf/nkQ=";
  };

  postPatch = ''
    substituteInPlace Version.cpp.in \
      --subst-var-by GIT_SHA1 "0000000";
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    boost
    ffmpeg
    luajit
    minizip
    qtbase
    tbb
    zlib
  ];

  cmakeFlags = [
    "-DENABLE_TEST:BOOL=NO"
    "-DENABLE_PCH:BOOL=NO"
    # Make libvcmi.so discoverable in a non-standard location.
    "-DCMAKE_INSTALL_RPATH:STRING=${placeholder "out"}/lib/vcmi"
    # Upstream assumes relative value while Nixpkgs passes absolute.
    # Both should be allowed: https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
    # Meanwhile work it around by passing a relative value.
    "-DCMAKE_INSTALL_BINDIR:STRING=bin"
    "-DCMAKE_INSTALL_LIBDIR:STRING=lib"
    "-DCMAKE_INSTALL_DATAROOTDIR:STRING=share"
  ];

  postFixup = ''
    wrapProgram $out/bin/vcmibuilder \
      --prefix PATH : "${lib.makeBinPath [ innoextract ]}"
  '';

  passthru.tests.version = testers.testVersion {
    package = vcmi;
    command = ''
      XDG_DATA_HOME=$PWD XDG_CACHE_HOME=$PWD XDG_CONFIG_HOME=$PWD \
        vcmiclient --version
    '';
  };

  meta = with lib; {
    description = "Open-source engine for Heroes of Might and Magic III";
    homepage = "https://vcmi.eu";
    changelog = "https://github.com/vcmi/vcmi/blob/${src.rev}/ChangeLog";
    license = with licenses; [ gpl2Only cc-by-sa-40 ];
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
    mainProgram = "vcmiclient";
  };
}
