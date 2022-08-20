{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.4.5";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-BcMGa/1ATwLG8VnwItfd5eqmrck/u0MEoR5sA2yuzyQ=";
  };

  cargoSha256 = "sha256-urlwqBCZMxlPEjLLPBhI2lDNTusCSZ1bZu1p8poVrtw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Cargo subcommand for ‘pgx’ to make Postgres extension development easy";
    homepage = "https://github.com/tcdi/pgx/tree/v${version}/cargo-pgx";
    license = licenses.mit;
    maintainers = with maintainers; [ typetetris ];
  };
}
