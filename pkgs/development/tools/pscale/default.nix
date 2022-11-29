{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, pscale
, testers
}:

buildGoModule rec {
  pname = "pscale";
  version = "0.124.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-bNMUUohiMa/fSP1HjrB0UR3kWh+HNqqqpLcraw6UNjs=";
  };

  vendorSha256 = "sha256-cd4oAS81zUMImCkFsTIcgYJDB2pvMWYRnTPFkznSr+I=";

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
