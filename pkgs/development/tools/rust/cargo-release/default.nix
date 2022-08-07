{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-Ll2/wdjJdSW3fA6kscfFROVVrPYer0b5CHyOGUKPXmQ=";
  };

  cargoSha256 = "sha256-yASjTRldbHnXFpZHncfAdZstdchTHBxCDhxEof3mY6k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}
