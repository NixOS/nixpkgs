{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.11";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-Dx0xcPQsq5fYrjgCrEjXyQJOpjEF9d1vavTo+LUKSyE=";
  };

  cargoHash = "sha256-giD9yBbC3Fsgtch6lkMLGkYik/hivK48Um2qWI7EV+A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
