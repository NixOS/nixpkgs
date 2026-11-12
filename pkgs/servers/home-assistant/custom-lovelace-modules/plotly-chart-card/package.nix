{
  lib,
  stdenv,
  bun,
  nodejs_22,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

let
  pname = "plotly-graph-card";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "dbuezas";
    repo = "lovelace-plotly-graph-card";
    tag = "v${version}";
    hash = "sha256-8/ZwfvFxM5j/BVIh3wQRPzxV/Xob4GAHMNByPxXcA8U=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress --cpu="*" --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash = "sha256-jSVEJ+2MG6BGHg7KhNM6S+zf20OlY5aWgnJRMIc/e4o=";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    nodejs_22
    bun
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/node_modules .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    node build.mjs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out
    install -m0644 dist/*.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "plotly-graph-card.js";

  meta = {
    description = "Highly customisable Lovelace card to plot interactive graphs. Brings scrolling, zooming, and much more";
    homepage = "https://github.com/dbuezas/lovelace-plotly-graph-card";
    changelog = "https://github.com/dbuezas/lovelace-plotly-graph-card/releases/tag/${src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
