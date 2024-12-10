{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  testers,
  opensupaplex,
  SDL2,
  SDL2_mixer,
}:

let
  # Doesn't seem to be included in tagged releases, but does exist on master.
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/sergiou87/open-supaplex/b102548699cf16910b59559f689ecfad88d2a7d2/open-supaplex.svg";
    sha256 = "sha256-nKeSBUGjSulbEP7xxc6smsfCRjyc/xsLykH0o3Rq5wo=";
  };
in
stdenv.mkDerivation rec {
  pname = "opensupaplex";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "sergiou87";
    repo = "open-supaplex";
    rev = "v${version}";
    sha256 = "sha256-hP8dJlLXE5J/oxPhRkrrBl1Y5e9MYbJKi8OApFM3+GU=";
  };

  nativeBuildInputs = [
    SDL2 # For "sdl2-config"
    copyDesktopItems
  ];
  buildInputs = [ SDL2_mixer ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-DFILE_DATA_PATH=${placeholder "out"}/lib/opensupaplex"
    "-DFILE_FHS_XDG_DIRS"
  ];

  preBuild = ''
    # Makefile is located in this directory
    pushd linux
  '';

  postBuild = ''
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,share/icons/hicolor/scalable/apps}

    install -D ./linux/opensupaplex $out/bin/opensupaplex
    cp -R ./resources $out/lib/opensupaplex
    cp ${icon} $out/share/icons/hicolor/scalable/apps/open-supaplex.svg

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = opensupaplex;
    command = "opensupaplex --help";
    version = "v${version}";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "opensupaplex";
      exec = meta.mainProgram;
      icon = "open-supaplex";
      desktopName = "OpenSupaplex";
      comment = meta.description;
      categories = [
        "Application"
        "Game"
      ];
    })
  ];

  meta = with lib; {
    description = "A decompilation of Supaplex in C and SDL";
    homepage = "https://github.com/sergiou87/open-supaplex";
    changelog = "https://github.com/sergiou87/open-supaplex/blob/master/changelog/v${version}.txt";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux; # Many more are supported upstream, but only linux is tested.
    mainProgram = "opensupaplex";
  };
}
