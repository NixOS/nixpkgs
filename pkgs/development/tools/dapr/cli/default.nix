{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "dapr-cli";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-+P1oXG+uvnFDGis5pz9VUQ4n1C7mjuetXz1OtN7IIrg=";
  };

  vendorSha256 = "sha256-EvOyOy7DFQtFavOC9eBUZRJsj3pNdx7jumVmZ/THdaM=";

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = with lib; {
    homepage = "https://dapr.io";
    description = "A CLI for managing Dapr, the distributed application runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
