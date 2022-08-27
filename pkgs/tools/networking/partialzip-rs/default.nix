{ lib, rustPlatform, fetchCrate, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "partialzip-rs";
  version = "1.1.1";

  src = fetchCrate {
    inherit version;

    crateName = "partialzip";
    sha256 = "sha256-zQsWOwGQCvKWoZRVNU7uqqqF9X8gJKySpPYYKvKp26k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-wObpzJ+2kqz7iHTNlofXriuiGYjhXhIrx5vP91rTc9g=";

  # Tests use the internet and therefore fail
  doCheck = false;

  meta.license = lib.licenses.mpl20;
}
