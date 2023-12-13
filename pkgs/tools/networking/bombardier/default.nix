{ lib
, buildGoModule
, fetchFromGitHub
, testers
, bombardier
}:

buildGoModule rec {
  pname = "bombardier";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "codesenberg";
    repo = "bombardier";
    rev = "v${version}";
    hash = "sha256-sJ5+nxfyWSN6dFlA4INaqa3UHTY7huYkZhaTidMJFAs=";
  };

  vendorHash = "sha256-SxW/87l1w86H5cxEhiF/Fj8SxJ/uAfhtc7I1DVvIilk=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    version = testers.testVersion {
      package = bombardier;
    };
  };

  meta = with lib; {
    description = "Fast cross-platform HTTP benchmarking tool written in Go";
    homepage = "https://github.com/codesenberg/bombardier";
    changelog = "https://github.com/codesenberg/bombardier/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
