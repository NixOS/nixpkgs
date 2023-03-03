{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sVXLcz//1RLYOmKtH6u4tCPS8oqV0vOkmQLpWNBiUQY=";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorSha256 = "sha256-uyjj0Yh/bIvWvh76TEasgjJg9Dgj/GHgn3BOsO2peT0=";
  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut mvisonneau ];
  };
}
