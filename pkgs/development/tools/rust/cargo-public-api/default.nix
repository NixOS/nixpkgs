{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5nGRVZiLSo/hCbwOnGN2jwbTIkVM6I50x1UDIOgplc8=";
  };

  cargoSha256 = "sha256-nf+BuWv5sg9nTzyXho1/khzM5hYeoq3bnUibPM/qflE=";

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

