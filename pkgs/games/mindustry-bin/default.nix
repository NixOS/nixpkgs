{ stdenv, fetchurl, makeWrapper, makeDesktopItem, jdk, jre, openal, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "99";
  pname = "mindustry-bin";

  src = fetchurl {
    url = "https://github.com/Anuken/Mindustry/releases/download/v${version}/Mindustry.jar";
    sha256 = "07fhcfhw6fvxdx191rzapkpy1nhgim6k9ps6zq6iwa30gpz5685l";
  };

  desktopItem = makeDesktopItem {
    comment =  meta.description;
    name = "mindustry";
    desktopName = "Mindustry";
    genericName = "Tower Defense Game";
    categories = "Application;Games";
    icon = "mindustry";
    exec = "mindustry";
  };

  buildInputs = [ makeWrapper jdk ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/java $out/share/icons

    cp -r ${desktopItem}/share/applications $out/share/

    jar xf $src icons/icon_64.png
    cp icons/icon_64.png $out/share/icons/mindustry.png

    ln -s $src $out/share/java/mindustry.jar
    makeWrapper ${jre}/bin/java $out/bin/mindustry \
      --add-flags "-jar $out/share/java/mindustry.jar"
  '';

  meta = with stdenv.lib; {
    description = "a sandbox tower defense game written in Java";
    homepage = https://mindustrygame.github.io/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    
  };
}
