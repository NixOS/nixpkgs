{ stdenv, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "2.6.1";
  name = "jbake-${version}";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${name}-bin.zip";
    sha256 = "0zlh2azmv8gj3c4d4ndivar31wd42nmvhxq6xhn09cib9kffxbc7";
  };

  buildInputs = [ makeWrapper jre ];

  installPhase = ''
    mkdir -p $out
    cp -vr * $out
    wrapProgram $out/bin/jbake --set JAVA_HOME "${jre}"
  '';

  meta = with stdenv.lib; {
    description = "JBake is a Java based, open source, static site/blog generator for developers & designers";
    homepage = "https://jbake.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
