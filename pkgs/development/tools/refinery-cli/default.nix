{ fetchCrate, lib, stdenv, openssl, pkg-config, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.13";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-5PncxxJ63WGwJk4MexqOJZQEhdoe4WMz8gsHZgjxBPM=";
  };

  cargoHash = "sha256-C0/11Ky5mXcEFPxa72jkJLg/DDxPz/Jmmfa2oHpHF6k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    mainProgram = "refinery";
    homepage = "https://github.com/rust-db/refinery";
    changelog = "https://github.com/rust-db/refinery/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
