{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubescape";
  version = "2.0.150";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1D/ixtZI7/H05MD6zRtZCF8yhW1FhvRpdPWieAPwxHs=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  modRoot = "cmd";
  vendorSha256 = "sha256-Nznf793OMQ7ZCWb5voVcLyMiBa1Z8Dswp7Tdn1AzlJA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/armosec/kubescape/core/cautils.BuildNumber=v${version}"
  ];

  postBuild = ''
    # kubescape/cmd should be called kubescape
    mv $GOPATH/bin/{cmd,kubescape}
  '';

  postInstall = ''
    installShellCompletion --cmd kubescape \
      --bash <($out/bin/kubescape completion bash) \
      --fish <($out/bin/kubescape completion fish) \
      --zsh <($out/bin/kubescape completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kubescape --help
    $out/bin/kubescape --version | grep "v${version}"
    runHook postInstallCheck
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
