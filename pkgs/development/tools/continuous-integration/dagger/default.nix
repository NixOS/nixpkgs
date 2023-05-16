{ lib, buildGoModule, fetchFromGitHub, testers, dagger }:

buildGoModule rec {
  pname = "dagger";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iFuPbSat555QHPqqP6j/6uTid19x1+OtRHADmGxTYzs=";
  };

  vendorHash = "sha256-DWmHq8BIR00QTh3ZcbEgTtbHwTmsMFAhV7kQVRSKNdQ=";
=======
    hash = "sha256-vFKq7sa41KSfV4+vgsZLEfiF2iwd4O6BwXkVXQPJ7n0=";
  };

  vendorHash = "sha256-/S72x0KqEKIRiRP66InZcQaTvRY1kQRTvs+Ceo0bMCA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  proxyVendor = true;

  subPackages = [
    "cmd/dagger"
  ];

<<<<<<< HEAD
  ldflags = [ "-s" "-w" "-X github.com/dagger/dagger/engine.Version=${version}" ];
=======
  ldflags = [ "-s" "-w" "-X=github.com/dagger/dagger/internal/engine.Version=${version}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests.version = testers.testVersion {
    package = dagger;
    command = "dagger version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}
