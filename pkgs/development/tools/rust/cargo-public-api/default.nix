{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.27.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mG+OjoOlpmmCpsAIs3m3FIRO36CrmWWgki9LgoXxiKo=";
  };

  cargoSha256 = "sha256-zfqqreNQhxetldE801e6/5KYFKsywXJVt7oIkm8ldS8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

