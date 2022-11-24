{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.24.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-6PAOyZmaqsHHyzS9sI591tnAi3/kwRlQR4K4iZJmR5Q=";
  };

  cargoSha256 = "sha256-wWSVpWmD1ZItXgH5q0u16oBQ+d4wKjg+pvt/ZlgiWBg=";

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

