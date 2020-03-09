{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tree";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";
    sha256 = "16k41pj66m2221n1v2szir7x7qwx4i0g3svck2c8cj76h0bqyy15";
  };

  cargoSha256 = "0762gdj4n5mlflhzynnny1h8z792zyxmb4kcn54jj7qzdask4qdy";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ma27 ];
    homepage = "https://crates.io/crates/cargo-tree";
  };
}
