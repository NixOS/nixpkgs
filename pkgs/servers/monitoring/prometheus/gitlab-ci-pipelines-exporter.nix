{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i0ry93w2pk8m7i4fbdn1xvsmvjn83d6lr6l7yywid9d0kmkjz13";
  };

  subPackages = [ "cmd/${pname}" ];

  ldflags = [
    "-X main.version=v${version}"
  ];

  vendorSha256 = "UszZaxql5sO4DSDVD/UIjeeDojCQEPF+ATL7O9MaTG8=";
  doCheck = true;

  meta = with lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut mvisonneau ];
  };
}
