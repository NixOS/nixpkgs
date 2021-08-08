{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-o3AKA/uP6VWMO4c62H3ey0P98KIhbzhnng5ggKjNeZ8=";
  };

  cargoSha256 = "sha256-SHLiUVH5LiQNd/Ipj/xrjSG0X2HXfcAwswqsbqweJBs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}
