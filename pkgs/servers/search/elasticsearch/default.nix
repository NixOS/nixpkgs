{ stdenv, fetchurl, makeWrapper, jre, utillinux }:
stdenv.mkDerivation rec {
  name = "elasticsearch-0.90.3";

  src = fetchurl {
    url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${name}.tar.gz";
    sha256 = "1l6rnp4yvlz4z6z4v3af08yd4sl91c4zz20a8yyif2p234lh3n2s";
  };

  patches = [ ./es-home.patch ];

  buildInputs = [ makeWrapper jre utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib $out

    # don't want to have binary with name plugin
    mv $out/bin/plugin $out/bin/elasticsearch-plugin

    # set ES_CLASSPATH and JAVA_HOME
    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" \
      --prefix PATH : "${utillinux}/bin/" \
      --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/elasticsearch-plugin \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = "ASL2.0";
  };
}
