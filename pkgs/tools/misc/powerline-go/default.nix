{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qEVsJsDvqcMVxLz81kNybEO/TwCvhi8E/laci8ry/dw=";
  };

  vendorHash = "sha256-W7Lf9s689oJy4U5sQlkLt3INJwtvzU2pot3EFimp7Jw=";

  meta = with lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    homepage = "https://github.com/justjanne/powerline-go";
    changelog = "https://github.com/justjanne/powerline-go/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
    mainProgram = "powerline-go";
  };
}
