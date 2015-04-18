{ stdenv, fetchurl, apacheHttpd, jdk }:

stdenv.mkDerivation rec {
  name = "tomcat-connectors-1.2.40";

  src = fetchurl {
    url = "http://www.apache.si/tomcat/tomcat-connectors/jk/${name}-src.tar.gz";
    sha256 = "0pbh6s19ba5k2kahiiqgx8lz8v4fjllzn0w6hjd08x7z9my38pl9";
  };

  configureFlags = "--with-apxs=${apacheHttpd}/bin/apxs --with-java-home=${jdk}";

  sourceRoot = "${name}-src/native";

  installPhase = ''
    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules
  '';

  buildInputs = [ apacheHttpd jdk ];
}
