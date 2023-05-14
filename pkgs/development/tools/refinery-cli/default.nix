{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.9";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-KNidO4HO4fcGXWJxFYsat2duZTzUA8XFcaK+Qzb1HFI=";
  };

  cargoHash = "sha256-nYqOGSFQ4GdUdLkZ2Xtx+bRj2sX6joxKjNqm9CloODU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
