{ lib, stdenv, fetchurl, makeWrapper, jdk11, gawk }:

stdenv.mkDerivation rec {
  pname = "youtrack";
  version = "2021.1.13597";

  jar = fetchurl {
    url = "https://download.jetbrains.com/charisma/${pname}-${version}.jar";
    sha256 = "0lc0ra95ix5bs1spfjnx5akh8jm754v8lc3yja8dc438zi221qhh";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${jdk11}/bin/java $out/bin/youtrack \
      --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar" \
      --prefix PATH : "${lib.makeBinPath [ gawk ]}" \
      --set JRE_HOME ${jdk11}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Issue tracking and project management tool for developers";
    maintainers = teams.serokell.members;
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = licenses.unfree;
  };
}
