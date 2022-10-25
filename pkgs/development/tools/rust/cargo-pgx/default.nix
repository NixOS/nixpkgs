{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.5.6";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-CbQWgt/M/QVKpuOzY04OEZNX4DauYPMz2404WQlAvTw=";
  };

  cargoSha256 = "sha256-sqAOhSZXzqxOVkEbqpd+9MoXqEFlkFufQ8O1zAXPnLQ=";

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
