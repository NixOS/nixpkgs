{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "solr-${version}";
  version = "7.6.0";

  src = fetchurl {
    url = "mirror://apache/lucene/solr/${version}/solr-${version}.tgz";
    sha256 = "1marwyn7r85k5j28vwkl9n942gp52kjh6s1hbm357w8gnfh2bd1c";
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
