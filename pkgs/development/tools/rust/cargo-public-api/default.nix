{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.24.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xXwJ6MXnSgqIQ5IuqfDm/TUXgkppKCPG3TB7veza/H8=";
  };

  cargoSha256 = "sha256-1sSvK8oZspIxDcMAl2MyAQzuijAxj1kpiZf1QwwyYDs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

