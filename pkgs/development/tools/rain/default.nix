{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J0ZRJ05MDO92Oa/82FPM69Xrge1ATHF4kgNUd5YISFc=";
  };

  vendorHash = "sha256-M5LbB71fcEhXoDFd17TSruzl9y9tqiQpREwV/ZgvdQ4=";

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
