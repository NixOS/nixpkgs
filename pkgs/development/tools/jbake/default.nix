{ stdenv, fetchzip, jre }:

stdenv.mkDerivation rec {
  version = "2.5.1";
  name = "jbake-${version}";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${name}-bin.zip";
    sha256 = "1ib5gvz6sl7k0ywx22anhz69i40wc6jj5lxjxj2aa14qf4lrw912";
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
