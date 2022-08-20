{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-e+HM4pO0bLszlcSklsiRPamr/GUVckuw7uBSgDSK7d0=";
  };

  cargoSha256 = "sha256-RKO/YMVWKVtparAfDUtpQ3mbRWataNnjnFUUQozQghs=";

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

