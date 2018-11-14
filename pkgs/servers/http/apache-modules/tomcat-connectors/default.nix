{ stdenv, fetchurl, apacheHttpd, jdk }:

stdenv.mkDerivation rec {
  name = "tomcat-connectors-1.2.46";

  src = fetchurl {
    url = "mirror://apache/tomcat/tomcat-connectors/jk/${name}-src.tar.gz";
    sha256 = "1sfbcsmshjkj4wc969ngjcxhjyp4mbkjprbs111d1b0x3l7547by";
  };

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-java-home=${jdk}"
  ];

  setSourceRoot = ''
    sourceRoot=$(echo */native)
  '';

  installPhase = ''
    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules
  '';

  buildInputs = [ apacheHttpd jdk ];

  meta = with stdenv.lib; {
    description = "Provides web server plugins to connect web servers with Tomcat";
    homepage = https://tomcat.apache.org/download-connectors.cgi;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
