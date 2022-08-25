{ lib, buildGoModule, fetchFromGitHub, less, more, installShellFiles, testers, jira-cli-go }:

buildGoModule rec {
  pname = "jira-cli-go";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "v${version}";
    sha256 = "sha256-UpDaKg6TA1qCkbzF7BARtj+tAyuCCGAyqOdItZU64Ls=";
  };

  vendorSha256 = "sha256-SpUggA9u8OGV2zF3EQ0CB8M6jpiVQi957UGaN+foEuk=";

  ldflags = [
    "-s" "-w"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=${src.rev}"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=0"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.Version=${version}"
  ];

  checkInputs = [ less more ]; # Tests expect a pager in $PATH

  passthru.tests.version = testers.testVersion {
    package = jira-cli-go;
    command = "jira version";
    inherit version;
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd jira \
      --bash <($out/bin/jira completion bash) \
      --zsh <($out/bin/jira completion zsh)

    $out/bin/jira man --generate --output man
    installManPage man/*
  '';

  meta = with lib; {
    description = "Feature-rich interactive Jira command line";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 anthonyroussel ];
  };
}
