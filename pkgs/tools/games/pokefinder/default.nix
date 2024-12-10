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
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${version}";
    sha256 = "R0FrRRQRe0tWrHUoU4PPwOgIsltUEImEMTXL79ISfRE=";
    fetchSubmodules = true;
  };

  patches = [
    ./set-desktop-file-name.patch
    # fix compatibility with our libstdc++
    # https://github.com/Admiral-Fish/PokeFinder/pull/392
    (fetchpatch {
      url = "https://github.com/Admiral-Fish/PokeFinder/commit/2cb1b049cabdf0d1b32c8cf29bf6c9d9c5c55cb0.patch";
      hash = "sha256-F/w7ydsZ5tZParMWi33W3Tv8A6LLiJt4dAoCrs40DIo=";
    })
  ];

  postPatch = ''
    patchShebangs Source/Core/Resources/
  '';

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString (stdenv.isDarwin) ''
      mkdir -p $out/Applications
      cp -R Source/PokeFinder.app $out/Applications
    ''
    + lib.optionalString (!stdenv.isDarwin) ''
      install -D Source/PokeFinder $out/bin/PokeFinder
      mkdir -p $out/share/pixmaps
      convert "$src/Source/Form/Images/pokefinder.ico[-1]" $out/share/pixmaps/pokefinder.png
    ''
    + ''
      runHook postInstall
    '';

  nativeBuildInputs =
    [
      cmake
      wrapQtAppsHook
      python3
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
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
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

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
