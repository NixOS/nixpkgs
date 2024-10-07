{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kind";
  version = "0.24.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes-sigs";
    repo = "kind";
    hash = "sha256-vndN3ssiaaJdpPZQ0vBdqr4xPuY2bAHAd+SJamNrX6Q=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorHash = "sha256-VfqNM48M39R2LaUHirKmSXCdvBXUHu09oMzDPmAQC4o=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd kind \
      --bash <($out/bin/kind completion bash) \
      --fish <($out/bin/kind completion fish) \
      --zsh <($out/bin/kind completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license = licenses.asl20;
    mainProgram = "kind";
  };
}
