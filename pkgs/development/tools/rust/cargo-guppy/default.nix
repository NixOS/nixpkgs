{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-guppy";
<<<<<<< HEAD
  version = "unstable-2023-07-29";
=======
  version = "unstable-2023-04-15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
<<<<<<< HEAD
    rev = "7c7f352d9d2dea1007b4475d4a76f86f061b6ba9";
    sha256 = "sha256-H2vU7qax0P8Ulh1/DHnlmGRqSqzLuRy9TZOvikSLONw=";
  };

  cargoSha256 = "sha256-lr7N/qqB1AwhNA+mbEAJFSp/rDxGp3qIGSKP9B3JAls=";
=======
    rev = "e93f51ca56dc9cc310004931a906b6b486b93058";
    sha256 = "sha256-kg1iWku+zAXG9cCYCD4rqKzKNtDt0hMCnE5QyhJpLq8=";
  };

  cargoSha256 = "sha256-XKAre9L2mk31CgXbP53zR8mr92Jh9qVSx+sMkhqq/M4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p" "cargo-guppy" ];
  cargoTestFlags = [ "-p" "cargo-guppy" ];

  meta = with lib; {
    description = "A command-line frontend for guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
