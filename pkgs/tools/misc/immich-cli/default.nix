{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "immich-cli";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "CLI";
    rev = "v${version}";
    hash = "sha256-BpJNssNTJZASH5VTgTNJ0ILj0XucWvyn3Y7hQdfCEGQ=";
  };

  npmDepsHash = "sha256-GOYWPRAzV59iaX32I42dOOEv1niLiDIPagzQ/QBBbKc=";

  meta = {
    changelog = "https://github.com/immich-app/CLI/releases/tag/${src.rev}";
    description = "CLI utilities for Immich to help upload images and videos";
    homepage = "https://github.com/immich-app/CLI";
    license = lib.licenses.mit;
    mainProgram = "immich";
    maintainers = with lib.maintainers; [ felschr ];
  };
}
