{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pJpxkmXviTUM5PtnR/jQLFz9HBXeRI9BcXwuD0WmM8s=";
  };

  vendorHash = "sha256-NcM+SdIgqtSRg7Fcwml/V73qYHcowBdOtmuF7EMSBB8=";

  subPackages = [ "cmd/rain" ];

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
