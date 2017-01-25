{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "haproxy_exporter-${version}";
  version = "0.7.1";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "1svwa1cw4yc5k8acj2r2hkall9csxjw51hgmwkmx5dq55gr9lzai";
  };

  meta = with stdenv.lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/haproxy_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
