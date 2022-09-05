{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HV/0ORI3siAnVyLcNDzu4BwK/sFO841ptQoxK6c+1Xs=";
  };

  cargoSha256 = "sha256-jhn795bTcqOG60yzydWJ5Y9eR2UTVUBteuMw03M7wM0=";

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
  };
}
