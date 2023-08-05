{ lib
, fetchFromGitea
, buildGoModule
, testers
, gitea-actions-runner
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "0.2.3";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-RNH/12XV07nWhGnmR4FKJSSK/KnLA76+pKFHTPG8AAk=";
  };

  vendorHash = "sha256-VS1CIxV0e01h5L1UA4p8R1Z28yLOEZTMxS+gbEaJwKs=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gitea-actions-runner;
    version = "v${version}";
  };

  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/v${version}";
    homepage = "https://gitea.com/gitea/act_runner";
    description = "A runner for Gitea based on act";
  };
}
