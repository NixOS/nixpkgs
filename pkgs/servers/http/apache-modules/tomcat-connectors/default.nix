{ stdenv, fetchurl, apacheHttpd, jdk8 }:

stdenv.mkDerivation rec {
  name = "tomcat-connectors-1.2.48";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/jk/${name}-src.tar.gz";
    sha256 = "15wfj1mvad15j1fqw67qbpbpwrcz3rb0zdhrq6z2sax1l05kc6yb";
  };

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-java-home=${jdk8}"
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */native)
  '';

  installPhase = ''
    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules
  '';

  buildInputs = [ apacheHttpd jdk8 ];

  meta = with stdenv.lib; {
    description = "Provides web server plugins to connect web servers with Tomcat";
    homepage = "https://tomcat.apache.org/download-connectors.cgi";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
