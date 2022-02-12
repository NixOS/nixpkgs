{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-Sh+nAeFd163nr8h3jBJbfDiMt+8+6bi/B1OOVVGMTXo=";
  };

  cargoSha256 = "sha256-QPp/vO4ZBvxbBtXbvU1ZRLPXOmzMCaJ1/mtuTpL6UYw=";

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
