{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    rev = "refs/tags/${version}";
    hash = "sha256-j5nbAgbCuz8urvdYPTTtGDnWwY/FxKNnwbeSTcuyIKw=";
  };

  cargoHash = "sha256-lDHq4KRYIeCddhFGQDWOx9olcOASjOke/h22Qm4wv6Q=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
