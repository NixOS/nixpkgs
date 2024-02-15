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
  version = "0.33.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-poS8s4rfktNKQ0co8G4RLXUJAeUAGcS8YIvb4W0IFNo=";
  };

  cargoHash = "sha256-+tmLUxDxI/W2g7cdQD/Ph5wBpW3QbZzH2M/oRXLzsgU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

