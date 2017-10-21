{ stdenv, fetchurl, makeWrapper, jre, utillinux, getopt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "elasticsearch-1.7.2";

  src = fetchurl {
    url = "https://download.elastic.co/elasticsearch/elasticsearch/${name}.tar.gz";
    sha256 = "1lix4asvx1lbc227gzsrws3xqbcbqaal7v10w60kch0c4xg970bg";
  };

  patches = [ ./es-home.patch ];

  buildInputs = [ makeWrapper jre ] ++
    (if (!stdenv.isDarwin) then [utillinux] else [getopt]);

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib $out

    # don't want to have binary with name plugin
    mv $out/bin/plugin $out/bin/elasticsearch-plugin

    # set ES_CLASSPATH and JAVA_HOME
    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*":"$out/lib/sigar/*" \
      ${if (!stdenv.isDarwin)
        then ''--prefix PATH : "${utillinux}/bin/"''
        else ''--prefix PATH : "${getopt}/bin"''} \
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
