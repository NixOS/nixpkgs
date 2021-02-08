{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pge57OXNE0MY2rlspVsqxdoe1r/XWjrq/q9ygdns2c8=";
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
