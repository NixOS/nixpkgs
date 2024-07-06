{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U47kA2D2dvJu8ym1OT/ThSsNC22b5hJ0Kqxerg8RPSI=";
  };

  cargoHash = "sha256-pznA7aTLrc4I5uElh+4Oxp3lXHRfV5YMn9abcaJSHIc=";

  meta = with lib; {
    description = "CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    mainProgram = "function-runner";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
