{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-33UVo7mPD/o3Z/R5PFhosiSLFLLpJ0pHqUbKtX6THJE=";
  };

  cargoHash = "sha256-TNbGmqITCk1VKVuO46LxO+zjAG7Laguq7EAruuhJIxk=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
