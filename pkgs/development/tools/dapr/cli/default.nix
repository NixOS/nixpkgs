{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "dapr-cli";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-G2n6VGP3ncuZ9siXojr4gx0VacIkKSt4OSQo3ZOecr0=";
  };

  vendorHash = "sha256-/sdW1cDFpOMkXN4RXJQB1PpDbyNmTEOo9OrK5A7cRGQ=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  ldflags = [
    "-X main.version=${version}"
    "-X main.apiVersion=1.0"
    "-X github.com/dapr/cli/pkg/standalone.gitcommit=${src.rev}"
    "-X github.com/dapr/cli/pkg/standalone.gitversion=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = with lib; {
    description = "A CLI for managing Dapr, the distributed application runtime";
    homepage = "https://dapr.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ joshvanl lucperkins ];
    mainProgram = "dapr";
  };
}
