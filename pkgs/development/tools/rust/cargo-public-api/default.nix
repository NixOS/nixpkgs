{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.22.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-OjKvp3LsNBIIkpq15BAi9LqxbLgormkiW/lMqdPefZM=";
  };

  cargoSha256 = "sha256-TUXyWO1rNngv1Tli0jeaOHwaBJnh7LnXe+lNSR+7rfI=";

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

