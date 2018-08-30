{ stdenv, fetchurl, elk5Version, makeWrapper, jre_headless, utillinux }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = elk5Version;
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 = "0sm99m4m4mmigj6ll22kyaw7zkp1s2i0mhzx15fzidnybdnlifb4";
  };

  patches = [ ./es-home-5.x.patch ./es-classpath-5.x.patch ];

  buildInputs = [ makeWrapper jre_headless utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod -x $out/bin/*.*

    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/*" \
      --prefix PATH : "${utillinux}/bin" \
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
