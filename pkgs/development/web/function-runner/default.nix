{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D8XqWVgW2pdNDwgWTpDG5FXlVHTWyKSx6ugJ9eqOl0U=";
  };

  cargoHash = "sha256-F+QArzUBgCg7yWL3Vcn+u+G/Hi6OmArCBB+4yYQYIVY=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
