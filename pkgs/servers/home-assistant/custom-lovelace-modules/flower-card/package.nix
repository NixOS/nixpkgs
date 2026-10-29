{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "flower-card";
  version = "2026.4.1";

  src = fetchFromGitHub {
    owner = "olen";
    repo = "lovelace-flower-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5v5xd2DSTg1meRr4ORAmZbtfBSNM1z/3Y5Y/vI20R4s=";
  };

  npmDepsHash = "sha256-XGKGoFdbeUIx12ZGP8o2oSTJHVa+PZ6jwYSWiqjtSuM=";

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
