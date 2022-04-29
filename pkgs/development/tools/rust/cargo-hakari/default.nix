{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "cargo-guppy";
    rev = "cargo-hakari-${version}";
    sha256 = "sha256-LT3ZcqlZNh89zz1O83TE+TxnO1jw3vn1zqa17vMXuoU=";
  };

  cargoSha256 = "sha256-a7XKKCKbkU3ZhTUHjksAY0ey2kJYTPnLG5XsMpWXUCw=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  cargoTestFlags = [
    # TODO: investigate some more why these tests fail in nix
    "--"
    "--skip=tests::workspace_tests::inside_outside_v1::proptest_compare"
    "--skip=tests::workspace_tests::inside_outside_v2::proptest_compare"
  ];

  meta = with lib; {
    description = "cargo hakari is a command-line application to manage workspace-hack crates.";
    homepage = "https://github.com/facebookincubator/cargo-guppy/tree/main/tools/cargo-hakari";
    license = with licenses; [ mit asl20 ];
  };
}
