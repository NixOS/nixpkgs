{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TeXEfcmDHKgy5mGdixrIecxKO1rrg7+EWRIqzMYh3sU=";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-TXFwfqyvCAEn24vtUBcFABzIg0KaYlstiFwS7y6WbKo=";
  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut mvisonneau ];
  };
}
