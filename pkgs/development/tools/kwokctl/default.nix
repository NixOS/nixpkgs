{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kwokctl";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes-sigs";
    repo = "kwok";
    sha256 = "sha256-BTlg9zg3S1fwG6Gb4PYAcnlgPNC8sGkP1K9wYmuOPmU=";
  };

  vendorHash = "sha256-Wr7MZ2LLxKE84wmItEnJj8LhxMca4rooadiv4ubx/38=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = ["cmd/kwokctl" ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd kwokctl \
      --bash <($out/bin/kwokctl completion bash) \
      --fish <($out/bin/kwokctl completion fish) \
      --zsh <($out/bin/kwokctl completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters. ";
    homepage = "https://github.com/kubernetes-sigs/kwok";
    maintainers = with maintainers; [ peterparser ];
    license = licenses.asl20;
    mainProgram = "kwokctl";
  };
}

