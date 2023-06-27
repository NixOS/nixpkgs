{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9rFczpVboJ+TPQzuegFj8RGYBel+4n5iY4B0sruK5wc=";
  };

  cargoSha256 = "sha256-uIgDs7dFJjZgOE/y3T11N3zl8AwRvIyJbIC7wD7Nr7Q=";

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
