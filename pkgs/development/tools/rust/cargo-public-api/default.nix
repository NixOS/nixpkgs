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
  version = "0.35.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NRL+7v1K2Y6lm1yuNZODkMaf2Xeib8KjOvPbn+nvbA4=";
  };

  cargoHash = "sha256-/IpSIqZfBliiWzDXoSJMK/B8wDw1eyJ/gecHwd90c+A=";

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

