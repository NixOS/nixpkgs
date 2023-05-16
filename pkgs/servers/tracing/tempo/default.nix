{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tempo";
<<<<<<< HEAD
  version = "2.2.2";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-FeQTg0EuAwpSMf+rPLFNegXEXfVa6dqR2xjl4MfZnYg=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-gnQAldqfxJk8kbXAyX1VQXddCnSBWnvc3wesYoYI7wI=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-serverless"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${version}"
  ];

  # tests use docker
  doCheck = false;

  meta = with lib; {
    description = "A high volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
