{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Li3v3kXze0KgK16XVwdshZWaRF89YSC1Yk9iHXfGWKI=";
  };

  cargoHash = "sha256-jPiy4ULEfF/aRhWV1j2SOIe2u9uctEsmzWQ6MLXRu7A=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
