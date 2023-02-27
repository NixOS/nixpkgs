{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.27.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-6LXFrLSApEQXa34zTVgqUVYMiFnGi6i7gyXnMglHtFE=";
  };

  cargoHash = "sha256-3lMUKtHpCXN+fKDbU4QwVUol6aL6dxP5Bbf59xEkcjY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

