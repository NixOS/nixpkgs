{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.6.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-CXOInyT0fY17e4iuGhUpR9EPd2M8jauR5TKpPlhTJoQ=";
  };

  cargoSha256 = "sha256-RtPFFIuurSPMhGLcGLOu0em1biimVkTaAKP5EUPtQ9U=";

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
