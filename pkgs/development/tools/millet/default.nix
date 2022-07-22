{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+4lMRd4pzbkRDct5kz17MB9drN6sEtYLk29d6TlubLk=";
  };

  cargoSha256 = "sha256-MoXKNUgNeg2AG7G78wnZvLXADhCsK/WB5WiT5lTSmIQ=";

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
