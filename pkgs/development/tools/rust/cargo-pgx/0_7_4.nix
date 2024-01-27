{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.7.4";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-uyMWfxI+A8mws8oZFm2pmvr7hJgSNIb328SrVtIDGdA=";
  };

  cargoSha256 = "sha256-RgpL/hJdfrtLDANs5U53m5a6aEEAhZ9SFOIM7V8xABM=";

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
