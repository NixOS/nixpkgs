{ lib, buildGoModule, fetchFromGitHub, testers, flyctl, installShellFiles }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.424";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "sha256-VipCiWSuC1SSJPWk9WXgcMd0G0C2TsUSQgW2GM9yAII=";
  };

  vendorSha256 = "sha256-a0ZnZlKB/Uotrm4npXB1dd1+oWHRhJVW7ofMSKlqcvM=";

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/superfly/flyctl/internal/buildinfo.commit=${src.rev}"
    "-X github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z"
    "-X github.com/superfly/flyctl/internal/buildinfo.environment=production"
    "-X github.com/superfly/flyctl/internal/buildinfo.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    go generate ./...
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    go test ./... -ldflags="-X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z'"
  '';

  postInstall = ''
    installShellCompletion --cmd flyctl \
      --bash <($out/bin/flyctl completion bash) \
      --fish <($out/bin/flyctl completion fish) \
      --zsh <($out/bin/flyctl completion zsh)
    ln -s $out/bin/flyctl $out/bin/fly
  '';

  passthru.tests.version = testers.testVersion {
    package = flyctl;
    command = "HOME=$(mktemp -d) flyctl version";
    version = "v${flyctl.version}";
  };

  meta = with lib; {
    description = "Command line tools for fly.io services";
    downloadPage = "https://github.com/superfly/flyctl";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse jsierles techknowlogick viraptor ];
  };
}
