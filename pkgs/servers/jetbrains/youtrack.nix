{ lib, stdenv, fetchurl, makeWrapper, jdk17, gawk }:

stdenv.mkDerivation rec {
  pname = "youtrack";
  version = "2021.4.35970";

  jar = fetchurl {
    url = "https://download.jetbrains.com/charisma/${pname}-${version}.jar";
    sha256 = "sha256-HB515TS0XXEAiT463nVHP/naeoF7nmeB+6EK0NJ+5c0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${jdk17}/bin/java $out/bin/youtrack \
      --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar" \
      --prefix PATH : "${lib.makeBinPath [ gawk ]}" \
      --set JRE_HOME ${jdk17}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Issue tracking and project management tool for developers";
    maintainers = teams.serokell.members;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = licenses.unfree;
  };
}
