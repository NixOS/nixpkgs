{ lib
, stdenv
, qtbase
, qmake
, makeDesktopItem
, wrapQtAppsHook
, imagemagick
, copyDesktopItems
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomrunner";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "Youda008";
    repo = "DoomRunner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mUtUXDcQXs5zTh9Msb3dXFicIsfbZpE9M8OPqtajDhw=";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake wrapQtAppsHook imagemagick copyDesktopItems ];

  makeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $out/bin
    install -Dm755 $out/usr/bin/DoomRunner $out/bin/DoomRunner

    for size in 16 24 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -background none -resize "$size"x"$size" $PWD/Resources/DoomRunner.ico -flatten $out/share/icons/hicolor/"$size"x"$size"/apps/DoomRunner.png
    done;

    rm -rf $out/usr
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "DoomRunner";
      desktopName = "DoomRunner";
      comment = "Preset-oriented graphical launcher of ZDoom and derivatives";
      categories = [ "Game" ];
      icon = "DoomRunner";
      type = "Application";
      exec = "DoomRunner";
    })
  ];

  meta = with lib; {
    description = "Graphical launcher of ZDoom and derivatives";
    mainProgram = "DoomRunner";
    homepage = "https://github.com/Youda008/DoomRunner/";
    changelog = "https://github.com/Youda008/DoomRunner/blob/${finalAttrs.src.rev}/changelog.txt";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ keenanweaver ];
  };
})
