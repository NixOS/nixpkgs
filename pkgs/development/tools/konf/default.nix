{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, konf
}:

buildGoModule rec {
  pname = "konf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SimonTheLeg";
    repo = "konf-go";
    rev = "v${version}";
    hash = "sha256-8TXr/jYMl3NLERtLkm7qG97IL/idz4xxP0g0LEy4/j8=";
  };

  vendorHash = "sha256-sB3j19HrTtaRqNcooqNy8vBvuzxxyGDa7MOtiGoVgN8=";

  ldflags = [
    "-s" "-w"
    "-X github.com/simontheleg/konf-go/cmd.gitcommit=unknown"
    "-X github.com/simontheleg/konf-go/cmd.builddate=unknown"
    "-X github.com/simontheleg/konf-go/cmd.gitversion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME=$(mktemp -d)
    $out/bin/konf-go completion bash > konf-go.bash
    $out/bin/konf-go completion zsh > konf-go.zsh
    installShellCompletion --cmd konf-go --bash konf-go.bash --zsh konf-go.zsh
  '';

  passthru.tests.version = testers.testVersion {
    package = konf;
    command = "HOME=$(mktemp -d) ${konf}/bin/konf-go version";
  };

  meta = with lib; {
    description = "Lightweight and blazing fast kubeconfig manager which allows to use different kubeconfigs at the same time";
    homepage = "https://github.com/SimonTheLeg/konf-go";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
  };
}
