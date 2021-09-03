{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "nginx_exporter";
  version = "0.9.0";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "04y5vpj2kv2ygdzxy3crpnx4mhpkm1ns2995kxgvjlhnyck7a5rf";
  };

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
    platforms = platforms.unix;
  };
}
