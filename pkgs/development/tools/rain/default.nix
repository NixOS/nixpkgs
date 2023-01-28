{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6YKZy6sdy1Yi2cDaLMA54GBTZ9uPhYi5Cq5QqCGbD5k=";
  };

  vendorSha256 = "sha256-e3R8+xarofbx3Ky6JIfDbysTQETCUaQj/QmzAiU7fZk=";

  subPackages = [ "cmd/rain" ];

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A development workflow tool for working with AWS CloudFormation";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.unix;
  };
}
