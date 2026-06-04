{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcore-card";
  version = "0.3.5";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "meshcore-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XfqtCGSDrfkNIqWuH8Y8DLacJf9x7iaZXDiKDWdqzhw=";
  };

  npmDepsHash = "sha256-KgG6PGSGw9zCOPboZjo/gpAs2OwLg3LRl3rqenIvTG8=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/${finalAttrs.pname}.js $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "MeshCore Lovelace card for Home Assistant";
    homepage = "https://github.com/jpettitt/meshcore-card";
    changelog = "https://github.com/jpettitt/meshcore-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
