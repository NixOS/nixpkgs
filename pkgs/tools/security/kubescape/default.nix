{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, kubescape
, testers
}:

buildGoModule rec {
  pname = "kubescape";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FKWR3pxFtJBEa14Mn3RKsLvrliHaj6TuF4F2JLtw2qA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-zcv8oYm6srwkwT3pUECtTewyqVVpCIcs3i0VRTRft68=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v${version}"
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
    rm core/cautils/getter/downloadreleasedpolicy_test.go

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

  passthru.tests.version = testers.testVersion {
    package = kubescape;
    command = "kubescape version";
    version = "v${version}";
  };

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
