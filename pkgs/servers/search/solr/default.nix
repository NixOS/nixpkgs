{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "7.7.0";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "1isdqb59ym4s8ajw8kbiv9v8z2kga3qcaz29mnmzq0cp8hlsm7md";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin

    cp -r bin/solr bin/post $out/bin/
    cp -r contrib $out/
    cp -r dist $out/
    cp -r example $out/
    cp -r server $out/

    wrapProgram $out/bin/solr --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/post --set JAVA_HOME "${jre}"
  '';

  meta = with stdenv.lib; {
    homepage = https://lucene.apache.org/solr/;
    description = "Open source enterprise search platform from the Apache Lucene project";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.rickynils maintainers.domenkozar maintainers.aanderse ];
  };

}
