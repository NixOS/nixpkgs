{ stdenv, fetchzip, jre }:

stdenv.mkDerivation rec {
  version = "2.6.1";
  name = "jbake-${version}";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${name}-bin.zip";
    sha256 = "0zlh2azmv8gj3c4d4ndivar31wd42nmvhxq6xhn09cib9kffxbc7";
  };

  buildInputs = [ jre ];

  installPhase = ''
    substituteInPlace bin/jbake --replace "java" "${jre}/bin/java" 
    mkdir -p $out
    cp -vr * $out
  '';

  meta = with stdenv.lib; {
    description = "JBake is a Java based, open source, static site/blog generator for developers & designers";
    homepage = "https://jbake.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
