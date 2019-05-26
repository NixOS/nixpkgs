{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, jdk, jre, libpulseaudio, libXxf86vm
}:

let
  desktopItem = makeDesktopItem {
    name = "minecraft";
    exec = "minecraft";
    icon = "minecraft";
    comment = "A sandbox-building game";
    desktopName = "Minecraft";
    genericName = "minecraft";
    categories = "Game;";
  };

  libPath = stdenv.lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm # Needed only for versions <1.13
  ];

in stdenv.mkDerivation {
  name = "minecraft-2015-07-24";

  src = fetchurl {
    url = "https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar";
    sha256 = "04pj4l5q0a64jncm2kk45r7nxnxa2z9n110dcxbbahdi6wk0png8";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "${jdk}/bin/jar xf $src favicon.png";

  installPhase = ''
    mkdir -p $out/bin $out/share/minecraft

    makeWrapper ${jre}/bin/java $out/bin/minecraft \
      --add-flags "-jar $out/share/minecraft/minecraft.jar" \
      --suffix LD_LIBRARY_PATH : ${libPath}

    cp $src $out/share/minecraft/minecraft.jar
    cp -r ${desktopItem}/share/applications $out/share
    install -D favicon.png $out/share/icons/hicolor/32x32/apps/minecraft.png
  '';

  meta = with stdenv.lib; {
    description = "A sandbox-building game";
    homepage = https://minecraft.net;
    maintainers = with maintainers; [ cpages ryantm infinisil ];
    license = licenses.unfreeRedistributable;
  };
}
