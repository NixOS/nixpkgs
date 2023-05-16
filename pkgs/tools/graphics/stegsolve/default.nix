<<<<<<< HEAD
{ lib
, stdenvNoCC
, fetchurl
, jre
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:

stdenvNoCC.mkDerivation (finalAttrs: {
=======
{ lib, stdenv, fetchurl, jre, makeWrapper, copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "stegsolve";
  version = "1.3";

  src = fetchurl {
    # No versioned binary is published :(
<<<<<<< HEAD
    url = "https://web.archive.org/web/20230319054116if_/http://www.caesum.com/handbook/Stegsolve.jar";
=======
    url = "http://www.caesum.com/handbook/Stegsolve.jar";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "0np5zb28sg6yzkp1vic80pm8iiaamvjpbf5dxmi9kwvqcrh4jyq0";
  };

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
<<<<<<< HEAD
      name = finalAttrs.pname;
      desktopName = "Stegsolve";
      comment = "A steganographic image analyzer, solver and data extractor for challanges";
      exec = finalAttrs.pname;
=======
      name = pname;
      desktopName = "Stegsolve";
      comment = "A steganographic image analyzer, solver and data extractor for challanges";
      exec = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
  };
})
=======
    homepage = "http://www.caesum.com/handbook/stego.htm";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
