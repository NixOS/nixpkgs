{ lib
, buildGoModule
, fetchFromGitHub
, testers
, scip
}:

buildGoModule rec {
  pname = "scip";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip";
    rev = "v${version}";
    hash = "sha256-o7DWSFd3rPSAOmhTvtI9X0tySNhDL7Jh7iDW8eIYn3w=";
  };

  vendorHash = "sha256-iFlbZvbj30UpgxJdndpLYcUZSTLQAO2MqJGb/6hO8Uc=";

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
    mainProgram = "scip";
    homepage = "https://github.com/sourcegraph/scip";
    changelog = "https://github.com/sourcegraph/scip/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
