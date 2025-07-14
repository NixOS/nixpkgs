{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rabbitmq_exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kbudde";
    repo = "rabbitmq_exporter";
    tag = "v${version}";
    hash = "sha256-A6pBhfH+BK+0QQUl7H1y7TLd5hSaSyGCvR4Br/3DaN4=";
  };

  vendorHash = "sha256-O/3y3FwFp4gUFN8OmVeoHU6yJZYng7rU9VeDcCwWayI=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    # Disable flaky tests on Darwin
    "-skip=TestWholeApp|TestExporter"
  ];

  meta = {
    description = "Prometheus exporter for RabbitMQ";
    mainProgram = "rabbitmq_exporter";
    homepage = "https://github.com/kbudde/rabbitmq_exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
