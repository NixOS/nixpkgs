{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gtree
}:

buildGoModule rec {
  pname = "gtree";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "ddddddO";
    repo = "gtree";
    rev = "v${version}";
    hash = "sha256-eU5mMUDUh5eMzd4oLc0XOHapt1hhODWXQJ+OJAy3tWc=";
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
