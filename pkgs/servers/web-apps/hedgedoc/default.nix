{ lib
, stdenv
, fetchFromGitHub
, gitMinimal
, cacert
, yarn
, makeBinaryWrapper
, nodejs
, python3
, nixosTests
}:

let
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "hedgedoc";
    rev = version;
    hash = "sha256-cRIpcoD9WzLYxKYpkvhRxUmeyJR5z2QyqApzWvQND+s=";
  };

  # we cannot use fetchYarnDeps because that doesn't support yarn 2/berry lockfiles
  offlineCache = stdenv.mkDerivation {
    name = "hedgedoc-${version}-offline-cache";
    inherit src;

    nativeBuildInputs = [
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      nodejs # needed for npm to download git dependencies
      yarn
    ];

    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures.os '[ "linux" ]'
      yarn config set --json supportedArchitectures.cpu '["arm", "arm64", "ia32", "x64"]'
      yarn
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-RV9xzNVE4//tPVWVaET78ML3ah+hkZ8x6mTAxe5/pdE=";
  };

in stdenv.mkDerivation {
  pname = "hedgedoc";
  inherit version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    (python3.withPackages (ps: with ps; [ setuptools ])) # required to build sqlite3 bindings
    yarn
  ];

  buildInputs = [
    nodejs # for shebangs
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn config set enableTelemetry 0
    yarn config set cacheFolder ${offlineCache}
    export npm_config_nodedir=${nodejs} # prevent node-gyp from downloading headers

    yarn --immutable-cache
    yarn run build

    # Delete scripts that are not useful for NixOS
    rm bin/{heroku,setup}
    patchShebangs bin/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hedgedoc
    cp -r {app.js,bin,lib,locales,node_modules,package.json,public} $out/share/hedgedoc

    for bin in $out/share/hedgedoc/bin/*; do
      makeWrapper $bin $out/bin/$(basename $bin) \
        --set NODE_ENV production \
        --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"
    done
    makeWrapper ${nodejs}/bin/node $out/bin/hedgedoc \
      --add-flags $out/share/hedgedoc/app.js \
      --set NODE_ENV production \
      --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit offlineCache;
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = {
    description = "Realtime collaborative markdown notes on all platforms";
    license = lib.licenses.agpl3Only;
    homepage = "https://hedgedoc.org";
    mainProgram = "hedgedoc";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
}
