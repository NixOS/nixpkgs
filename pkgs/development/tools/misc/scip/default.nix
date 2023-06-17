{ lib
, buildGoModule
, fetchFromGitHub
, testers
, scip
}:

buildGoModule rec {
  pname = "scip";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    rev = "v${version}";
    hash = "sha256-0ErEA44vRRntWxajUKiQXqaKvQtqCPPXnI/sBktQyIo=";
  };

  vendorHash = "sha256-T0NYucDVBnTxROVYXlccOvHX74Cs6czXL/fy14I8MZc=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Reproducible=true"
  ];

  postInstall = ''
    mv $out/bin/{cmd,scip}
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
