{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitHub
, gitMinimal
, cacert
, yarn
, makeBinaryWrapper
, nodejs
=======
, fetchzip
, makeWrapper
, which
, nodejs
, mkYarnPackage
, fetchYarnDeps
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python3
, nixosTests
}:

<<<<<<< HEAD
let
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "hedgedoc";
    rev = version;
    hash = "sha256-6eKTgEZ+YLoSmPQWBS95fJ+ioIxeTVlT+moqslByPPw=";
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
    outputHash = "sha256-Ga+tl4oZlum43tdfez1oWGMHZAfyePGl47S+9NRRvW8=";
  };

in stdenv.mkDerivation {
  pname = "hedgedoc";
  inherit version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    yarn
    python3 # needed for sqlite node-gyp
  ];

  dontConfigure = true;
=======
mkYarnPackage rec {
  pname = "hedgedoc";
  version = "1.9.7";

  # we use the upstream compiled js files because yarn2nix cannot handle different versions of dependencies
  # in development and production and the web assets muts be compiled with js-yaml 3 while development
  # uses js-yaml 4 which breaks the text editor
  src = fetchzip {
    url = "https://github.com/hedgedoc/hedgedoc/releases/download/${version}/hedgedoc-${version}.tar.gz";
    hash = "sha256-tPkhnnKDS5TICsW66YCOy7xWFj5usLyDMbYMYQ3Euoc=";
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python3 ];

  packageJSON = ./package.json;
  yarnFlags = [ "--production" ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "0qkc26ks33vy00jgpv4445wzgxx1mzi70pkm1l8y9amgd9wf9aig";
  };

  configurePhase = ''
    cp -r "$node_modules" node_modules
    chmod -R u+w node_modules
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildPhase = ''
    runHook preBuild

<<<<<<< HEAD
    export HOME=$(mktemp -d)
    yarn config set enableTelemetry 0
    yarn config set cacheFolder ${offlineCache}

    # This will fail but create the sqlite3 files we can patch
    yarn --immutable-cache || :

    # Ensure we don't download any node things
    sed -i 's:--fallback-to-build:--build-from-source --nodedir=${nodejs}/include/node:g' node_modules/sqlite3/package.json
    export CPPFLAGS="-I${nodejs}/include/node"

    # Perform the actual install
    yarn --immutable-cache
    yarn run build
=======
    pushd node_modules/sqlite3
    export CPPFLAGS="-I${nodejs}/include/node"
    npm run install --build-from-source --nodedir=${nodejs}/include/node
    popd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    patchShebangs bin/*

    runHook postBuild
  '';

<<<<<<< HEAD
  installPhase = ''
    runHook preInstall
=======
  dontInstall = true;

  distPhase = ''
    runHook preDist
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    mkdir -p $out
    cp -R {app.js,bin,lib,locales,node_modules,package.json,public} $out

<<<<<<< HEAD
    makeWrapper ${nodejs}/bin/node $out/bin/hedgedoc \
      --add-flags $out/app.js \
      --set NODE_ENV production \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    inherit offlineCache;
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = {
    description = "Realtime collaborative markdown notes on all platforms";
    license = lib.licenses.agpl3;
    homepage = "https://hedgedoc.org";
    mainProgram = "hedgedoc";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
=======
    cat > $out/bin/hedgedoc <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node $out/app.js
    EOF
    chmod +x $out/bin/hedgedoc
    wrapProgram $out/bin/hedgedoc \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postDist
  '';

  passthru = {
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = with lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://hedgedoc.org";
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
