{ stdenv, fetchurl, makeWrapper, jre, gawk }:

stdenv.mkDerivation rec {
  name = "youtrack-${version}";
  version = "2018.2.44329";

  jar = fetchurl {
    url = "https://download.jetbrains.com/charisma/${name}.jar";
    sha256 = "1fnnpyikr1x443vxy6f7vlv550sbahpps8awyn13jpg7kpgfm7lk";
  };

  buildInputs = [ makeWrapper ];

  unpackPhase = ":";

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/youtrack \
      --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gawk ]}" \
      --set JRE_HOME ${jre}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Issue tracking and project management tool for developers";
    maintainers = with maintainers; [ yorickvp ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = licenses.unfree;
  };
}
