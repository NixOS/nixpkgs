{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, cmake, curl, libiconv, darwin }:
rustPlatform.buildRustPackage rec {
  name = "cargo-tree-${version}";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "sfackler";
    repo = "cargo-tree";
    rev = "v${version}";

    sha256 = "0vr1mv8ns67kslxgwkvic8w86fvmqasxs6yd4yn21j49zg23866k";
  };

  cargoSha256 = "0924bpcwz15zlp4vjaqap05s4nynw9mqz0np1kph3vx7aj9rsaw6";

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ curl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A cargo subcommand that visualizes a crate's dependency graph in a tree-like format";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
