{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, pscale
, testers
}:

buildGoModule rec {
  pname = "pscale";
  version = "0.195.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-Dgp4N4R239NSewHJ7iVhWwfoppXsnhhL8ZrDEbiM9v4=";
  };

  vendorHash = "sha256-0rzX54AdlFvvYhfZvS3qBxV4bIF2li8HwKdtm0jS04g=";

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
    mainProgram = "pscale";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    homepage = "https://www.planetscale.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys kashw2 ];
  };
}
