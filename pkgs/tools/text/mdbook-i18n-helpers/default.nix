{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    rev = "refs/tags/mdbook-i18n-helpers-${version}";
    hash = "sha256-5DfQCkNilRB309BXQ/DWrSMX+A64uiZ2CZxPZ0krtys=";
  };

  cargoHash = "sha256-BrbEW5PD7n9KDaBUjdF60nto6mcfdQ0OUDKcnRH23DA=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s matthiasbeyer ];
  };
}
