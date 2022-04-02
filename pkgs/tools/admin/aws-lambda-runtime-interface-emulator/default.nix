{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-h4T4Go5gzKF1g1jSNZkx5U0icFxEZMYyS4L6cZMTFEY=";
  };

  vendorSha256 = "sha256-ncUtJKJnWiut0ZVKm3MLWKq8eyHrTgv6Nva8xcvvqSI=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "To locally test their Lambda function packaged as a container image.";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
