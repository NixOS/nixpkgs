{ lib, fetchFromGitea, buildGoModule }:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "unstable-2023-03-18";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "9eb8b08a69e8b1c699c9c07a06c1ff8e5f6ad0fe";
    sha256 = "sha256-B8vD+86X8cqZhPmDmEjHgSsq3TdJuCf9h3XgdXC7hQY=";
  };

  vendorSha256 = "sha256-K/d/ip8icc+rjTmajsGxw5aij1VMW6wJJu4LCkKqaVQ=";

  ldflags = [
    "-s"
    "-w"
    "-X gitea.com/gitea/act_runner/cmd.version=${version}"
  ];

  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    homepage = "https://gitea.com/gitea/act_runner";
    description = "A runner for Gitea based on act";
  };
}
