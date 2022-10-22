{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.5.3";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-Glc6MViZeQzfZ+pOcbcJzL5hHEXSoqfksGwVZxOJ6G0=";
  };

  cargoSha256 = "sha256-Ag9lj3uR4Cijfcr+NFdCFb9K84b8QhGamLECzVpcN0U=";

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
