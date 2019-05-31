{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  name = "cargo-tree-${version}";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";

    sha256 = "12z0sa7g79x46q2ybpy6i9rf1x4cnwajw8dsjzra2qhssyp8rp9c";
  };

  cargoSha256 = "10nfa0pd4zhz36f9yx80qd0bbsmqdjk8r6656jyzh92ydncry1as";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
