{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o+fsIBH/vONlb57m3+upKG2Gss6s7yBNATkbKtSHf/0=";
  };

  cargoHash = "sha256-7ACi4orqpmWiaMYmOjICR6/d1kVySzaaCWIoUxqnhpI=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
