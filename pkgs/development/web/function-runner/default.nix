{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5X/d6phYXmJcCacHvGkk5o/J91SdlFamxJrqc5X/Y4Y=";
  };

  cargoHash = "sha256-D6BTP/a3wOpcOLnGUASyBL3pzAieAllLzEZuaEv2Oco=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
