{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgx";
  version = "0.7.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-t/gdlrBeP6KFkBFJiZUa8KKVJVYMf6753vQGKJdytss=";
  };

  cargoSha256 = "sha256-muce9wT4LAJmfNLWWEShARnpZgglXe/KrfxlitmGgXk=";

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
