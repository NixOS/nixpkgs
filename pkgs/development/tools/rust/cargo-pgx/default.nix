{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.5.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-5UH34l4zmKFZY2uHLDqJ1kW/QRQbII0/zmmGA3DFKB4=";
  };

  cargoSha256 = "sha256-1CU/VrNS3tGycjel5MV6SrZJ7LExds2YhdO+VAHgusM=";

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
