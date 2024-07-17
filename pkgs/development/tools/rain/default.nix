{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wQ767MgLSdcNm3Z1HL8VgmUk2tMFmIyACMaMhPr4lmY=";
  };

  vendorHash = "sha256-SXgyxf8pqSZzlMoOissGLBfeXueY4aSkCcd7ahT2KMA=";

  subPackages = [ "cmd/rain" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
