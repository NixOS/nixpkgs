{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, CoreFoundation
, Security
}:

buildGoModule rec {
  pname = "trivy";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zyTUGAxUAfrigRNiw03ZXFK+UkpuxwuU2xviZmAPuR8=";
  };
  vendorSha256 = "sha256-dgiKWHSm49/CB4dWrNWIzkkmj6Aw4l+9iLa6xe/umq0=";

  excludedPackages = "misc";

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isx86_64)
    [ CoreFoundation Security ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  # Tests requires network access
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
