{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "nginx_exporter";
  version = "0.8.0";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  buildFlagsArray = [
    "-ldflags=" "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "sha256-fFzwJXTwtI0NXZYwORRZomj/wADqxW+wvDH49QK0IZw=";
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
