{ stdenv, fetchurl, apacheHttpd, jdk }:

stdenv.mkDerivation rec {
  name = "tomcat-connectors-1.2.41-dev-1613051";

  src = fetchurl {
    url = "http://people.apache.org/~rjung/mod_jk-dev/${name}-src.tar.gz";
    sha256 = "11khipjpy3y84j1pp7yyx76y64jccvyhh3klwzqxylff49vjc2fc";
  };

  configureFlags = "--with-apxs=${apacheHttpd.dev}/bin/apxs --with-java-home=${jdk}";

  sourceRoot = "${name}-src/native";

  installPhase = ''
    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules
  '';

  buildInputs = [ apacheHttpd jdk ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
