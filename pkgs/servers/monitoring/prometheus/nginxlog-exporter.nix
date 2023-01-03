{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginxlog_exporter";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
    sha256 = "sha256-W+cLJUsg49Fwo2IsJjo0QZ0NLNy/H7E35Yjr7bsHAkQ=";
  };

  vendorSha256 = "sha256-Bdyk+yNVcxPDzxJQSE34HJCryWQSXa8748gJ5Fu+gP4=";

  subPackages = [ "." ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginxlog; };

  meta = with lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
