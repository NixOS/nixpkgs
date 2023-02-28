{ lib
, buildGoModule
, fetchFromGitHub
, testers
, rain
}:

buildGoModule rec {
  pname = "rain";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KniCMsUspZ8+7dSDPdaagdEbQQA8ixMVS1X1VKzpw9g=";
  };

  vendorHash = "sha256-IdtV0lw7DCmuRwpZXv9LA9+xc/z/OrQvZJU2BqFw9vk=";

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
