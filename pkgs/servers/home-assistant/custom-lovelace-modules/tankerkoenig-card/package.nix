{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "tankerkoenig-card";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "timmaurice";
    repo = "lovelace-tankerkoenig-card";
    tag = finalAttrs.version;
    hash = "sha256-IKeMOgpjFbl4yV8soZPgLwkkfBXW9Y9igLmhwQmhUm8=";
  };

  npmDepsHash = "sha256-l/FxUoqim/wkbhURTBnD/8IK8gcLNS5JAQqbnxgoAfs=";

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
