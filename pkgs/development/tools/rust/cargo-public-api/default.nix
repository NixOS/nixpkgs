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
  version = "0.31.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-w8K1dmTjnHm5bh1Ztn5DnBm2PEddxYLewWPiEnqbjCo=";
  };

  cargoHash = "sha256-1SlGKnpwc8rN9w/d07nHVT3L4erA6/TWaza5qy57hlE=";

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

