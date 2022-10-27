{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wrNooeHFgIPJkjCeH4PoaaRjsukg2ASbioD/TTSNNgk=";
  };

  cargoSha256 = "sha256-2/yTRbGTE72PhSFf4I/6y0B6z9qYM5dwFmk5VCWU0mU=";

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

