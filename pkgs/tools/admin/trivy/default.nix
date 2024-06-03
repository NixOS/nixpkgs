{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  trivy,
}:

buildGoModule rec {
  pname = "trivy";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "trivy";
    rev = "refs/tags/v${version}";
    hash = "sha256-lsUqzbHv+/P5RAOc774GhFMaY21+T7NnPKK9v/uLP8M=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-MsHlJ56MT+UqF+Psj+hKKpwPnRTcQ3RvWoHbmI93A5E=";

  subPackages = [ "cmd/trivy" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/trivy/pkg/version.ver=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Tests require network access
  doCheck = false;

  postInstall =
    let
      trivy =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.trivy;
    in
    ''
      installShellCompletion --cmd trivy \
        --bash <(${trivy}/bin/trivy completion bash) \
        --fish <(${trivy}/bin/trivy completion fish) \
        --zsh <(${trivy}/bin/trivy completion zsh)
    '';

  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = trivy;
    command = "trivy --version";
    version = "Version: v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/trivy";
    changelog = "https://github.com/aquasecurity/trivy/releases/tag/v${version}";
    description = "A simple and comprehensive vulnerability scanner for containers, suitable for CI";
    longDescription = ''
      Trivy is a simple and comprehensive vulnerability scanner for containers
      and other artifacts. A software vulnerability is a glitch, flaw, or
      weakness present in the software or in an Operating System. Trivy detects
      vulnerabilities of OS packages (Alpine, RHEL, CentOS, etc.) and
      application dependencies (Bundler, Composer, npm, yarn, etc.).
    '';
    mainProgram = "trivy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fab
      jk
    ];
  };
}
