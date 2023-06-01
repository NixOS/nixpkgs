{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.10";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-6nb/RduzoTK5UtdzYBLdKkYTUrV9A1w1ZePqr3cO534=";
  };

  cargoHash = "sha256-rdxcWsLwhWuqGE5Z698NULg6Y2nkLqiIqEpBpceflk0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
