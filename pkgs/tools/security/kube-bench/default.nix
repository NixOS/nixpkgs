{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kube-bench";
  version = "0.6.17";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9pXW8PVJhaYi9uKArIJcXbQ6FbCjFA4z9f5M3DLKnng=";
  };

  vendorHash = "sha256-dBN6Yi8HtS9LzXr08jhw1hqDwS8a4UqrYaRpM+RzvVM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=v${version}"
  ];

  postInstall = ''
    mkdir -p $out/share/kube-bench/
    mv ./cfg $out/share/kube-bench/

    installShellCompletion --cmd kube-bench \
      --bash <($out/bin/kube-bench completion bash) \
      --fish <($out/bin/kube-bench completion fish) \
      --zsh <($out/bin/kube-bench completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kube-bench --help
    $out/bin/kube-bench version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/kube-bench";
    changelog = "https://github.com/aquasecurity/kube-bench/releases/tag/v${version}";
    description = "Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
