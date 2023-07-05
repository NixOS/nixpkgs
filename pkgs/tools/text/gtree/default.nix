{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gtree
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-0jRCQsRiJbQQcz8d7rXkAk4W4EurJ5OOcMAUn11k+ko=";
  };

  vendorHash = "sha256-BMfJFR4sqJNNlJ7Y3q2GlXWjMDH+DXhuFQVX5I9Czkc=";

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
