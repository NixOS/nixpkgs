{ lib
, fetchFromGitea
, buildGoModule
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-0wLBFZdFaGTselRZIJ809wHQFhAjt4sdmZp12LQOB9I=";
  };

  vendorHash = "sha256-GBqt5qSM2mDAS7klWdJiC6t5HaVKaP0PjecYnHZBzrc=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${version}"
  ];

  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/v${version}";
    homepage = "https://gitea.com/gitea/act_runner";
    description = "A runner for Gitea based on act";
  };
}
