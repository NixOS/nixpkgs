{ lib
, rustPlatform
, fetchCrate
, pkg-config
<<<<<<< HEAD
, curl
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
<<<<<<< HEAD
  version = "0.32.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-etEwMmfwyOTHRb/UfkcHvmnLVVqeSagWJ5HjuJ6gZVo=";
  };

  cargoHash = "sha256-7GyPjEit3FEjnegLnZt9TMLBI3BtzcDssrJPj60gpTo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ curl openssl ]
=======
  version = "0.29.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4UaLzYwOhVK3Ca4EqQTdi/cMozAeXLWALB5yTQCNi/k=";
  };

  cargoHash = "sha256-zDgohGKu7jbaWNkb/Nr6ZVkQFEiXzNdEReVBsVuvKDA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

