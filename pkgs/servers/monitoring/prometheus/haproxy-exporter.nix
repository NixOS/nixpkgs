{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "haproxy_exporter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "haproxy_exporter";
    rev = "v${version}";
    sha256 = "sha256-u5o8XpKkuaNzAZAdA33GLd0QJSpqnkEbI8gW22G7FcY=";
  };

  vendorSha256 = "sha256-lDoW1rkOn2YkEf3QZdWBpm5fdzjkbER35XnXFr57D8c=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/haproxy_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
