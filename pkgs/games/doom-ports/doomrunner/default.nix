{ lib
, stdenv
, qtbase
, qmake
, makeDesktopItem
, wrapQtAppsHook
, imagemagick
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomrunner";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "Youda008";
    repo = "DoomRunner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NpNhl3cGXpxI8Qu4l8PjojCCXCZdGBEkBzz5XxLm/mY=";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake wrapQtAppsHook imagemagick ];

  makeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/applications}
    install -Dm755 $out/usr/bin/DoomRunner $out/bin/DoomRunner

    for size in 16 24 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -background none -resize "$size"x"$size" $PWD/Resources/DoomRunner.ico -flatten $out/share/icons/hicolor/"$size"x"$size"/apps/DoomRunner.png
    done;

    install -m 444 -D "$desktopItem/share/applications/"* -t $out/share/applications/
    rm -rf $out/usr
  '';

  desktopItem = makeDesktopItem {
    name = "DoomRunner";
    desktopName = "DoomRunner";
    comment = "Preset-oriented graphical launcher of ZDoom and derivatives";
    categories = [ "Game" ];
    icon = "DoomRunner";
    type = "Application";
    exec = "DoomRunner";
  };

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
