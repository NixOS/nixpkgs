{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bks73G9oZgZpkSbrRWD34+UcFOMkJJa4qkJIQxcx/Ao=";
  };

  cargoHash = "sha256-V0lr1gqn8w4MrHQO5UVxUl+OdK/ODutAr+nMYHc+4hQ=";

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
