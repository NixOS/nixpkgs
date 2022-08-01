{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.12.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-URCKsI7q0/b8KkCooKeYr342m7C8ukJJITRDgOUmcEM=";
  };

  cargoSha256 = "sha256-qXJeNbGvC6zoxdn2QmApw1m7gn4CI1eUC3Cqhrn8dpU=";

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

