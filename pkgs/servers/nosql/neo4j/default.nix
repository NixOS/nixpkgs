{ stdenv, fetchurl, makeWrapper, jre8, which, gawk }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "neo4j-${version}";
  version = "3.4.10";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    sha256 = "0wxcwsnnwk08w3zaz67aa93ysrl61lsy41xynq1sy6z31a7gx9jr";
  };

  buildInputs = [ makeWrapper jre8 which gawk ];

  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    for NEO4J_SCRIPT in neo4j neo4j-admin neo4j-import neo4j-shell cypher-shell
    do
        makeWrapper "$out/share/neo4j/bin/$NEO4J_SCRIPT" \
            "$out/bin/$NEO4J_SCRIPT" \
            --prefix PATH : "${stdenv.lib.makeBinPath [ jre8 which gawk ]}" \
            --set JAVA_HOME "$jre8"
    done
  '';

  meta = with stdenv.lib; {
    description = "A highly scalable, robust (fully ACID) native graph database";
    homepage = http://www.neo4j.org/;
    license = licenses.gpl3;

    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.unix;
  };
}
