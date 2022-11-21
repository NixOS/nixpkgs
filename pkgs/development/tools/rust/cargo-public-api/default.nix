{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.23.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-yllfkhf0Xy8D6tL08QYPnz7Cj/JOvMG7E53elRx11EE=";
  };

  cargoSha256 = "sha256-UwrhgMmZ9PnIsxsWxQskaMHl03g54VeoZRo9ZPkSM28=";

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

