{ lib
, rustPlatform
, fetchCrate
, pkg-config
, curl
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.34.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xD+0eplrtrTlYYnfl1R6zIO259jP18OAp9p8eg1CqbI=";
  };

  cargoHash = "sha256-EjMzOilTnPSC7FYxrNBxX+sugYvPIxiCzlwQcl3VMog=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    mainProgram = "cargo-public-api";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

