{ lib
, buildGoModule
, fetchFromGitHub
, testers
, scip
}:

buildGoModule rec {
  pname = "scip";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    rev = "v${version}";
    hash = "sha256-aSApi6fEKQP5bpuda2Zz6i/5xkyH+mxch803toJsZm8=";
  };

  vendorHash = "sha256-3Tq2cexcxHjaH6WIz2hneE1QeBSGoMINBncKbqxODxQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Reproducible=true"
  ];

  # update documentation to fix broken test
  postPatch = ''
    substituteInPlace docs/CLI.md \
      --replace 0.3.0 0.3.1
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = scip;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "SCIP Code Intelligence Protocol CLI";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
