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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "joseluis9595";
    repo = "lovelace-navbar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ngKsH83nrDglRQBdQhJzMC8/TRV+uL21vi2ovsLEPuY=";
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
        --omit=optional \
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

    outputHash = "sha256-By1ZTJ+cZO+vhs0BL8HSu36k+dvG0WPRnuUwIoaclnw=";
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
    NODE_ENV=production bun build src/navbar-card.ts --outfile=dist/navbar-card.js --target=browser

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
