{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
<<<<<<< HEAD
  version = "0.4.33";
=======
  version = "0.4.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-EgUnVnSELdiRU63saQ0o2IE4vs6tcQ/AfE4aMyegJBk=";
  };

  cargoHash = "sha256-zq95Dzcbz08/8lumAyTfSzCEHCWWlp8Fw7R6fnfTOrk=";
=======
    hash = "sha256-8FpNUCOK0vAyO7f1Uy+BaqDcZ0GEFvp7meULHtUncNA=";
  };

  cargoHash = "sha256-uIB+fMSVZGZ7OTgiTEeozjPR6CuMsLgEbq/9//of6xo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
