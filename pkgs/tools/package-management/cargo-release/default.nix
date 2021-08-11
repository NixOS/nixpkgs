{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "v${version}";
    sha256 = "sha256-VAXuxHCayjmuI26rhJroEBbnyJ4z+w7HY5TNTanYvpw=";
  };

  cargoSha256 = "sha256-cXuAPQ8xRkeixWNYGjStNipbn4xIc1NsfVqROd6RHdg=";

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
