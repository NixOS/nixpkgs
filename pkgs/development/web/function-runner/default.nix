{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4uW7gjvQjv10evBeYdRiQFsnA67VAzL74YBNUbVciHg=";
  };

  cargoSha256 = "sha256-EZubfW4PNdBurLk3YJ/BLtDq3zxkQ3YxfWMMBa2TpWU=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
