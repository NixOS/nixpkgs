{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kool
}:

buildGoModule rec {
  pname = "kool";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-Gtw+47EQVPxiW9xjY/cWlE4aJ1aYYhpvsVQzt0EnI8I=";
  };

  vendorHash = "sha256-8t+OZB9jrlOVHLURPmtz0ent6COEOVMFfObe2LH1jRM=";

  ldflags = [
    "-s"
    "-w"
    "-X=kool-dev/kool/commands.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = kool;
    };
  };

  meta = with lib; {
    description = "From local development to the cloud: development workflow made easy";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
