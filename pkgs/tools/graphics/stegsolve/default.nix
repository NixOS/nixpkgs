{ lib
, stdenvNoCC
, fetchurl
, jre
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stegsolve";
  version = "1.3";

  src = fetchurl {
    # No versioned binary is published :(
    url = "https://web.archive.org/web/20230319054116if_/http://www.caesum.com/handbook/Stegsolve.jar";
    sha256 = "0np5zb28sg6yzkp1vic80pm8iiaamvjpbf5dxmi9kwvqcrh4jyq0";
  };

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = finalAttrs.pname;
      desktopName = "Stegsolve";
      comment = "A steganographic image analyzer, solver and data extractor for challanges";
      exec = finalAttrs.pname;
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
    description = "Steganographic image analyzer, solver and data extractor for challanges";
    homepage = "https://www.wechall.net/forum/show/thread/527/Stegsolve_1.3/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = {
      fullName = "Cronos License";
      url = "http://www.caesum.com/legal.php";
      free = false;
      redistributable = true;
    };
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
    mainProgram = "stegsolve";
  };
})
