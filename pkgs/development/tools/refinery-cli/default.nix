{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.6";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-vT/iM+o9ZrotiBz6mq9IVVJAkK97QUlOiZp6tg3O8pI=";
  };

  cargoSha256 = "sha256-DMQr0Qtr2c3BHWqTb+IW2cV1fwWIFMY5koR2GPceYHQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
