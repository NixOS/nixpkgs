{ lib, stdenv, fetchurl, jre, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "solr";
  version = "8.8.1";

  src = fetchurl {
    url = "mirror://apache/lucene/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "sha256-ALVzr9OuCj3U/3lmjuPEGTofxoGusDHamnOF+8AcHx0=";
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

  passthru.tests = {
    inherit (nixosTests) solr;
  };

  meta = with lib; {
    homepage = "https://lucene.apache.org/solr/";
    description = "Open source enterprise search platform from the Apache Lucene project";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ aanderse ];
  };

}
