{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.26.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BiGVdWgDi+g+mxdM3+z5RN1pGJz9NIKVm8sTZf2ObCc=";
  };

  cargoSha256 = "sha256-QvZBWo/u+WtIG5zlDVTC2+5bq/mqZftXU5m8oqN25GM=";

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

