{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-TcQXYZsr3hjE93GfeBt8AJLuQQA7UM+wv1SmCnqON+M=";
  };

  vendorHash = "sha256-qmyqAbwQYgUFFQwCLakQGta2XMGCbCOvCB93S8/TWIs=";

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
