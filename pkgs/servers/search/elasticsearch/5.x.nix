{ stdenv, fetchurl, elk5Version, makeWrapper, jre_headless
, utillinux, gnugrep, coreutils }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = elk5Version;
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 = "0zy7awb2cm2fk3c7zc7v8b8pl0jw49awqwpa1jvilmvx6dcml0vb";
  };

  patches = [ ./es-home-5.x.patch ./es-classpath-5.x.patch ];

  buildInputs = [ makeWrapper jre_headless utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod -x $out/bin/*.*

    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/*" \
      --prefix PATH : "${makeBinPath [ utillinux gnugrep coreutils ]}" \
      --set JAVA_HOME "${jre_headless}" \
      --set ES_JVM_OPTIONS "$out/config/jvm.options"

    wrapProgram $out/bin/elasticsearch-plugin \
      --prefix ES_CLASSPATH : "$out/lib/*" \
      --set JAVA_HOME "${jre_headless}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [
      maintainers.apeschar
    ];
  };
}
