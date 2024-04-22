{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    rev = "refs/tags/mdbook-i18n-helpers-${version}";
    hash = "sha256-+lXIqq8T6jUkvxzvUnvRDmJg6BnT6rNK67kTm3krR0E=";
  };

  cargoHash = "sha256-xQwag3mlcLKI2ERhp+Sug8FZ6LMxnG4P1JaZNtrzdk8=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s matthiasbeyer ];
  };
}
