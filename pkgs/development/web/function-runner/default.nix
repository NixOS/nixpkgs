{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3HhtRzeOgn2fhC7qf95Wy04hI2/d9oReX9r/BTvW5nQ=";
  };

  cargoHash = "sha256-27QY+QQHR+bK7Sf8I6wWyYMwBZYJbEBe5ZK+zYEansQ=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
