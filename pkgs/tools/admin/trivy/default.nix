{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "trivy";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "11fd32qb69g23lxrynsnfy8a783sl60rzknvq4shdg41p2ikigdk";
  };

  vendorSha256 = "09birwc8x90l2y0znf4fwny3phnmq0cz0l2z3xzwg0j3msrdl2np";

  subPackages = [ "cmd/trivy" ];

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "A simple and comprehensive vulnerability scanner for containers, suitable for CI";
    longDescription = ''
      Trivy is a simple and comprehensive vulnerability scanner for containers
      and other artifacts. A software vulnerability is a glitch, flaw, or
      weakness present in the software or in an Operating System. Trivy detects
      vulnerabilities of OS packages (Alpine, RHEL, CentOS, etc.) and
      application dependencies (Bundler, Composer, npm, yarn, etc.).
    '';
    homepage = src.meta.homepage;
    changelog = "${src.meta.homepage}/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
