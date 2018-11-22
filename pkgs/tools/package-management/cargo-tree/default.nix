{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  name = "cargo-tree-${version}";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";

    sha256 = "1knxykw1pbqxs4inijd3y797kf1zp4ansmnbwfqxyjlkgss0spdq";
  };

  cargoSha256 = "0w1psr7j5r8ng3njkjiva738czlhnf9drprisbc8szkfhzc3rgaw";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
