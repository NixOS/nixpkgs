{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
<<<<<<< HEAD
  version = "0.13.2";
=======
  version = "0.9.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-GiuP5Cx4Qx2LH34v6VeGyWgjJgPR8/qLUOZIrh9ES1U=";
=======
    hash = "sha256-4VPxeviXRWyP2pviNg5jST+uzvUA6gAoA/Fnt1daLYc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "char-name-0.1.0" = "sha256-txHvmD0ClTQqe6QhZ0DLgK5RON0UvZkxXCoZxC8U5+E=";
      "sml-libs-0.1.0" = "sha256-zQrhH24XlA9SeQ+sVzaVwJwrm80TRIjFq99Vay7QEN8=";
=======
      "char-name-0.1.0" = "sha256-hElcqzsfU6c6HzOqnUpbz+jbNGk6qBS+uk4fo1PC86Y=";
      "sml-libs-0.1.0" = "sha256-0gRiXJAGddrrbgI3AhlWqVKipNZI0OxMTrkWdcSbG7A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [ "--package" "millet-ls" ];

  cargoTestFlags = [ "--package" "millet-ls" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
<<<<<<< HEAD
    changelog = "https://github.com/azdavis/millet/blob/v${version}/docs/CHANGELOG.md";
=======
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "millet-ls";
  };
}
