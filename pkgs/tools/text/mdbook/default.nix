{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
<<<<<<< HEAD
  version = "0.4.34";
=======
  version = "0.4.28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-QkgsFnX6J0ZgXCzGE/dTNLxdXLhCFwLsZCvmZ4SU4Zs=";
  };

  cargoHash = "sha256-Dhblzn7NytYeY76RmvI8cNjChnCSnTPadxPKyU5QT1Q=";
=======
    sha256 = "sha256-9Otjl3JLEQo+WojUOu0XE1GH2P4LjKhaxSd1xoekXdk=";
  };

  cargoHash = "sha256-TViBclvCJeoOInTt13B7297JDtRkwvOjIf6AVAbpanU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = [ licenses.mpl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ havvy Frostman matthiasbeyer ];
=======
    maintainers = with maintainers; [ havvy Frostman ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
