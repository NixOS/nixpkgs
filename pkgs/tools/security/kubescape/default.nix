{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubescape";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tXfjbE4C08YWgLJlZHjagAP3upqCpaOgwSegovVSFCI=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-bZPM8PCn0+W7Sf/+lQ3ASeqxFSZi49r32rjvQdD7Bvc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v${version}"
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

    # remove tests that use networking
    rm core/pkg/resourcehandler/urlloader_test.go
    rm core/pkg/opaprocessor/*_test.go

    # remove tests that use networking
    substituteInPlace core/pkg/resourcehandler/repositoryscanner_test.go \
      --replace "TestScanRepository" "SkipScanRepository" \
      --replace "TestGit" "SkipGit"

    # remove test that requires networking
    substituteInPlace core/cautils/scaninfo_test.go \
      --replace "TestSetContextMetadata" "SkipSetContextMetadata"
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
    $out/bin/kubescape version | grep "v${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/kubescape/kubescape";
    changelog = "https://github.com/kubescape/kubescape/releases/tag/v${version}";
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
