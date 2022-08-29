{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6laSFo8aBmZpeN5V3utZQHIWuoQcdy1hd1yU8LxpEJQ=";
  };

  cargoSha256 = "sha256-bbyeI/cr5aBejiEcYyyyJO8UX5QoIlT9MFgnpDr/z1M=";

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
