{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z03+3x1xGYSa+WVEuHBgUQ9NdqG3rCziNYcwTjWBNV8=";
  };

  cargoHash = "sha256-4sgf7WfaX7jnV8YynZNLi/N8MfkuAc4tk/8eiKEyyxI=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
