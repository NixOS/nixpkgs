<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.10.1";
=======
{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-P1NWkqRotL8h87iqxdVJhGVy9dw47fXeL10db1xsk00=";
  };

  cargoHash = "sha256-ZsY3PwbjNILYR+dYSp1RVqw0QV9PVB5bPSX1RdVUZUg=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];
=======
    sha256 = "sha256-v3dC5Qi0Op+oFCcbkbK1ZUQxWTEYVvXsc+ye9Kk9y7c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "regex-syntax-0.6.28" = "sha256-FltQ1TfA4XV+jC3dQZf7soTHc8R/nSwToPGcQUVwVYs=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
<<<<<<< HEAD
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
    mainProgram = "jaq";
=======
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
