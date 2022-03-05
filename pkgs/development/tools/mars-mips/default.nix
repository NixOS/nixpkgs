{ lib, stdenvNoCC, fetchurl, makeWrapper, copyDesktopItems, makeDesktopItem, unzip, imagemagick, jre }:

stdenvNoCC.mkDerivation rec {
  pname = "mars-mips";
  version = "4.5";

  src = fetchurl {
    url = "https://courses.missouristate.edu/KenVollmar/MARS/MARS_${lib.replaceStrings ["."] ["_"] version}_Aug2014/Mars${lib.replaceStrings ["."] ["_"] version}.jar";
    sha256 = "15kh1fahkkbbf4wvb6ijzny4fi5dh4pycxyzp5325dm2ddkhnd5c";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems unzip imagemagick ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "MARS";
      exec = "mars-mips";
      icon = "mars-mips";
      comment = "An IDE for programming in MIPS assembly language";
      categories = [ "Development" "IDE" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/${pname}/${pname}.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $JAR"

    unzip ${src} images/MarsThumbnail.gif
    mkdir -p $out/share/pixmaps
    convert images/MarsThumbnail.gif $out/share/pixmaps/mars-mips.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "An IDE for programming in MIPS assembly language intended for educational-level use";
    homepage = "https://courses.missouristate.edu/KenVollmar/MARS/";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
