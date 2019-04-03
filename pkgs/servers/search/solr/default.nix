{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "solr";
  version = "8.0.0";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "04hxj7nfmbh5wfqkq1p5q2ncxszwm80l218vfdy93aw0p79r4qqf";
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
