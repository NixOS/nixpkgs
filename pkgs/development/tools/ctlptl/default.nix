{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.26";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qi9fN66YLow8TO/4GmJBIcj8CnH7jbpyryjnMG6yp0U=";
  };

  vendorHash = "sha256-gortoYTYGtvhM1XWVhI2bB+cKtbTADpKl5W9h1QSEPc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
