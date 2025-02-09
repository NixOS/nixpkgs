{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    rev = "refs/tags/${version}";
    hash = "sha256-TxSALv/uqRFdv4JZ8BCiAlirMcizGRkw0YxMCBVkgo4=";
  };

  cargoHash = "sha256-BhaSK2A/z05a75dEx8c4RHKau1HRJabOcQ6/eLvcdio=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
