{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Lint-Free-Technology";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-z+WrkLPuyzfYiKqfCmVyj1o7z/WjByr7gYoJblyQS3I=";
  };

  npmDepsHash = "sha256-09JWRjHhGHQ2NtLgY5x/dH/B+l/Sy4OfbEckHY3ezZI=";

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
