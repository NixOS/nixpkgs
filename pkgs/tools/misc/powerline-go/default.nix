{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "powerline-go";
  version = "unstable-2021-07-15";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "f27435b26b5001c52ffb1aee454572c59494c81b";
    sha256 = "sha256-YB/WMprjXA5ZN6baT5nWahNj0xwbP8kzS7X/1tCwWiE=";
  };

  vendorSha256 = "sha256-HYF6aKz+P241EKmupEoretadlrh9FBRx6nIER66jofg=";

  doCheck = false;

  meta = with lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    homepage = "https://github.com/justjanne/powerline-go";
    changelog = "https://github.com/justjanne/powerline-go/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
