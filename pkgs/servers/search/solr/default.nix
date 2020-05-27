{ stdenv, fetchurl, jre, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "solr";
  version = "8.5.1";

  src = fetchurl {
    url = "mirror://apache/lucene/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "02sa0sldsfajryyfndv587qw69q8y8igfpimg98w1g3vndrq1dj7";
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

  meta = with stdenv.lib; {
    homepage = "https://lucene.apache.org/solr/";
    description = "Open source enterprise search platform from the Apache Lucene project";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ domenkozar aanderse ];
  };

}
