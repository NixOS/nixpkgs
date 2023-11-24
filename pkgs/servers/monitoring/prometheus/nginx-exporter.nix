{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-glKjScJoJnFEm7Z9LAVF51haeyHB3wQ946U8RzJXs3k=";
  };

  vendorHash = "sha256-YyMySHnrjBHm3hRNJDwWBs86Ih4S5DONYuwlQ3FBjkA=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
  };
}
