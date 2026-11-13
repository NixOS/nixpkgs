{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcore-card";
  version = "0.4.3";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "meshcore-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ad7XKqShvnYL8ty1fgGnPCxXF7ivsMsVS8F8r00UfeI=";
  };

  npmDepsHash = "sha256-niMUu9NQSs2Jb3EDoIWXiRyZ5Oq4AEBGIh1Rbl1+dm4=";

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
