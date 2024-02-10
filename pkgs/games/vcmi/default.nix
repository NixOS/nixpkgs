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
, fuzzylite
, innoextract
, luajit
, minizip
, ninja
, pkg-config
, python3
, qtbase
, qttools
, tbb
, unshield
, wrapQtAppsHook
, zlib
, testers
, vcmi
}:

stdenv.mkDerivation rec {
  pname = "vcmi";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "vcmi";
    repo = "vcmi";
    rev = version;
    hash = "sha256-nyYzG0O7tZwo77r7QwenVgaTffZ3ELEyUrkZmdvwm/w=";
  };

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
    fuzzylite
    luajit
    minizip
    qtbase
    qttools
    tbb
    zlib
  ];

  cmakeFlags = [
    "-DENABLE_LUA:BOOL=ON"
    "-DENABLE_ERM:BOOL=ON"
    "-DENABLE_GITVERSION:BOOL=OFF"
    "-DENABLE_PCH:BOOL=OFF"
    "-DENABLE_TEST:BOOL=OFF" # Tests require HOMM3 data files.
    "-DFORCE_BUNDLED_MINIZIP:BOOL=OFF"
    "-DFORCE_BUNDLED_FL:BOOL=OFF"
    "-DCMAKE_INSTALL_RPATH:STRING=$out/lib/vcmi"
    "-DCMAKE_INSTALL_BINDIR:STRING=bin"
    "-DCMAKE_INSTALL_LIBDIR:STRING=lib"
    "-DCMAKE_INSTALL_DATAROOTDIR:STRING=share"
  ];

  postFixup = ''
    wrapProgram $out/bin/vcmibuilder \
      --prefix PATH : "${lib.makeBinPath [ innoextract ffmpeg unshield ]}"
  '';

  passthru.tests.version = testers.testVersion {
    package = vcmi;
    command = ''
      XDG_DATA_HOME="$TMPDIR" XDG_CACHE_HOME="$TMPDIR" XDG_CONFIG_HOME="$TMPDIR" \
        vcmiclient --version
    '';
  };

  meta = with lib; {
    description = "An open-source engine for Heroes of Might and Magic III";
    homepage = "https://vcmi.eu";
    changelog = "https://github.com/vcmi/vcmi/blob/${src.rev}/ChangeLog.md";
    license = with licenses; [ gpl2Plus cc-by-sa-40 ];
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
    mainProgram = "vcmilauncher";
  };
}
