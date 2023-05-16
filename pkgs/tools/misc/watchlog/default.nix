{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchlog";
<<<<<<< HEAD
  version = "1.213.0";
=======
  version = "1.197.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-UNywUEhhJy2cJIwl/S9hRReoBfkzvNoN0c4mxp7PuG0=";
  };

  cargoSha256 = "sha256-HBlfSgR96XIUBj2ZyHi1qaEKP8jG9kcrxJmhIGWjfUE=";
=======
    sha256 = "sha256-6/SF+bsf4KAVdbda8AmeNxZiOZsyU2MfGmR4b+geETE=";
  };

  cargoSha256 = "sha256-8lBHsWGzu0h+hHsFK4DuPz6cTsgOT3JZFbsecJskdok=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Easier monitoring of live logs";
    homepage = "https://gitlab.com/kevincox/watchlog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];

    # Dependency only supports Linux + Windows: https://github.com/mentaljam/standard_paths/tree/master/src
    platforms = with lib.platforms; linux ++ windows;
<<<<<<< HEAD
    mainProgram = "wl";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
