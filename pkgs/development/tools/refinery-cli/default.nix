{ fetchCrate, lib, stdenv, openssl, pkg-config, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.12";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-ftti/+Zl9/8CsrlEI5gZQF0M33vzl5aK3X/EfCujtY4=";
  };

  cargoHash = "sha256-KlZTgg/Y4cXy5DR8iT4olVTF0kq1g5AQm3Sjpmrl6lk=";

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
