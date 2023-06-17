{ lib
, fetchFromGitea
, buildGoModule
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "0.1.8";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
    hash = "sha256-J67g0jy/5Dfmvu3bSPqH+r9+MuLyl2lZyEZrOovfNJI=";
  };

  vendorHash = "sha256-Ik4n1oB6MWE2djcM5CdDhJKx4IJsZu7eJr5St+T67B4=";

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
