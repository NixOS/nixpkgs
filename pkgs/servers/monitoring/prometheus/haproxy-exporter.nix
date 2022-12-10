{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "haproxy_exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "haproxy_exporter";
    rev = "v${version}";
    sha256 = "sha256-F0yYUIKTIGyhzL0QwmioQYnWBb0GeFOhBwL3IqDKoQA=";
  };

  vendorSha256 = "sha256-iJ2doxsLqTitsKJg3PUFLzEtLlP5QckSdFZkXX3ALIE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/haproxy_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
