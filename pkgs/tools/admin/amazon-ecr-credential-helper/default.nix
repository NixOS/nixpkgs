{ buildGoPackage, fetchFromGitHub, lib, ... }:

buildGoPackage rec {
  pname = "amazon-ecr-credential-helper";
  version = "0.4.0";

  goPackagePath = "github.com/awslabs/amazon-ecr-credential-helper";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "amazon-ecr-credential-helper";
    rev = "v${version}";
    sha256 = "1whwxjzlyzyvrf2mzbd7my2kdz5fdbr79g18g9h4xrg8xyzk1k5q";
  };

  meta = with lib; {
    description = "The Amazon ECR Docker Credential Helper is a credential helper for the Docker daemon that makes it easier to use Amazon Elastic Container Registry";
    homepage = "https://github.com/awslabs/amazon-ecr-credential-helper";
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
