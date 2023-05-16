{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
<<<<<<< HEAD
  version = "1.8.4";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wjCehdCZR/97nD4HsTZCiVZZb2GQaOTfyU72Ez5kjW8=";
  };

  cargoHash = "sha256-Wis6C4Wlz7NScFeKXWODA8BKmRtL7adaYxPVR13wNsg=";
=======
    sha256 = "sha256-ESImTR3CFe6ABCP7JHU7XQYvc2VsDN03lkVaKK9MUEU=";
  };

  cargoHash = "sha256-vqRVD5RW0j2bMF/Zl+Ldc06zyDlzRpADWqxtkvKtydE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
