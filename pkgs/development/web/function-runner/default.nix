{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nKOgXUwhOHaOnxycTsEReS/4y9DNpyqDKz7ohfAaJ3U=";
  };

  cargoHash = "sha256-UDeHNIw7e+3zXO9Hggq3pVSDDp6iSoO8ikOl6RxZyb0=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
