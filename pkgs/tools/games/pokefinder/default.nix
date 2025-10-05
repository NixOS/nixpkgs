{
  lib,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  python3,
  qtbase,
  qttools,
  qtwayland,
  imagemagick,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pokefinder";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${version}";
    sha256 = "wjHqox0Vxc73/UTcE7LSo/cG9o4eOqkcjTIW99BxsAc=";
    fetchSubmodules = true;
  };

  patches = [
    ./set-desktop-file-name.patch
  ];

  postPatch = ''
    patchShebangs Source/Core/Resources/
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/Applications
    cp -R Source/PokeFinder.app $out/Applications
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -D Source/PokeFinder $out/bin/PokeFinder
    mkdir -p $out/share/pixmaps
    convert "$src/Source/Form/Images/pokefinder.ico[-1]" $out/share/pixmaps/pokefinder.png
  ''
  + ''
    runHook postInstall
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    python3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
    imagemagick
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "pokefinder";
      exec = "PokeFinder";
      icon = "pokefinder";
      comment = "Cross platform Pokémon RNG tool";
      desktopName = "PokéFinder";
      categories = [ "Utility" ];
    })
  ];

  buildInputs = [
    qtbase
    qttools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/Admiral-Fish/PokeFinder";
    description = "Cross platform Pokémon RNG tool";
    mainProgram = "PokeFinder";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
