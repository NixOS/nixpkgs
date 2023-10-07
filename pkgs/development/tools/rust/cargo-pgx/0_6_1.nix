{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.6.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-O4eHVbJBudybsPab+zr2eXnfheREMqLAHAKm2GDbfrs=";
  };

  cargoSha256 = "sha256-MucGrA3qXgJOcT2LMNmoNOhQi8QA3LuqgZEHKycLCCo=";

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
