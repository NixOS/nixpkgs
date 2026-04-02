{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Lint-Free-Technology";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-lErNtkRS6xbbpNvqrOu8k8ZZyKcwwzP/6Hlll4CggEQ=";
  };

  npmDepsHash = "sha256-diRmXYsbsMP6jC/dBRraRDknloZKA1SNrnoLST8wMfw=";

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
