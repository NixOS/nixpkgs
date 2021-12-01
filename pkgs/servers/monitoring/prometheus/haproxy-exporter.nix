{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "haproxy_exporter";
  version = "0.12.0";

  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "09aqm2zqimn6w10p1nhnpjcigm299b31xfrq8ma0d7z4v9p2y9dn";
  };

  meta = with lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/haproxy_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
