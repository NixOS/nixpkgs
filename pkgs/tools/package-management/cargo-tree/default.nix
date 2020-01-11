{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-tree";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "37030742fbf83106707525913ab6c4c3c701cd0e";
    sha256 = "1mi52n02j9dmi19af6js0vmmqnl8rf4zxind3cxh401530cd8ml4";
  };

  cargoSha256 = "12p9dqlxa1b1sx8572w7hj0rlkkpv3k440pffdyjgyx4s1r9m0s0";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
    homepage = "https://crates.io/crates/cargo-tree";
  };
}
