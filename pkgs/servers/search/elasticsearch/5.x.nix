{ stdenv, fetchurl, makeWrapper, jre, utillinux, getopt }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "5.4.0";
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 = "1ml2dvwxxhj3azj13wa8xd08kpapal2477lpcaxzw5gnzizgyx5z";
  };

  patches = [ ./es-home-5.x.patch ./es-classpath-5.x.patch ];

  buildInputs = [ makeWrapper jre ] ++
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
      --set JAVA_HOME "${jre}" \
      --set ES_JVM_OPTIONS "$out/config/jvm.options"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre}"
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
