{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "tankerkoenig-card";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "timmaurice";
    repo = "lovelace-tankerkoenig-card";
    tag = finalAttrs.version;
    hash = "sha256-RhaXF7avYC75j9/4TRkg0fy7OTdU/X0nADwsW9Bb4+o=";
  };

  npmDepsHash = "sha256-OWToUfhL9AvomltUXtBwh1SFCJtPvqz7gFGb4OS1JnU=";

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
