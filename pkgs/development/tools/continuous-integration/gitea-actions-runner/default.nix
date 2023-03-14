{ lib, fetchFromGitea, buildGoModule }:

buildGoModule rec {
  pname = "gitea-actions-runner";
  version = "unstable-2023-02-08";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "990cf93c7136669408eb1832cd05df3ad4dd81b3";
    sha256 = "1ysp7g199dzh1zpxxhki88pn96qghln7a5g8zfjip9173q1rgiyb";
  };

  vendorSha256 = "0a3q7rsk37dc6v3vnqaywkimaqvyjmkrwljhcjcnswsdfcgng62b";

  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    homepage = "https://gitea.com/gitea/act_runner";
    description = "A runner for Gitea based on act";
  };
}
