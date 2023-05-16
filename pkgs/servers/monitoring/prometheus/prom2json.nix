{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prom2json";
<<<<<<< HEAD
  version = "1.3.3";
=======
  version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
<<<<<<< HEAD
    sha256 = "sha256-VwJv2Y+YrlhLRx0lRPtHTzjvSz7GPfADCZibkQU6S1Y=";
  };

  vendorHash = "sha256-m9f3tCX21CMdcXcUcLFOxgs9oDR2Uaj5u22eJPDmpeE=";
=======
    sha256 = "sha256-5RPpgUEFLecu0qRg7KSNLwdUEiXeebrGdP/udCtq4z0=";
  };

  vendorSha256 = "sha256-fPGkqrnl21as1xiT279qPzkz01tDNOSMcsm/DSNHDU0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
