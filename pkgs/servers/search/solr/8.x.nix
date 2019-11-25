{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "solr";
  version = "8.3.0";

  src = fetchurl {
    url = "mirror://apache/lucene/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "11qkipmj8qq4gw5lwnx1j8dr2lq8d5h1v1fbdyppw8l6a68j160s";
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
    homepage = "https://lucene.apache.org/solr/";
    description = "Open source enterprise search platform from the Apache Lucene project";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ domenkozar aanderse ];
  };

}
