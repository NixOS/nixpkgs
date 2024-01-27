{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    rev = "refs/tags/mdbook-i18n-helpers-${version}";
    hash = "sha256-oS1U76BgTW+YnhyLPRTlIg03RR9s5oybFIdCm3MVkvc=";
  };

  cargoHash = "sha256-bDv6pJTFs6U5vnWy5vcLv28Mjf7zrepsfs+JCu00xkA=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
