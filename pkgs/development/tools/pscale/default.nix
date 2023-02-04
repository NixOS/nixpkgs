{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, pscale
, testers
}:

buildGoModule rec {
  pname = "pscale";
  version = "0.128.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-2EIaK7UyJH9YEKlOGnnKrq3ucVgEjbF2jVui0bASNcA=";
  };

  vendorHash = "sha256-uQ8/cNNFelG8zzrcEs9fEs8KkY6/odwOGmwMmyxUKS4=";

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
