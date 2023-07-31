{ stdenv
, lib
, coreutils
, fetchzip
, findutils
, gawk
, gnugrep
, gnused
, jdk11_headless
, makeWrapper
}:

let
  binPath = lib.makeBinPath [
    coreutils
    findutils
    gawk
    gnugrep
    gnused
  ];
in

stdenv.mkDerivation (finalAttr: {
  pname = "janusgraph";
  version = "0.6.3";

  src = fetchzip {
    url = "https://github.com/JanusGraph/janusgraph/releases/download/v${finalAttr.version}/janusgraph-${finalAttr.version}.zip";
    sha256 = "sha256-KpGvDfQExU6pHheqmcOFoAhHdF4P+GBQu779h+/L5mE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/bin

      cp -r $src/{conf,data,ext,lib,scripts} $out
      cp $src/bin/janusgraph-server.sh $out/bin/janusgraph-server
      cp $src/bin/gremlin.sh $out/bin/gremlin

      sed -i '1 a set -o errexit -o pipefail' $out/bin/janusgraph-server

      wrapProgram $out/bin/janusgraph-server \
        --set JAVA_HOME ${jdk11_headless} \
        --prefix PATH : ${binPath}

      wrapProgram $out/bin/gremlin \
        --set JAVA_HOME ${jdk11_headless} \
        --prefix PATH : ${binPath}

      runHook postInstall
    '';

  doInstallCheck = true;

  installCheckPhase =
    ''
      runHook preInstallCheck

      (export PATH="${binPath}"
      $out/bin/janusgraph-server config)

      runHook postInstallCheck
    '';

  meta = with lib; {
    description = "An open-source, distributed graph database";
    homepage = "https://janusgraph.org/";
    mainProgram = "janusgraph-server";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ners ];
  };
})
