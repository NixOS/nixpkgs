{ stdenv, fetchurl, makeWrapper, jre, utillinux }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.4.4";
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${version}/${name}.tar.gz";
    sha256 = "1qjq04sfqb35pf2xpvr8j5p27chfxpjp8ymrp1h5bfk5rbk9444q";
  };

  patches = [ ./es-home-2.x.patch ./es-classpath-2.x.patch ];

  buildInputs = [ makeWrapper jre utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules $out

    # don't want to have binary with name plugin
    mv $out/bin/plugin $out/bin/elasticsearch-plugin
    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/${name}.jar":"$out/lib/*" \
      --prefix PATH : "${utillinux}/bin" \
      --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [
      maintainers.offline
      maintainers.markWot
    ];
  };
}
