{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AnY9WIb3bHhC9o0ymdFM2MFro1Rx/yoVXMsbjCSNJaE=";
  };

  cargoHash = "sha256-oM6DMtQhtHR47AEw5RubNCGNpUKbIx/jVZeeoK3utlY=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
