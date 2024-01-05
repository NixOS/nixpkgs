{ stdenv, lib, fetchurl, nixosTests, makeWrapper, openjdk21, which, gawk }:

stdenv.mkDerivation rec {
  pname = "neo4j";
  version = "5.15.0";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    sha256 = "sha256-AJDuX9jKVxjO0QfV56eAORn1W5cMPnrK2Dv4gpKiNh8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    for NEO4J_SCRIPT in neo4j neo4j-admin cypher-shell
    do
        chmod +x "$out/share/neo4j/bin/$NEO4J_SCRIPT"
        makeWrapper "$out/share/neo4j/bin/$NEO4J_SCRIPT" \
            "$out/bin/$NEO4J_SCRIPT" \
            --prefix PATH : "${lib.makeBinPath [ openjdk21 which gawk ]}" \
            --set JAVA_HOME "${openjdk21}"
    done

    patchShebangs $out/share/neo4j/bin/neo4j-admin
    # user will be asked to change password on first login
    $out/bin/neo4j-admin set-initial-password neo4j
  '';

  passthru.tests.nixos = nixosTests.neo4j;

  meta = with lib; {
    description = "A highly scalable, robust (fully ACID) native graph database";
    homepage = "https://neo4j.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonringer offline ];
    platforms = platforms.unix;
  };
}
