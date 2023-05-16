{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "slsa-verifier";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "slsa-framework";
    repo = "slsa-verifier";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2/4ExhMWXIKpkYQIodEsajA7q9zb4tOT9QUGunAutl0=";
  };

  vendorHash = "sha256-TwPbxoNu9PYAFEbUT5htyUY1RbkGow712ARJW6y496E=";
=======
    hash = "sha256-qhBMWYyd2S8ZKAqwMkXWTP84kLt3f4471JOPrfScFek=";
  };

  vendorHash = "sha256-9EY7zhvDgZsNQA7iNu1zueJxpTA6cLwjpQYjUdUy6do=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;
  GO111MODULE = "on";
  GOFLAGS = "-trimpath";

  subPackages = [ "cli/slsa-verifier" ];

  tags = [ "netgo" ];

  ldflags = [
    "-s"
    "-w"
    "-buildid="
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/slsa-framework/slsa-verifier";
    changelog = "https://github.com/slsa-framework/slsa-verifier/releases/tag/v${version}";
    description = "Verify provenance from SLSA compliant builders";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ developer-guy mlieberman85 ];
  };
}
