{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "tankerkoenig-card";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "timmaurice";
    repo = "lovelace-tankerkoenig-card";
    tag = finalAttrs.version;
    hash = "sha256-CLO6kQXm+Xbsi5hJLjT9I/xYg8mEptFqdRSw56CGuaE=";
  };

  npmDepsHash = "sha256-PvljUtxp7mbUqSZ/0ynTjMo3rlPXvhWFMJ5UJk6jrVw=";

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
