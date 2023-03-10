{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bnceN47OFGlxs3ibcKoZFjoTgXRQxA2ZqxnthJ/fsqE=";
  };

  cargoSha256 = "sha256-qMPJC61ZVW9olMgNnGrvcQ/je4se4J5gOVoaOpNMUo8=";

  meta = with lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ johntitor xrelkd ];
  };
}
