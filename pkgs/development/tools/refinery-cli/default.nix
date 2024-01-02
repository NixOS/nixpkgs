{ fetchCrate, lib, stdenv, openssl, pkg-config, rustPlatform, darwin }:

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

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    changelog = "https://github.com/rust-db/refinery/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
