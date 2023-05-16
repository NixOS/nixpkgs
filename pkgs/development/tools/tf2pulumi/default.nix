{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tf2pulumi";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "tf2pulumi";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-i6nK1AEnQY47ro6tNDBExdcb9WvltY/21FVrVaiSTvo=";
  };

  vendorHash = "sha256-x7GAkbvhML2VUQ9/zitrTBBiy9lISb3iTx6yn5WbEig=";
=======
    sha256 = "sha256-4sEsWMkGRpB3gMGUOPh7n/nNwEp+ErKQK0qcT5ImaZ4=";
  };

  vendorSha256 = "sha256-wsgNrDnFXbpanEULEjf6OxOeMYmWzjE7vpVUB/UFNp8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w" "-X=github.com/pulumi/tf2pulumi/version.Version=${src.rev}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert Terraform projects to Pulumi TypeScript programs";
    homepage = "https://www.pulumi.com/tf2pulumi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
