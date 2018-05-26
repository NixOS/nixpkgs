{ stdenv, fetchurl, makeDesktopItem
, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, openjdk
, libGLU_combined, openal
, useAlsa ? false, alsaOss ? null }:
with stdenv.lib;

assert useAlsa -> alsaOss != null;

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

in stdenv.mkDerivation {
  name = "minecraft-2015.07.24";

  src = fetchurl {
    url = "https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar";
    sha256 = "04pj4l5q0a64jncm2kk45r7nxnxa2z9n110dcxbbahdi6wk0png8";
  };

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out/bin
    cp -v $src $out/minecraft.jar

    cat > $out/bin/minecraft << EOF
    #!${stdenv.shell}

    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libGLU_combined openal ]}
    ${if useAlsa then "${alsaOss}/bin/aoss" else "" } \
      ${jre}/bin/java -jar $out/minecraft.jar
    EOF

    chmod +x $out/bin/minecraft

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    ${openjdk}/bin/jar xf $out/minecraft.jar favicon.png
    install -D favicon.png $out/share/icons/hicolor/32x32/apps/minecraft.png
  '';

  meta = {
      description = "A sandbox-building game";
      homepage = http://www.minecraft.net;
      maintainers = with stdenv.lib.maintainers; [ cpages ryantm ];
      license = stdenv.lib.licenses.unfreeRedistributable;
  };
}
