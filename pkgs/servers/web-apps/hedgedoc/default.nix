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

  buildPhase = ''
    runHook preBuild

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

    rm bin/heroku
    patchShebangs bin/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hedgedoc
    cp -r bin $out
    cp -r {app.js,lib,locales,node_modules,package.json,public} $out/share/hedgedoc

    for bin in $out/bin/*; do
      wrapProgram $bin \
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
