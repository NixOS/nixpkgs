{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
    sha256 = "sha256-sRb1JYSAveei/X1m5/xfuGZFUwBopczrz1n+8gn4eKw=";
  };

  vendorSha256 = "sha256-9aSALE42M/DoQS4PBHIVNDKzNdL5UhdXKAmLUSws3+Y=";

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "To locally test their Lambda function packaged as a container image.";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
