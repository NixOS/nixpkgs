{ stdenv, lib, goPackages, fetchFromGitHub, }:

let self = goPackages.buildGoPackage rec {
  name = "prometheus-haproxy-exporter-0.4.0";
  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "haproxy_exporter";
    rev = "6ee6d1df3e68ed73df37c9794332b2594e4da45d";
    sha256 = "0lbwv6jsdfjd9ihiky3lq7d5rkxqjh7xfaziw8i3w34a38japlpr";
  };

  buildInputs = [ goPackages.prometheus.client_golang ];

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/haproxy_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
};

in self.bin
