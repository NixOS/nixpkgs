{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "haproxy_exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "haproxy_exporter";
    rev = "v${version}";
    sha256 = "sha256-hpZnMvHAAEbvzASK3OgfG34AhPkCdRM7eOm15PRemkA=";
  };

  vendorHash = "sha256-s9UVtV8N2SJ1ik864P6p2hPXJ2jstFY/XnWt9fuCDo0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    mainProgram = "haproxy_exporter";
    homepage = "https://github.com/prometheus/haproxy_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
