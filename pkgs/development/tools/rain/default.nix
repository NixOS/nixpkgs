{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0QWWoydlo1MH2PxBdYC9qdO0M5MGnEN0+QrH3fPz/n4=";
  };

  vendorHash = "sha256-SJKiIqtrTuJxZAq/mamgB5EG1IOhYV1RfY8C/f3Xiac=";

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
