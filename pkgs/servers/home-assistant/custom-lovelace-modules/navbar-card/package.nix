{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs-slim,
  writableTmpDirAsHomeHook,
}:

let
  pname = "navbar-card";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "joseluis9595";
    repo = "lovelace-navbar-card";
    tag = "v${version}";
    hash = "sha256-uw90tm8KI7tqZwMNaRuxuIKVXhCLe0wVNisk91jLwwk=";
  };

  # Create node_modules as a separate derivation
  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-enQSr+HAnoIk2NiuKDx4fmFnIrG0tg23QImicQqDgpk=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    bun
    nodejs-slim
  ];

  configurePhase = ''
    runHook preConfigure

    # Copy node_modules from the separate derivation
    cp -R ${node_modules}/node_modules .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Build the project using bun
    bun build src/navbar-card.ts --outfile=dist/navbar-card.js --target=browser

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/navbar-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "navbar-card.js";

  meta = {
    description = "Navbar Card for Home Assistant's Lovelace UI - easily navigate through dashboards";
    homepage = "https://github.com/joseluis9595/lovelace-navbar-card";
    changelog = "https://github.com/joseluis9595/lovelace-navbar-card/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
