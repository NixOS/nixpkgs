{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "4.7.0";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "0qm3pnhpfqjxdl0xiwffrcchp79q3ja5w5d278bkkxglc2y1y4xc";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    cp dist/${name}.war $out/lib/solr.war
    cp -r example/lib/ext $out/lib/ext
  '';

  meta = {
    homepage = "https://lucene.apache.org/solr/";
    description = ''
      Open source enterprise search platform from the Apache Lucene project
    '';
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };

}
