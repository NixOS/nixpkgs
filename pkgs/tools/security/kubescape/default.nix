{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubescape";
  version = "2.0.149";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-m6tJjC5BXxFC+bSOHbKXXGZQlJIM0+fIA+JYWBntgk8=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorSha256 = "sha256-vplHaaT7x0ZSpvityJF5aGKDARvGPBT9DMltOpUkOMo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/armosec/kubescape/clihandler/cmd.BuildNumber=v${version}"
  ];

  postInstall = ''
    # Running kubescape to generate completions outputs error warnings
    # but does not crash and completes successfully
    # https://github.com/armosec/kubescape/issues/200
    installShellCompletion --cmd kubescape \
      --bash <($out/bin/kubescape completion bash) \
      --fish <($out/bin/kubescape completion fish) \
      --zsh <($out/bin/kubescape completion zsh)
  '';

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/armosec/kubescape";
    changelog = "https://github.com/armosec/kubescape/releases/tag/v${version}";
    longDescription = ''
      Kubescape is the first open-source tool for testing if Kubernetes is
      deployed securely according to multiple frameworks: regulatory, customized
      company policies and DevSecOps best practices, such as the NSA-CISA and
      the MITRE ATT&CK®.
      Kubescape scans K8s clusters, YAML files, and HELM charts, and detect
      misconfigurations and software vulnerabilities at early stages of the
      CI/CD pipeline and provides a risk score instantly and risk trends over
      time. Kubescape integrates natively with other DevOps tools, including
      Jenkins, CircleCI and Github workflows.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ fab jk ];
  };
}
