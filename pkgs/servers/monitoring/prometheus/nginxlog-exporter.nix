{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginxlog_exporter";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
    sha256 = "0kcwhaf9k7c1xsz78064qz5zb4x3xgi1ifi49qkwiaqrzx2xy26p";
  };

  vendorSha256 = "05hisrhlklbs26cgblzfjh6mhaih5asvbll54jngnmwylwjd1mmc";

  subPackages = [ "." ];

  runVend = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginxlog; };

  meta = with lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
