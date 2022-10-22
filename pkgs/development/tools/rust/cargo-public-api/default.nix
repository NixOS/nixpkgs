{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.20.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-aDkQxt516cN27wtndSkBitoWZvPyaQETqZDHYlrr364=";
  };

  cargoSha256 = "sha256-EBVPUCQQ9rwl23vYOpCBtOBb8d3K53RPMkIUs6sQyyU=";

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

