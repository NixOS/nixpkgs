{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  name = "cargo-tree-${version}";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";

    sha256 = "0lq14w11a4zl0rvv7rsd79k51dwk3w78fbsi6klkqknad02qmx3r";
  };

  cargoSha256 = "0zi4qbadlx4l6zhb0f892ic3mdmyjjjzrirks18pl6qrn3dgny1x";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
