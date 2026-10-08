{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "tankerkoenig-card";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "timmaurice";
    repo = "lovelace-tankerkoenig-card";
    tag = finalAttrs.version;
    hash = "sha256-XSeTrmnGQ5O711z99ELzVIh06pHEyw4GXksuxkkfCpA=";
  };

  npmDepsHash = "sha256-ewTbWFTnT/yz13CT0UIuW0PHLr2hDqfO66z8H0jzdAQ=";

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
