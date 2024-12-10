{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-wLLHhbIA4jPgXtVIP6ycxgXfULODngPSpV3rZpJFSjI=";
  };

  vendorHash = "sha256-pMof9Wr6GrH5N97C4VNG2ELtZ6C6ruq5ylMwByotrP0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    mainProgram = "nginx-prometheus-exporter";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      fpletz
      willibutz
      globin
    ];
  };
}
