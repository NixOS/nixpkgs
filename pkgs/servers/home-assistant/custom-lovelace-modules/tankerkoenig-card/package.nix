{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "tankerkoenig-card";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "timmaurice";
    repo = "lovelace-tankerkoenig-card";
    tag = finalAttrs.version;
    hash = "sha256-GMX6kIyoZN26NCgqPTj44TC3Yo+zTcmSm5ToakgIojA=";
  };

  npmDepsHash = "sha256-OrEQjE2XMcumCyfdKKMkFWO1vgOytVjsguTuU6AkZr0=";

  installPhase = ''
    runHook preInstall

    install ./dist/tankerkoenig-card.js -Dt $out

    runHook postInstall
  '';

  meta = {
    description = "Lovelace card to display German fuel prices from Tankerkönig";
    homepage = "https://github.com/timmaurice/lovelace-tankerkoenig-card";
    changelog = "https://github.com/timmaurice/lovelace-tankerkoenig-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
