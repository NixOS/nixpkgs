{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-OFWmrwZdyvIhyKsWEfaU7wHIqeuNhjwZQkwKTccBnTI=";
  };

  cargoSha256 = "sha256-nubWXEG8XmX2t7WsNvbcDpub5H1x5467cSFRvs8PEpQ=";

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

