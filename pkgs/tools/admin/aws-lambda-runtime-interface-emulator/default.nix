{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-vbVygZzLlJlxaRF/LIqSJP0gZGyu1wSSdeVjILl/OJE=";
  };

  vendorSha256 = "sha256-WcvYPGgkrK7Zs5IplAoUTay5ys9LrDJHpRN3ywEdWRM=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "To locally test their Lambda function packaged as a container image.";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
