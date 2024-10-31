{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.34";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Fmv6hq7t0ZrlWIbK8ahCXzgNI8Mg94nTmb9rgd5KEEY=";
  };

  vendorHash = "sha256-d9TijRzBpMvRrOMexGtewtAA9XpLwDTjPnPzt7G67Cs=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ctlptl" ];

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
