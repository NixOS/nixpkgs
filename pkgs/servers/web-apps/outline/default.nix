{ stdenv
, lib
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, yarn
, yarn2nix-moretea
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "outline";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${version}";
    hash = "sha256-Hcc/1+whRTl5ity4FgyDhNKhHED7EUU5jHUrFlmqC/k=";
  };

  nativeBuildInputs = [ makeWrapper yarn2nix-moretea.fixup_yarn_lock ];
  buildInputs = [ yarn nodejs ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-UBP7IwBpmrzmiGCmS3TFuhou6RzbBTYlPIfHY4D5cb8=";
  };

  configurePhase = ''
    export HOME=$(mktemp -d)/yarn_home

    substituteInPlace server/migrations/20230815063834-migrate-emoji-in-document-title.js \
      --replace "node " "${nodejs}/bin/node "

    substituteInPlace server/migrations/20230827234031-migrate-emoji-in-revision-title.js \
      --replace "node " "${nodejs}/bin/node "
  '';

  buildPhase = ''
    runHook preBuild
    export NODE_OPTIONS=--openssl-legacy-provider

    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup_yarn_lock yarn.lock

    yarn install --offline \
      --frozen-lockfile \
      --ignore-engines --ignore-scripts
    patchShebangs node_modules/
    # apply upstream patches with `patch-package`
    yarn run postinstall
    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/outline
    mv build server public node_modules $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build
    server=$out/share/outline/server

    makeWrapper ${nodejs}/bin/node $out/bin/outline-server \
      --add-flags $build/server/index.js \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules

    runHook postInstall
  '';

  passthru.tests = {
    basic-functionality = nixosTests.outline;
  };

  meta = with lib; {
    description = "The fastest wiki and knowledge base for growing teams. Beautiful, feature rich, and markdown compatible";
    homepage = "https://www.getoutline.com/";
    changelog = "https://github.com/outline/outline/releases";
    license = licenses.bsl11;
    maintainers = with maintainers; [ cab404 yrd xanderio ];
    platforms = platforms.linux;
  };
}
