{ buildGoPackage, fetchFromGitHub, lib, ... }:

buildGoPackage rec {
  pname = "amazon-ecr-credential-helper";
  version = "0.5.0";

  goPackagePath = "github.com/awslabs/amazon-ecr-credential-helper";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
    sha256 = "sha256-GmGse+N7QeG2sAjCumGkUAWu/KfhnMltzeh+s8o+tiw=";
  };

  meta = with lib; {
    description = "The Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
