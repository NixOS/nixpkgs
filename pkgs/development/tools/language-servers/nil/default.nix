<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub, nixVersions, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-08-09";
=======
{ lib, rustPlatform, fetchFromGitHub, nix, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2023-05-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-fZ8KfBMcIFO/R7xaWtB85SFeuUjb9SCH8fxYBnY8068=";
  };

  cargoHash = "sha256-lyKPmzuZB9rCBI9JxhxlyDtNHLia8FXGnSgV+D/dwgo=";

  nativeBuildInputs = [
    (lib.getBin nixVersions.unstable)
  ];

  env.CFG_RELEASE = version;

=======
    hash = "sha256-Xg3Cux5wQDatXRvQWsVD0YPfmxfijjG8+gxYqgoT6JE=";
  };

  cargoHash = "sha256-N7flQRIc0CXTuKjy9tVZapu+CXUT4rg66VLLT/vMUoc=";

  CFG_RELEASE = version;

  nativeBuildInputs = [
    (lib.getBin nix)
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda oxalica ];
<<<<<<< HEAD
    mainProgram = "nil";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
