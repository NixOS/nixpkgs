{ lib, fetchurl, stdenvNoCC, makeWrapper, jre }:

stdenvNoCC.mkDerivation rec {
  pname = "rars";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/TheThirdOne/rars/releases/download/v${version}/rars1_6.jar";
    hash = "sha256-eA9zDrRXsbpgnpaKzMLIt32PksPZ2/MMx/2zz7FOjCQ=";
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
