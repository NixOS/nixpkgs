{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
<<<<<<< HEAD
  version = "0.5.5";
=======
  version = "0.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TeXEfcmDHKgy5mGdixrIecxKO1rrg7+EWRIqzMYh3sU=";
=======
    sha256 = "sha256-sVXLcz//1RLYOmKtH6u4tCPS8oqV0vOkmQLpWNBiUQY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-TXFwfqyvCAEn24vtUBcFABzIg0KaYlstiFwS7y6WbKo=";
=======
  vendorSha256 = "sha256-uyjj0Yh/bIvWvh76TEasgjJg9Dgj/GHgn3BOsO2peT0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut mvisonneau ];
  };
}
