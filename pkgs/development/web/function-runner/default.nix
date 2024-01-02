{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cKlzv9mL6UGXHvYbQR4OcZgdjZLV5Q7EoQbW7Fx8ESo=";
  };

  cargoHash = "sha256-/4/zaeNQ45YYBILxm11qD9rPFZxilA8kLoyWG370Knk=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
