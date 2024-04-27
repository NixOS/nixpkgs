{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, atlas }:

buildGoModule rec {
  pname = "atlas";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    hash = "sha256-i0nqjlL22sM8eVXCD/SBJyNdy0l0Hq4rjW0Lr3CRZlE=";
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-48UmLwp93SjwPPrdySFVApjVf1Rsj3oNhi1lha4ZvyE=";

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
    description = "A modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "atlas";
  };
}
