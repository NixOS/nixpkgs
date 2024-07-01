{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-plrQPPclDaJiFHc1HNCk+bYiLO0fJX/HC/vTTO5eoy8=";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-6l8jNQu+vI2SLPvKxl1o0XkqYbFyehqkrT75hEjIH/c=";
  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    mainProgram = "gitlab-ci-pipelines-exporter";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut mvisonneau ];
  };
}
