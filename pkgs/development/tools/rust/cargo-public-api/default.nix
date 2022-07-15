{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.12.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZpzR6A9mV6ARz2+SedVtLjNANOEj8Ks09AWcQooltug=";
  };

  cargoSha256 = "sha256-8BZ1fPzRSJysyLCmoMxk+8xOfmfIs7viHFCeSfnxvt8=";

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

