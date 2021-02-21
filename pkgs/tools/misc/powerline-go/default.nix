{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Pge57OXNE0MY2rlspVsqxdoe1r/XWjrq/q9ygdns2c8=";
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
