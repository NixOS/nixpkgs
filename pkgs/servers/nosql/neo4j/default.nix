{ stdenv, fetchurl, makeWrapper, jre, which, gnused }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "neo4j-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = "http://dist.neo4j.org/neo4j-community-${version}-unix.tar.gz";
    sha256 = "1n98b022w5bsvg3cd8sr57q66pdmnqvh246xw8pa85jm0marqm81";
  };

  buildInputs = [ makeWrapper jre which gnused ];

  patchPhase = ''
    substituteInPlace "bin/neo4j" --replace "NEO4J_INSTANCE=\$NEO4J_HOME" ""
  '';

  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    makeWrapper "$out/share/neo4j/bin/neo4j" "$out/bin/neo4j" \
        --prefix PATH : "${jre}/bin:${which}/bin:${gnused}/bin"
    makeWrapper "$out/share/neo4j/bin/neo4j-shell" "$out/bin/neo4j-shell" \
        --prefix PATH : "${jre}/bin:${which}/bin:${gnused}/bin"
  '';

  meta = with stdenv.lib; {
    description = "a highly scalable, robust (fully ACID) native graph database";
    homepage = "http://www.neo4j.org/";
    license = licenses.gpl3;

    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.unix;
  };
}
