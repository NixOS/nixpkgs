{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "4.10.3";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "1dp269jka4q62qhv47j91wsrsnbxfn23lsx6qcycbijrlyh28w5c";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    cp dist/${name}.war $out/lib/solr.war
    cp -r example/lib/ext $out/lib/ext
  '';

  meta = with stdenv.lib; {
    homepage = https://lucene.apache.org/solr/;
    description = "Open source enterprise search platform from the Apache Lucene project";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.rickynils maintainers.domenkozar ];
  };

}
