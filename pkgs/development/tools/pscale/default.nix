{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, pscale
, testers
}:

buildGoModule rec {
  pname = "pscale";
  version = "0.145.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-0X+cYDlc7yIJTA4O06Y5roj6bL7mQlZK7jIAs0RbM7U=";
  };

  vendorHash = "sha256-brfrAD4cJ/MwT9ZiwN6a25vCWTcRMiszbuLWj3Lk2Kc=";

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-X main.commit=v${version}"
    "-X main.date=unknown"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pscale \
      --bash <($out/bin/pscale completion bash) \
      --fish <($out/bin/pscale completion fish) \
      --zsh <($out/bin/pscale completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = pscale;
  };

  meta = with lib; {
    description = "The CLI for PlanetScale Database";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    homepage = "https://www.planetscale.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
