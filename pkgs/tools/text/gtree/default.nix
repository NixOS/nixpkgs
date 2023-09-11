{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gtree
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-CBD01MIKrd/KSQvJg9xyS7V/ed/nfQ2CQe8C3Z9+lwM=";
  };

  vendorHash = "sha256-QxcDa499XV43p8fstENOtfe3iZ176R5/Ub5iovXlYIM=";

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
