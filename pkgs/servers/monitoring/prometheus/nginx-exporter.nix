{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-fnYZmJxXY1RaPJX8KiKxFmMauP5Jh5H72FWjIwgoIio=";
  };

  vendorHash = "sha256-VkatDZerLKnfbNFtnjklkE3TLY57uO1WUGa/p5tAXSQ=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
  };
}
