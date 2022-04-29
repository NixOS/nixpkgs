{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubescape";
  version = "2.0.152";

  src = fetchFromGitHub {
    owner = "armosec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hibXmA2JerfnkGiSnBUCMHGPm4Tefnsl/x2VAS5z0Fo=";
  };
  vendorSha256 = "sha256-HfsQfoz1n3FEd2eVBBz3Za2jYCSrozXpL34Z8CgQsTA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v${version}"
  ];

  subPackages = [ "." ];

  preCheck = ''
    # Feed in all but the integration tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    # Skip httphandler tests - the checkPhase doesn't care about excludedPackages
    getGoDirs() {
      go list ./... | grep -v httphandler
    }

    rm core/pkg/resourcehandler/{repositoryscanner,urlloader}_test.go
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
    # `--version` vs `version` shows the version without checking for latest
    # if the flag is missing the BuildNumber may have moved
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
