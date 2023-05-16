{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
<<<<<<< HEAD
    hash = "sha256-DpdozP/xaMoRAl8YMj5BmhNedGFhVzscM/eFOcVt+Lk=";
  };

  cargoHash = "sha256-zKJ8A36/ibAiznm3bK2JSHVRItIAqQ4YFDxvjcZLn3g=";
=======
    hash = "sha256-dc1jN9phrTfLwa6Dx1liXNu49V2qjpiuHqn4KQnPYWQ=";
  };

  cargoHash = "sha256-1Oa4R85w5FyC6rjoZe53bJIykSSkUv2X3LQvK4w+qs0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}
