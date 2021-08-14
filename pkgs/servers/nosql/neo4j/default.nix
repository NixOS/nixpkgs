{ lib, stdenv, fetchurl, makeWrapper, jre, which, gawk, bashInteractive }:

stdenv.mkDerivation rec {
  pname = "neo4j";
  version = "4.3.2";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    sha256 = "3474f3ec9da57fb627af71652ae6ecbd036e6ea689379f09e77e4cd8ba4b5515";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"

    compgen_wrapper="$out/share/neo4j/bin/compgen"
    cat > $compgen_wrapper << _EOF_
    "${bashInteractive}/bin/bash" -c 'compgen "\$@"'
    _EOF_
    chmod +x $compgen_wrapper

    for NEO4J_SCRIPT in neo4j neo4j-admin cypher-shell
    do
        makeWrapper "$out/share/neo4j/bin/$NEO4J_SCRIPT" \
            "$out/bin/$NEO4J_SCRIPT" \
            --prefix PATH : "${lib.makeBinPath [ jre which gawk ]}:$out/share/neo4j/bin/" \
            --set JAVA_HOME "${jre}"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A highly scalable, robust (fully ACID) native graph database";
    homepage = "https://www.neo4j.org/";
    license = licenses.gpl3Only;

    maintainers = [ maintainers.offline ];
    platforms = lib.platforms.unix;
  };
}
