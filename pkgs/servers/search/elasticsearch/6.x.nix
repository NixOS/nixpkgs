{ stdenv, fetchurl, elk6Version, makeWrapper, jre_headless, utillinux }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = elk6Version;
  name = "elasticsearch-${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 = "13hf00khq33yw6zv022vcrsf6vm43isx40x7ww8r1lqx3vmg3rli";
  };

  patches = [ ./es-home-6.x.patch ];

  postPatch = ''
    sed -i "s|ES_CLASSPATH=\"\$ES_HOME/lib/\*\"|ES_CLASSPATH=\"$out/lib/*\"|" ./bin/elasticsearch-env
  '';

  buildInputs = [ makeWrapper jre_headless utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod -x $out/bin/*.*

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${utillinux}/bin/" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
}
