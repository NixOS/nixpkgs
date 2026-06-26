{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "flower-card";
  version = "2026.6.1";

  src = fetchFromGitHub {
    owner = "olen";
    repo = "lovelace-flower-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mep8+72yEGICoBywKQ0MAYN/VPCEwEvY93jECvk6FeE=";
  };

  npmDepsHash = "sha256-vP5ShzHQdBa+TY11P4QadyGBjXSw68/rGODiiJKBbnQ=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp flower-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "Lovelace Flower Card to match the custom plant integration";
    homepage = "https://github.com/Olen/lovelace-flower-card";
    changelog = "https://github.com/Olen/lovelace-flower-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
