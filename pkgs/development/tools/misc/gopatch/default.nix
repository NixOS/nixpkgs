{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gopatch
}:

buildGoModule rec {
  pname = "gopatch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "gopatch";
    rev = "v${version}";
    hash = "sha256-iiVp/Aa4usShTQD/15zYk7/WQoQL/ZxVDPWYoi3JLW4=";
  };

  vendorHash = "sha256-Pm5RNOx54IW7L9atfVTiMkvvzFt7yjqnYu99YiWFhPA=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gopatch;
    };
  };

  meta = with lib; {
    description = "Refactoring and code transformation tool for Go";
    homepage = "https://github.com/uber-go/gopatch";
    changelog = "https://github.com/uber-go/gopatch/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
