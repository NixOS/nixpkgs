{ lib
, buildGoModule
, fetchFromGitHub
, testers
, kool
}:

buildGoModule rec {
  pname = "kool";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    rev = version;
    hash = "sha256-YVgUKA7bMcncZDYaxaN2kCbE3JUmM9aM3GoQkOXEWpA=";
  };

  vendorHash = "sha256-zsrqppHl7Z8o+J1SzZnv1jOdPO04JaF1K38a//+uAxU=";

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
