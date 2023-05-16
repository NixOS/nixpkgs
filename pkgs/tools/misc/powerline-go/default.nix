{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "powerline-go";
<<<<<<< HEAD
  version = "1.24";
=======
  version = "1.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3IeyxAc+FRcVsL9AiVr6Jku5f5y3MTT9SXwVQW9MkNo=";
=======
    hash = "sha256-qEVsJsDvqcMVxLz81kNybEO/TwCvhi8E/laci8ry/dw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-W7Lf9s689oJy4U5sQlkLt3INJwtvzU2pot3EFimp7Jw=";

  meta = with lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    homepage = "https://github.com/justjanne/powerline-go";
    changelog = "https://github.com/justjanne/powerline-go/releases/tag/v${version}";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ sifmelcara ];
    mainProgram = "powerline-go";
  };
}
