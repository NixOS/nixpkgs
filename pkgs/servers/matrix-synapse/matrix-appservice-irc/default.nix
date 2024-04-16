{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, prefetch-yarn-deps
, nodejs_20
, nodejs-slim_20
, matrix-sdk-crypto-nodejs
, nixosTests
, nix-update-script
}:

let
  pname = "matrix-appservice-irc";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-voZJVBggsuwmGw/imt2HYmqiYBkRYMpppt/Nemh6fsM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    name = "${pname}-${version}-offline-cache";
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-hapEbdjvvzeZHfrpYRW9W3vXkQVNyGZ0qydO34+mQqQ=";
  };

in
stdenv.mkDerivation {
  inherit pname version src yarnOfflineCache;

  strictDeps = true;

  nativeBuildInputs = [
    prefetch-yarn-deps
    nodejs-slim_20
    nodejs_20.pkgs.yarn
    nodejs_20.pkgs.node-gyp-build
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts
    patchShebangs node_modules/ bin/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp package.json $out
    cp app.js config.schema.yml $out
    cp -r bin lib public $out

    # prune dependencies to production only
    yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts --production
    cp -r node_modules $out

    # replace matrix-sdk-crypto-nodejs with nixos package
    rm -rv $out/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/node_modules/@matrix-org/

    runHook postInstall
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/matrix-org/matrix-appservice-irc/releases/tag/${version}";
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
