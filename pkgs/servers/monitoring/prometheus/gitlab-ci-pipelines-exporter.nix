{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G298u9bitEst8QzZd1/B6PTCNpGqq88Z8W8w67/cVkQ=";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-LPS0paXtzNAOFW8FUAFbcEcVTtp3WFh6N/f6tuFPT50=";
  doCheck = true;

  meta = {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    mainProgram = "gitlab-ci-pipelines-exporter";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mmahut
      mvisonneau
    ];
  };
}
