{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wagyu";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "AleoHQ";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ltWNKB3DHtwVVzJyvRWj2I8rjsl7ru2i/RCO9yiQhpg=";
  };

  cargoHash = "sha256-8dbeSHN6+1jLdVA9QxNAy7Y6EX7wflpQI72kqZAEVIE=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
    homepage = "https://github.com/AleoHQ/wagyu";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
    mainProgram = "wagyu";
  };
}
