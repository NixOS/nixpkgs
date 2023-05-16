{ lib
, stdenv
, fetchzip
, glib
, jre
, makeWrapper
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "VASSAL";
<<<<<<< HEAD
  version = "3.6.19";

  src = fetchzip {
    url = "https://github.com/vassalengine/vassal/releases/download/${version}/${pname}-${version}-linux.tar.bz2";
    sha256 = "sha256-JqMX0RUx1Yndo1pkLA4YnijgkojBaelt6T7gP+CUBSI=";
=======
  version = "3.6.17";

  src = fetchzip {
    url = "https://github.com/vassalengine/vassal/releases/download/${version}/${pname}-${version}-linux.tar.bz2";
    sha256 = "sha256-hm1tgkF/SYRnoq1+ZxlgriLMQm3IX+UBR2bPYpBVp5k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    glib
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/vassal $out/doc

    cp CHANGES LICENSE README.md $out
    cp -R lib/* $out/share/vassal
    cp -R doc/* $out/doc

    makeWrapper ${jre}/bin/java $out/bin/vassal \
      --add-flags "-Duser.dir=$out -cp $out/share/vassal/Vengine.jar \
      VASSAL.launch.ModuleManager"

    runHook postInstall
  '';

  # Don't move doc to share/, VASSAL expects it to be in the root
  forceShare = [ "man" "info" ];

  meta = with lib; {
      description = "A free, open-source boardgame engine";
      homepage = "https://vassalengine.org/";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.lgpl21Only;
      maintainers = with maintainers; [ tvestelind ];
      platforms = platforms.unix;
      mainProgram = "vassal";
  };
}
