{ buildGoPackage, fetchFromGitHub, lib, ... }:

buildGoPackage rec {
  name = "amazon-ecr-credential-helper-${version}";
  version = "0.3.0";

  goPackagePath = "github.com/awslabs/amazon-ecr-credential-helper";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
    sha256 = "06pcwgahcbi13ca5rs6giwdw3w364lbvmzcs4ka82igvcffxjvnd";
  };

  meta = with lib; {
    description = "The Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = https://github.com/awslabs/amazon-ecr-credential-helper;
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
