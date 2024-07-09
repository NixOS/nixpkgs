{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2W/Ytdnzb0+EAPsuN6LXX0eLQMOu3qetJKYvKzgB0jM=";
  };

  vendorHash = "sha256-Hpggkx707IX5ZUBuynQukCShk0pp12YEJYOF3eEN+5I=";

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
