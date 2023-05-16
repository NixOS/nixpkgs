<<<<<<< HEAD
{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Cocoa
, CoreServices
, Foundation
, rust
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.4.1";
=======
{ stdenv, lib, rustPlatform, fetchFromGitHub, Cocoa, CoreServices, Foundation, rust, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7nln9kuEVt8/NQ3BDdezSNfTyYo6qL2P2m5ZhQ7dAI8=";
  };

  cargoHash = "sha256-0D+aM/zap5UDQ+k9c/p+ZfN1OUjDzFRArvcmqEOcBbM=";
=======
    hash = "sha256-YwiTzIO60ct076vMoK9BHKa65Qet2PAvPRwnZcjDgcM=";
  };

  cargoHash = "sha256-BzcKWQSB94H3XOsbwNvJoAHlZwkJvLABIrfFh9Ugfig=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa CoreServices Foundation libiconv ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${rust.toRustTarget stdenv.hostPlatform}/release:$PATH"
  '';

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
<<<<<<< HEAD
    homepage = "https://github.com/watchexec/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan matthiasbeyer ];
=======
    homepage = "https://github.com/passcod/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
