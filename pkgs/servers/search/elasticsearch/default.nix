{ stdenv, fetchurl, makeWrapper, jre, utillinux }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "elasticsearch-1.7.2";

  src = fetchurl {
    url = "https://download.elastic.co/elasticsearch/elasticsearch/${name}.tar.gz";
    sha256 = "1lix4asvx1lbc227gzsrws3xqbcbqaal7v10w60kch0c4xg970bg";
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
      --prefix PATH : "${utillinux}/bin" \
      --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/elasticsearch-plugin \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" \
      --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.offline ];
  };
}
