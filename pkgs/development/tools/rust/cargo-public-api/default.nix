{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.19.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-gtqPt59jA4NhbaE9ij45oFEaAJ+l984lWEjloQtBSSE=";
  };

  cargoSha256 = "sha256-j0bsuu+A5oCf+0pFM4PAQ3oqq9POc5rrzt5UR0RDnAw=";

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

