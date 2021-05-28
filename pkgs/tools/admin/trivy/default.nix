{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "trivy";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vgir7sc14lb0wqwr786sq77pda6rw7svwr6hxklckkn20d9z7z0";
  };

  vendorSha256 = "0k6n73im14gaayl8rday2fhhizsv3klza146gx0dqm0694rqph0r";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
