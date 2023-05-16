{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
<<<<<<< HEAD
  version = "0.3.28";
=======
  version = "0.3.27";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-HNM487WSfNWNF31ccDIdotsEG8Mj2C7V85UI47a9drU=";
  };

  vendorHash = "sha256-ptC2G7cXcAjthJcAXvuBqI2ZpPuSMBqzO+gJiyaAUP0=";
=======
    sha256 = "sha256-F1/1wMO2lQ4v2+r3FPzaxCkL2lW+COgxy4fjv6+p7AY=";
  };

  vendorHash = "sha256-ea+1AV0WzaQiDHyAUsm0rd/bznehG9UtmB1ubgHrOGM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "A tool to list and diagnose Go processes currently running on your system";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
