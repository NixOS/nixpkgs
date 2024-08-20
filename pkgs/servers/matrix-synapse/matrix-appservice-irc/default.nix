{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, fixup-yarn-lock
, nodejs
, nodejs-slim
, matrix-sdk-crypto-nodejs
, nixosTests
, nix-update-script
, yarn
}:

let
  pname = "matrix-appservice-irc";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ue3fOkrEBRI/NRE+uKFR+NaqP8QvzVVeX3LUh4aZYJA=";
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
    fixup-yarn-lock
    nodejs-slim
    yarn
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
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/matrix-org/matrix-appservice-irc/releases/tag/${version}";
    description = "Node.js IRC bridge for Matrix";
    mainProgram = "matrix-appservice-irc";
    maintainers = with maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
