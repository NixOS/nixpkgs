{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "haproxy_exporter";
  version = "0.8.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "0gx8pq67w71ch3g3c77xaz39msrd9graizc6d3shwabdjx35yc6q";
  };

  meta = with stdenv.lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/haproxy_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
