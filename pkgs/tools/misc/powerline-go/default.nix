{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IO3I5lvPdN73EF+S5Xo+TMEYaBtd1pOGMs+aQtRnHjE=";
  };

  vendorSha256 = "sha256-HYF6aKz+P241EKmupEoretadlrh9FBRx6nIER66jofg=";

  doCheck = false;

  meta = with lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
