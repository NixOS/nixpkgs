{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trivy";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4QNnZHFPyAAQOGRKse4cCc34FgMpelHj+MFTuHLUodE=";
  };
  vendorSha256 = "sha256-IO8QOUKTHXeinOW1Wrg2gl2z0u1/TCcPOHmX0G3ONrc=";

  excludedPackages = "misc";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/trivy --help
    $out/bin/trivy --version | grep "v${version}"
    runHook postInstallCheck
  '';

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
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
