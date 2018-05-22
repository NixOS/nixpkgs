{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "youtrack-${version}";
  version = "2018.1.41051";

  jar = fetchurl {
    url = "https://download.jetbrains.com/charisma/${name}.jar";
    sha256 = "1sznay3lbyb2i977103hzh61rw1bpkdv0raffbir68apmvv1r0rb";
  };

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/youtrack --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = ''
      Issue Tracking and Project Management Tool for Developers
    '';
    maintainers = with maintainers; [ yorickvp ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = licenses.unfree;
  };
}
