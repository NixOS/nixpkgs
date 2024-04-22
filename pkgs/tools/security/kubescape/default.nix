{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
, kubescape
, testers
}:

buildGoModule rec {
  pname = "kubescape";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = "kubescape";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZGDE9go8BmaXE1YFT/z5Nob90MhsKZ6oKrodDMu2npY=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-qFJVoWzU9rqpYbb8gzdK33rq///zizxVkWhsNV8OXOM=";

  subPackages = [
    "."
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    git
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v${version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # Remove tests that use networking
    rm core/pkg/resourcehandler/urlloader_test.go
    rm core/pkg/opaprocessor/*_test.go
    rm core/cautils/getter/downloadreleasedpolicy_test.go
    rm core/core/initutils_test.go
    rm core/core/list_test.go
    rm core/pkg/resourcehandler/remotegitutils_test.go

    # Remove tests that use networking
    substituteInPlace core/pkg/resourcehandler/repositoryscanner_test.go \
      --replace-fail "TestScanRepository" "SkipScanRepository" \
      --replace-fail "TestGit" "SkipGit"

    # Remove test that requires networking
    substituteInPlace core/cautils/scaninfo_test.go \
      --replace-fail "TestSetContextMetadata" "SkipSetContextMetadata"
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
    mainProgram = "kubescape";
    broken = stdenv.isDarwin;
  };
}
