{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    hash = "sha256-+k1kHiHRQER/8JTOeQdxcbsfMvS6eC74Wkd9IlLldok=";
  };

  cargoHash = "sha256-N3niTnSSIfOVOGhcHHgTbLnpYNmM4bow7qX539P+kHQ=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog matthiasbeyer ];
  };
}
