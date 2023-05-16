{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kaf";
<<<<<<< HEAD
  version = "0.2.6";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BH956k2FU855cKT+ftFOtRR2IjQ4sViiGy0tvrMWpEQ=";
  };

  vendorHash = "sha256-Y8jma4M+7ndJARfLmGCUmkIL+Pkey599dRO7M4iXU2Y=";
=======
    sha256 = "sha256-5wSxaryaQ8jXwpzSltMmFRVrvaA9JMSrh8VBCnquLXE=";
  };

  vendorSha256 = "sha256-Jpv02h+EeRhVdi/raStTEfHitz0A71dHpWdF/zcVJVU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}
