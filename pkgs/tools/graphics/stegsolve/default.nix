{ lib, stdenv, fetchurl, jre, makeWrapper, copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "stegsolve";
  version = "1.3";

  src = fetchurl {
    # No versioned binary is published :(
    url = "http://www.caesum.com/handbook/Stegsolve.jar";
    sha256 = "0np5zb28sg6yzkp1vic80pm8iiaamvjpbf5dxmi9kwvqcrh4jyq0";
  };

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = pname;
      desktopName = "Stegsolve";
      comment = "A steganographic image analyzer, solver and data extractor for challanges";
      exec = pname;
      categories = [ "Graphics" ];
    })
  ];

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/stegsolve/stegsolve.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/stegsolve \
      --add-flags "-jar $JAR"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A steganographic image analyzer, solver and data extractor for challanges";
    homepage = "http://www.caesum.com/handbook/stego.htm";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
