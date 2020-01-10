{ stdenv
, fetchFromGitHub
, buildGradle
, jre
, makeWrapper
, xorg
, openal
, makeDesktopItem
}:

buildGradle rec {
  pname = "shattered-pixel-dungeon";
  version = "0.7.5f";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon-gdx";
    rev = "v${version}";
    sha256 = "05awbbc7np9li50shdbpv9dgdgry6lra8d5gibwn578m2g9srbxx";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "$out/bin/shattered-pixel-dungeon";
    icon = "shattered-pixel-dungeon";
    comment = meta.description;
    desktopName = "Shattered Pixel Dungeon";
    genericName = "Roguelike Game";
    categories = "Game;";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];
  envSpec = ./gradle-env.json;
  gradleFlags = [ "desktop:dist" ];

  installPhase = ''
    install -Dm644 desktop/build/libs/desktop-${version}.jar $out/share/shattered-pixel-dungeon.jar
    install -Dm644 android/res/drawable-xxxhdpi/ic_launcher.png $out/share/icons/hicolor/192x192/apps/shattered-pixel-dungeon.png
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/shattered-pixel-dungeon \
      --prefix LD_LIBRARY_PATH : ${xorg.libXxf86vm}/lib:${openal}/lib \
      --add-flags "-jar $out/share/shattered-pixel-dungeon.jar"
    ${desktopItem.buildCommand}
  '';

  meta = with stdenv.lib; {
    homepage = "https://shatteredpixel.com/";
    downloadPage = "https://github.com/00-Evan/shattered-pixel-dungeon-gdx/releases";
    description = "Traditional roguelike game with pixel-art graphics and simple interface";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

