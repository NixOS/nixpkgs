{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "Lint-Free-Technology";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-fTyDQ2imr339uAYOnGMxcIzb2I5x+31tKUQQt85xGYQ=";
  };

  npmDepsHash = "sha256-6RA8Nr83buN+7CI2ZulgafrJhtVb3aX/WOyDMpER3yE=";

  installPhase = ''
    runHook preInstall

    install -D dist/auto-entities.js $out/auto-entities.js

    runHook postInstall
  '';

  meta = {
    description = "Automatically populate the entities-list of lovelace cards";
    homepage = "https://github.com/Lint-Free-Technology/lovelace-auto-entities";
    changelog = "https://github.com/Lint-Free-Technology/lovelace-auto-entities/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kranzes
      SuperSandro2000
    ];
  };
}
