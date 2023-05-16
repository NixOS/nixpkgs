{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Libsystem
=======
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "unstable-2023-04-23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "rye";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-B53oTAgy+y+FWk7y+unJPt7Mc7m4nwnTX+5wqL6AX+4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
      "monotrail-utils-0.0.1" = "sha256-4x5jnXczXnToU0QXpFalpG5A+7jeyaEBt8vBwxbFCKQ=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };
=======
    rev = "b3fe43a4e462d10784258cad03c19c9738367346";
    hash = "sha256-q9/VUWyrP/NsuLYY1+/5teYvDJGq646WbMXptnUUUyw=";
  };

  cargoHash = "sha256-eyJ6gXFVnSC1aEt5YLl5rFoa3+M73smu5wJdAN15HQM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
<<<<<<< HEAD
  ++ lib.optionals stdenv.isDarwin [
    Libsystem
    SystemConfiguration
  ];

  checkFlags = [
    "--skip=utils::test_is_inside_git_work_tree"
  ];
=======
  ++ lib.optional stdenv.isDarwin SystemConfiguration;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
