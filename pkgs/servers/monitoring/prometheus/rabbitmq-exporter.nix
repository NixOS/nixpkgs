{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rabbitmq_exporter";
  version = "1.0.0-RC8";

  src = fetchFromGitHub {
    owner = "kbudde";
    repo = "rabbitmq_exporter";
    rev = "v${version}";
    sha256 = "162rjp1j56kcq0vdi0ch09ka101zslxp684x6jvw0jq0aix4zj3r";
  };

  vendorSha256 = "1cvdqf5pdwczhqz6xb6w86h7gdr0l8fc3lav88xq26r4x75cm6v0";

  meta = with lib; {
    description = "Prometheus exporter for RabbitMQ";
    homepage = "https://github.com/kbudde/rabbitmq_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
