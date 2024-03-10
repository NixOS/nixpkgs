{ lib
, buildGoModule
, fetchFromGitea
, testers
, forgejo-actions-runner
}:

buildGoModule rec {
  pname = "forgejo-actions-runner";
  version = "3.3.0";

  src = fetchFromGitea {
    domain = "code.forgejo.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-ZpsHytsIp+ZW4DI7X9MmI7nZRnXVHvx905YdZGS6WMY=";
  };

  vendorHash = "sha256-5GnGXpMy1D7KpVAVroX07Vw5QKYYtwdIhQsk23WCLgc=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${src.rev}"
  ];

  doCheck = false; # Test try to lookup code.forgejo.org.

  passthru.tests.version = testers.testVersion {
    package = forgejo-actions-runner;
    version = src.rev;
  };

  meta = with lib; {
    description = "A runner for Forgejo based on act";
    homepage = "https://code.forgejo.org/forgejo/runner";
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "act_runner";
  };
}
