{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7QhW0Vn1u63N0fzSiX/vu0HNhFkoSFHXteJCrcFX+4Q=";
  };

  vendorSha256 = "sha256-+R+UwoYJ+KsV+jQj8+wfEsCAvezolsoPDNzCnGLzOEc=";

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
