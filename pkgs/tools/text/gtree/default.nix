{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gtree
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-KFEYkhCLMcJ4NkHu0kkuG70EvJQ3HYDvicmomcMJZjc=";
  };

  vendorHash = "sha256-rvVrVv73gW26UUy1MyxKDjUgX1mrMMii+l8qU2hLOek=";

  subPackages = [
    "cmd/gtree"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = gtree;
    };
  };

  meta = with lib; {
    description = "Generate directory trees and directories using Markdown or programmatically";
    homepage = "https://github.com/ddddddO/gtree";
    changelog = "https://github.com/ddddddO/gtree/releases/tag/${src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
