{ stdenv, fetchurl, makeWrapper, jre, which, gnused, gawk, bashCompletion }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "neo4j-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "http://dist.neo4j.org/neo4j-community-${version}-unix.tar.gz";
    sha256 = "01g88b9b1510jbks9v4xr4hyw8zy9nivxsl86xi810xi7qb53np1";
  };

  buildInputs = [ makeWrapper jre which gnused ];

  patchPhase = ''
    substituteInPlace "bin/neo4j" --replace "NEO4J_INSTANCE=\$NEO4J_HOME" ""
  '';

  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    substituteInPlace $out/share/neo4j/bin/neo4j \
        --replace compgen ${bashCompletion}/share/bash-completion/completions/compgen
    makeWrapper "$out/share/neo4j/bin/neo4j" "$out/bin/neo4j" \
        --prefix PATH : "${stdenv.lib.makeBinPath [ jre which gnused gawk ]}"
    makeWrapper "$out/share/neo4j/bin/neo4j-shell" "$out/bin/neo4j-shell" \
        --prefix PATH : "${stdenv.lib.makeBinPath [ jre which gnused gawk ]}"
  '';

  meta = with stdenv.lib; {
    description = "A highly scalable, robust (fully ACID) native graph database";
    homepage = "http://www.neo4j.org/";
    license = licenses.gpl3;

    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.unix;
  };
}
