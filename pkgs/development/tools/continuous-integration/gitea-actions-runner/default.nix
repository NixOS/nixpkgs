{ lib
, fetchFromGitea
, buildGoModule
, testers
, gitea-actions-runner
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "0.2.6";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-GE9yqp5zWJ4lL0L/w3oSvU72AiHBNb+yh2qBPKPe9X0=";
  };

  vendorHash = "sha256-NoaLq5pCwTuPd9ne5LYcvJsgUXAqcfkcW3Ck2K350JE=";

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
