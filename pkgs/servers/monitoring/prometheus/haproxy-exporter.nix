{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "haproxy_exporter-${version}";
  version = "0.7.0";
  rev = version;

  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "1jkijdawmnj5yps0yaj47nyfmcah0krwmqsjvicm3sl0dhwmac4w";
  };

  goDeps = ./haproxy-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/haproxy_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
