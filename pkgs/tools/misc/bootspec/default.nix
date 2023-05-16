{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5IGSMHeL0eKfl7teDejAckYQjc8aeLwfwIQSzQ8YaAg=";
  };

  cargoHash = "sha256-eGSKVHjPnHK7WyGkO5LIjocNGHawahYQR3H5Lgk1C9s=";
=======
    hash = "sha256-6hgC/bOtzmVu+/pSVMpW4IkwNNemI2k/ykzxCibQUok=";
  };

  cargoHash = "sha256-l9W7MzeL1kiTvNe7QbP2bt8vqbnGrqK44UTlRRNRcYw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
    platforms = platforms.unix;
  };
}
