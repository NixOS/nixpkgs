{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "4.10.2";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "07wwfgwcca3ndjrkfk7qyc4q8bdhwr0s6h4ijl4sqdy65aqcc6qh";
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
