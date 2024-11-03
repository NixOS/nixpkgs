{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rabbitmq_exporter";
  version = "1.0.0-RC19";

  src = fetchFromGitHub {
    owner = "kbudde";
    repo = "rabbitmq_exporter";
    rev = "v${version}";
    hash = "sha256-31A0afmARdHxflR3n59DaqmLpTXws4OqROHfnc6cLKw=";
  };

  vendorHash = "sha256-ER0vK0xYUbQT3bqUosQMFT7HBycb3U8oI4Eak72myzs=";

  ldflags = [ "-s" "-w" ];

  checkFlags = [
    # Disable flaky tests on Darwin
    "-skip=TestWholeApp|TestExporter"
  ];

  meta = with lib; {
    description = "Prometheus exporter for RabbitMQ";
    mainProgram = "rabbitmq_exporter";
    homepage = "https://github.com/kbudde/rabbitmq_exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
