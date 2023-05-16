{ lib, fetchurl, stdenvNoCC, makeWrapper, jre }:

stdenvNoCC.mkDerivation rec {
  pname = "rars";
<<<<<<< HEAD
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/TheThirdOne/rars/releases/download/v${version}/rars1_6.jar";
    hash = "sha256-eA9zDrRXsbpgnpaKzMLIt32PksPZ2/MMx/2zz7FOjCQ=";
=======
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/TheThirdOne/rars/releases/download/v${version}/rars1_5.jar";
    sha256 = "sha256-w75gfARfR46Up6qng1GYL0u8ENfpD3xHhl/yp9lEcUE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    export JAR=$out/share/java/${pname}/${pname}.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $JAR"
    runHook postInstall
  '';

  meta = with lib; {
    description = "RISC-V Assembler and Runtime Simulator";
    homepage = "https://github.com/TheThirdOne/rars";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ athas ];
    platforms = platforms.all;
  };
}
