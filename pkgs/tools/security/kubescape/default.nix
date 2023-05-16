{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
<<<<<<< HEAD
, kubescape
, testers
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "kubescape";
<<<<<<< HEAD
  version = "2.9.1";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-FKWR3pxFtJBEa14Mn3RKsLvrliHaj6TuF4F2JLtw2qA=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-zcv8oYm6srwkwT3pUECtTewyqVVpCIcs3i0VRTRft68=";
=======
    hash = "sha256-TMK+9C1L+pNIjWg/lahVQk1G4CdfgRLH68XKAfszTys=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-SPIMI9HJRF9r5wZfdynwcTTZiZ7SxuJjfcfPg6dMsGo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X=github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v${version}"
=======
    "-X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rm core/cautils/getter/downloadreleasedpolicy_test.go
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = kubescape;
    command = "kubescape version";
    version = "v${version}";
  };
=======
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kubescape --help
    $out/bin/kubescape version | grep "v${version}"
    runHook postInstallCheck
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
