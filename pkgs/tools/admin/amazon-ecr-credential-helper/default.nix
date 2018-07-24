{ buildGoPackage, fetchFromGitHub, lib, ... }:

buildGoPackage rec {
  name = "amazon-ecr-credential-helper-${version}";
  version = "0.1.0";

  goPackagePath = "github.com/awslabs/amazon-ecr-credential-helper";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
    sha256 = "0mpwm21fphg117ryxda7696s8bnvi4bbc8rvi4zp2m1rhl04j2yy";
  };

  meta = with lib; {
    description = "The Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = https://github.com/awslabs/amazon-ecr-credential-helper;
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
