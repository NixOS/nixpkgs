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
  version = "0.33.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tTmFUqFTzhr/dyHnHKaK3Soz+EFi1jaEtyL3Ns2vFiI=";
  };

  cargoHash = "sha256-ZqCiH8fj4S0EF7aYdN8yvxb/718GNngHBmO8C5Y6WRI=";

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

