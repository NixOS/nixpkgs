{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-2bh4wNP8sQcojjjbx5DQctlkwCTYcPdSkpW4OCOyp9k=";
  };

  cargoHash = "sha256-C8SUceX9RwUyiCknmuRfBqG0vjesS54bZQHwi7krwKo=";
=======
    hash = "sha256-ABdG1FKgFF/vMkAQl2tk8FcnSzC4Z3r9E67ZwAGPt8U=";
  };

  cargoHash = "sha256-1H3JHZbG8k15Qfpsk+XykmbotHcO+J4zTbwdlOR2kso=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
