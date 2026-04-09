{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs-slim,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "navbar-card";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "joseluis9595";
    repo = "lovelace-navbar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jyG0QGt8kC4M6iFBpV5mhH2AKYC2n/t80XqOwbmwLnE=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

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

    outputHash = "sha256-F8nNDBl/BYhtwggaZd61oibYE4j5u7WPVjLG8P4UEcc=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs-slim
  ];

  configurePhase = ''
    runHook preConfigure

    # Copy node_modules from the separate derivation
    cp -R ${finalAttrs.node_modules}/node_modules .

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

  passthru = {
    entrypoint = "navbar-card.js";
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Navbar Card for Home Assistant's Lovelace UI - easily navigate through dashboards";
    homepage = "https://github.com/joseluis9595/lovelace-navbar-card";
    changelog = "https://github.com/joseluis9595/lovelace-navbar-card/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
