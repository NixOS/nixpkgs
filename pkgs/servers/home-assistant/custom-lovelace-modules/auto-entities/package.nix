{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Lint-Free-Technology";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-hwNQwy93IE7cQnk8xyM8RiSeiqjP5Cju7UG7rPzy8As=";
  };

  npmDepsHash = "sha256-24205WinaiwkoyZQC0e00l77rZVJeJ9PuZ0CZJ7u41M=";

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
