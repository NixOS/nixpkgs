{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gopatch
}:

buildGoModule rec {
  pname = "gopatch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "gopatch";
    rev = "v${version}";
    hash = "sha256-RodRDP7n1hxez+9xpRlguuArJDVaYxVTpnXKqsyqnUw=";
  };

  vendorHash = "sha256-vygEVVh/bBhV/FCrehDumrw2c1SdSZSdFjVSRoJsIig=";

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
