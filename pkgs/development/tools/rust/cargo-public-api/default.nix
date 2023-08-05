{ lib
, rustPlatform
, fetchCrate
, pkg-config
, curl
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.31.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oSjfNbId5jEHeLiJ3FMoNqwLZg6iyr3ZqpcfKvEnpac=";
  };

  cargoHash = "sha256-VHHEQafQfRqmdscuWpN+NdcfEc1sTt+lKLg26aM9QQE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl openssl ]
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

