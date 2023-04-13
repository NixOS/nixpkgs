{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.7";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-M4Kq1Sy5kJayESv0hHIktCf1bQgNOEFQcjg4RCqFCK4=";
  };

  cargoSha256 = "sha256-LObxOh2lOtSTm4gITTbQ2S9rMlyUOAAvMJmtvZy5bJs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
