{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oQtob1ugjMl8HoaHg9/2fhq8JG0xPU1Ht4OiSLOa96I=";
  };

  cargoHash = "sha256-sUIbPW9lWirJUxy2AHENbPXYTQ1lkCtH4LyQ2pD4yXI=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
