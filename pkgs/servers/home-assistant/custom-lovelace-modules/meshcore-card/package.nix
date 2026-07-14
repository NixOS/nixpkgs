{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcore-card";
  version = "1.0.0";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "meshcore-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B2W3B8cd9OrTOxLEWUV8Aercektfwh7/Ik3/U/Lwz48=";
  };

  npmDepsHash = "sha256-/CtYdDFo8Sbq3FEm6ND8b/CNcfsUgoT23F6RVfYtYDg=";

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
