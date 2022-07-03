{ lib, rustPlatform, fetchCrate, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-supply-chain";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-2iOAa0f0C3tS4oLrSJYjGnuoziPFxcQzXZLqENQq5PY=";
  };

  cargoSha256 = "sha256-7wjaakyh27U7jjQQ6wNKR4lKQ7Y/+EEfLCfjVojk3TU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/master/CHANGELOG.md";
    license = with licenses; [ asl20 mit zlib ]; # any of three
    maintainers = with maintainers; [ figsoda ];
  };
}
