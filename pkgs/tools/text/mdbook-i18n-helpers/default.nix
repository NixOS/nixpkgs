{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    rev = "refs/tags/${version}";
    hash = "sha256-ea/z5+QAvQVacP2Yxz9hGh8REjsNbp/rfkDV0f9KyPg=";
  };

  cargoHash = "sha256-4Bf6R8sVwJCFiF+j+WePxWy43KuArIuMCzXKc58+TAw=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
