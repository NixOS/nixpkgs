{ stdenv, fetchurl, makeWrapper, jre8, which, gawk }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "neo4j-${version}";
  version = "3.1.2";

  src = fetchurl {
    url = "http://dist.neo4j.org/neo4j-community-${version}-unix.tar.gz";
    sha256 = "0kvbsm9mjwqyl3q2myif28a0f11i4rfq3hik07w9cdnrwyd75s40";
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
