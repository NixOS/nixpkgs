{ stdenv, fetchurl, elk5Version, makeWrapper, jre_headless, utillinux, getopt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = elk5Version;
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 = "0wjjvzjbdgdv9qznk1b8dx63zgs7s6jnrrbrnd5dn27lhymxiwpl";
  };

  patches = [ ./es-home-5.x.patch ./es-classpath-5.x.patch ];

  buildInputs = [ makeWrapper jre_headless ] ++
    (if (!stdenv.isDarwin) then [utillinux] else [getopt]);

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod -x $out/bin/*.*

    wrapProgram $out/bin/elasticsearch \
      --prefix ES_CLASSPATH : "$out/lib/*" \
      ${if (!stdenv.isDarwin)
        then ''--prefix PATH : "${utillinux}/bin/"''
        else ''--prefix PATH : "${getopt}/bin"''} \
      --set JAVA_HOME "${jre_headless}" \
      --set ES_JVM_OPTIONS "$out/config/jvm.options"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
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
