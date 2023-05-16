{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
<<<<<<< HEAD
  version = "3.1.2";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rm3j1exvdlJtMXgFeRmzr3YU/sLpQFL3PCa8kLVlinM=";
  };

  cargoHash = "sha256-rHrdGL/2diBwsWJyg7gaa6UmcUdvGhUPhLNESSBvDDg=";
=======
    hash = "sha256-Bn3gW8jfiX7tuANktAKO5ceokFtvURy2UZoL0+IBPaM=";
  };

  cargoHash = "sha256-Z3R8EmclmEditbGBb1Dd1hgGm34boCSI/fh3TBXxMG0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "erd";
  };
}
