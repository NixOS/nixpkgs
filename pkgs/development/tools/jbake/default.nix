{ stdenv, fetchzip, jre }:

stdenv.mkDerivation rec {
  version = "2.6.0";
  name = "jbake-${version}";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${name}-bin.zip";
    sha256 = "1k71rz82fwyi51xhyghg8laz794xyz06d5apmxa9psy7yz184ylk";
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
