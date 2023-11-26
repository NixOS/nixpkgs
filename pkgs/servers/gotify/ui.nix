{ stdenv
, yarn
, prefetch-yarn-deps
, nodejs-slim
, fetchFromGitHub
, fetchYarnDeps
, gotify-server
}:

stdenv.mkDerivation rec {
  pname = "gotify-ui";
  inherit (gotify-server) version;

  src = gotify-server.src + "/ui";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ejHzo6NHCMlNiYePWvfMY9Blb58pj3UQ5PFI0V84flI=";
  };

  nativeBuildInputs = [ yarn prefetch-yarn-deps nodejs-slim ];

  postPatch = ''
    export HOME=$NIX_BUILD_TOP/fake_home
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_OPTIONS=--openssl-legacy-provider
    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv build $out

    runHook postInstall
  '';
}
