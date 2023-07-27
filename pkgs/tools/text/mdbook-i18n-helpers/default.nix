{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    rev = "refs/tags/${version}";
    hash = "sha256-3J7uHjHOpK2ympCZxtKieJamYepRQiBGIFo6HAQMGJ0=";
  };

  cargoHash = "sha256-cAuKQm0RZx3VRmLIL3WShsOlZMd6szI7cd9A0A4o8x8=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
