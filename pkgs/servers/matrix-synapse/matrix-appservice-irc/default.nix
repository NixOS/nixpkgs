{ lib
<<<<<<< HEAD
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, prefetch-yarn-deps
, nodejs
, nodejs-slim
=======
, buildNpmPackage
, fetchFromGitHub
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, matrix-sdk-crypto-nodejs
, nixosTests
, nix-update-script
}:

<<<<<<< HEAD
let
  pname = "matrix-appservice-irc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wUbWvCa9xvot73nXZjF3/RawM98ffBCW5YR2+ZKzmEo=";
  };

  yarnOfflineCache = fetchYarnDeps {
    name = "${pname}-${version}-offline-cache";
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-P9u5sK9rIHWRE8kFMj05fVjv26jwsawvHBZgSn7j5BE=";
  };

in
stdenv.mkDerivation {
  inherit pname version src yarnOfflineCache;

  strictDeps = true;

  nativeBuildInputs = [
    prefetch-yarn-deps
    nodejs-slim
    nodejs.pkgs.yarn
    nodejs.pkgs.node-gyp-build
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
=======
buildNpmPackage rec {
  pname = "matrix-appservice-irc";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = "refs/tags/${version}";
    hash = "sha256-rV4B9OQl1Ht26X4e7sqCe1PR5RpzIcjj4OvWG6udJWo=";
  };

  npmDepsHash = "sha256-iZuPr3a1BPtRfkEoxOs4oRL/nCfy3PLx5T9dX49/B0s=";

  nativeBuildInputs = [
    python3
  ];

  postInstall = ''
    rm -rv $out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
