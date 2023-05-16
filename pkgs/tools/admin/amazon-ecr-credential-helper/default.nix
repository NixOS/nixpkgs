{ lib, buildGoModule, fetchFromGitHub, testers, amazon-ecr-credential-helper }:

buildGoModule rec {
  pname = "amazon-ecr-credential-helper";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Q+YAfCsq4/PoSzYMFhLDAsAfxlU7XR/vouHo42/D2eM=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-lkc8plWWmth8SjeWBCf1HTnCfg09QNIsN3xPePqnv6Y=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = "./ecr-login";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/awslabs/amazon-ecr-credential-helper/ecr-login/version.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = amazon-ecr-credential-helper;
    command = "docker-credential-ecr-login -v";
  };

  meta = with lib; {
    description = "The Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "docker-credential-ecr-login";
  };
}
