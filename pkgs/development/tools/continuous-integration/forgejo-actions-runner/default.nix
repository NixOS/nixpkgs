{ lib
, buildGoModule
, fetchFromGitea
, testers
, forgejo-actions-runner
}:

buildGoModule rec {
  pname = "forgejo-actions-runner";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "runner";
    rev = "v${version}";
    hash = "sha256-idA74R6kbI7Bk0XvT7BOyctT0IKymsJoFCWgYrtZstU=";
  };

  vendorHash = "sha256-HE//SD/doMf42y2KF10JAuUe86hpFhCUM61da2NC5CE=";

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
