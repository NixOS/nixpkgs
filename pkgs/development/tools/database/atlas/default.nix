{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, atlas }:

buildGoModule rec {
  pname = "atlas";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    hash = "sha256-SD4wWhFEyAOqffrJ2aowY96bLii02Z8PWGj8RNC6w7o=";
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-z2+u6jPTP6MOs7PTF6UzPwhnofQOhRll0zrmsLrN+PQ=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}" ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = atlas;
    command = "atlas version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "atlas";
  };
}
