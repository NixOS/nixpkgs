{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
<<<<<<< HEAD
  version = "7.0.3";
=======
  version = "6.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = pname;
    rev = "jql-v${version}";
<<<<<<< HEAD
    hash = "sha256-9VQtPYAw/MtYZxfosWPQOy29YjvzVGP/mhje42dAb8U=";
  };

  cargoHash = "sha256-erGqHW3LyXTcy6MZH24F7OKknissH4es2VmWdEFwe0Y=";
=======
    hash = "sha256-/H4FkrwJ8xB5qiiewEmTwCwgbJRMdfHZ6ppn5+370Kk=";
  };

  cargoHash = "sha256-2TKwy983Ys9aSm8+jsUKv0nE3mV1h+uE4Xrch08dPMc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ akshgpt7 figsoda ];
<<<<<<< HEAD
    mainProgram = "jql";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
