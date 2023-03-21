{ lib, buildGoModule, fetchFromGitHub, less, more, installShellFiles, testers, jira-cli-go, nix-update-script }:

buildGoModule rec {
  pname = "jira-cli-go";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "v${version}";
    hash = "sha256-T7EAlHHjoACJOra47zp5tXrkYWQ8o9Qame6QmiTrIXY=";
  };

  vendorSha256 = "sha256-b/z2oSWY33XSxpHi+Tit2ThnNrdk5QNI4oZWPMBKmd0=";

  ldflags = [
    "-s" "-w"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=${src.rev}"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=0"
    "-X github.com/ankitpokhrel/jira-cli/internal/version.Version=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ less more ]; # Tests expect a pager in $PATH

  passthru = {
    tests.version = testers.testVersion {
      package = jira-cli-go;
      command = "jira version";
      inherit version;
    };
    updateScript = nix-update-script { };
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
    changelog = "https://github.com/ankitpokhrel/jira-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 anthonyroussel ];
  };
}
