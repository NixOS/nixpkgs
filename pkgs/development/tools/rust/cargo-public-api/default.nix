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
  version = "0.30.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bBMjHnDmgFRQ9R8BWVc6zTHDrbFxjBAelkgtHsGLC9w=";
  };

  cargoHash = "sha256-c8jubHQexg7k0pxUREEGpa9F3SyMBdKLw87ZInEs/fI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

