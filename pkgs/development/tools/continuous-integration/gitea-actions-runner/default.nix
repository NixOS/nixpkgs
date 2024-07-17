{
  lib,
  fetchFromGitea,
  buildGoModule,
  testers,
  gitea-actions-runner,
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "0.2.10";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-YRWFBMHw9Fcmzkmglh2I1kXJkAAivqvCBcenLTjE/bI=";
  };

  vendorHash = "sha256-8sdSQhg9DnRLgghDZzWrUMM4vjinhCgu3dTKU7MBVQU=";

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
