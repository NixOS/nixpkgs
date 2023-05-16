{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ttchat";
<<<<<<< HEAD
  version = "0.1.10";
=======
  version = "0.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "atye";
    repo = "ttchat";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Ezlqji/j6nyCzc1jrfB1MZR4ugKAa5D5CL6wfuP6PsY=";
  };

  vendorHash = "sha256-6GcbEGC1O+lcTO+GsaVXOO69yIHMPywXJy7OFX15/eI=";
=======
    sha256 = "sha256-+fPARVS1ILxrigHpvb+iNqz7Xw7+c/LmHJEeRxhCbhQ=";
  };

  vendorSha256 = "sha256-XWCjnHg0P7FCuiMjCV6ijy60h0u776GyiIC/k/KMW38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Connect to a Twitch channel's chat from your terminal";
    homepage = "https://github.com/atye/ttchat";
    license = licenses.asl20;
<<<<<<< HEAD
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
