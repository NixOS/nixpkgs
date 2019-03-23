{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  name = "cargo-tree-${version}";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";

    sha256 = "1pnq2gphdv0rkc317rnkdx2qv0cd7p3k4v5f0ys5rya2akkxx4wn";
  };

  cargoSha256 = "0y6swl5ngkd489g53c100gyjl1sp8vidl8j6zfcasw5lbkli3acs";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
