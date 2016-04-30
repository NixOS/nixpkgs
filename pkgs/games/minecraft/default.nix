{ stdenv, fetchurl, makeDesktopItem
, jre, libX11, libXext, libXcursor, libXrandr, libXxf86vm
, mesa, openal
, useAlsa ? false, alsaOss ? null }:
with stdenv.lib;

assert useAlsa -> alsaOss != null;

let
  icon = fetchurl {
    url = "https://hydra-media.cursecdn.com/minecraft.gamepedia.com/c/c5/Grass.png";
    sha256 = "438c0f63e379e92af1b5b2e06cc5e3365ee272810af65ebc102304bce4fa8c4b";
  };

  desktopItem = makeDesktopItem {
    name = "minecraft";
    exec = "minecraft";
    icon = "${icon}";
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

    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm mesa openal ]}
    ${if useAlsa then "${alsaOss}/bin/aoss" else "" } \
      ${jre}/bin/java -jar $out/minecraft.jar
    EOF

    chmod +x $out/bin/minecraft

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = {
      description = "A sandbox-building game";
      homepage = http://www.minecraft.net;
      maintainers = with stdenv.lib.maintainers; [ page ryantm ];
      license = stdenv.lib.licenses.unfreeRedistributable;
  };
}
