{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-VzgcAyXR9TKpK6CJzKoqN5EgO9rWnZBhwv5Km/k8cK0=";
  };

  vendorHash = "sha256-HoRE9hvnyPkLpwc+FfUmithd5UDEJ0TnoDfcifa/0o0=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    mainProgram = "nginx-prometheus-exporter";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
  };
}
