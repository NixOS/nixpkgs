{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-N5RTMShukJCiM0NYzFsANUDww8iLT/p7Li0hAXerjAM=";
  };

  vendorHash = "sha256-AZDbBFF7X247AYOVvJ5vuzuVqHqH6MbUylF5lRamzhU=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "To locally test their Lambda function packaged as a container image.";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
