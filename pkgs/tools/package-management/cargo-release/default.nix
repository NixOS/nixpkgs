{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.13.10";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-WWU+aNMNOOstHiGRE5nj2biWCL3uwyqJKgt0xCAfS0s=";
  };

  cargoSha256 = "sha256-G3UgcFW0WxvCYRvHCTuRpSCOT3XdvdZCN53HhpWQxS4=";

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
