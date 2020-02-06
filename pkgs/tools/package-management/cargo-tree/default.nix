{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-tree";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";
    sha256 = "0wv5zgyx18fypdb4pmgzxvr2gb9w8vgv6aqir3dxhcvcgf2j5c3n";
  };

  cargoSha256 = "16r7zzkf87v67spahaprc25agwh6d3i0kg73vx8a6w7hgqlk0zwa";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
    homepage = "https://crates.io/crates/cargo-tree";
  };
}
