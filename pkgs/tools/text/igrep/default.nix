{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
, testers
, igrep
}:

rustPlatform.buildRustPackage rec {
  pname = "igrep";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-L5mHuglU0CvTi02pbR8xfezBoH8L/DS+7jgvYvb4yro=";
  };

  cargoHash = "sha256-k63tu5Ffus4z0yd8vQ79q4+tokWAXD05Pvv9JByfnDg=";
=======
    sha256 = "sha256-g6DY3+HwBNQ+jxByXyTJK5CjAaC48FpmsDf1qGGO/Lk=";
  };

  cargoHash = "sha256-7cSUIwWyWPxFDuRWplidbI93zbBV84T7e4Q//Uwj6N4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  passthru.tests = {
    version = testers.testVersion { package = igrep; command = "ig --version"; };
  };

  meta = with lib; {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    changelog = "https://github.com/konradsz/igrep/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "ig";
  };
}
