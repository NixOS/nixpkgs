{ lib, buildGoModule, fetchFromGitHub, less, more, installShellFiles, testers, jira-cli-go }:

buildGoModule rec {
  pname = "jira-cli-go";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "v${version}";
    sha256 = "sha256-sPoFv3Gzue5H6TJuQZJvqB/Dx/URp9Kt2UuIvKSnAxg=";
  };

  vendorSha256 = "sha256-UO30/D65vpu3PgEsfSDL3nYgkwo5Cj+1WKiokk7KKKg=";

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
  '';

  meta = with lib; {
    description = "Feature-rich interactive Jira command line";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
