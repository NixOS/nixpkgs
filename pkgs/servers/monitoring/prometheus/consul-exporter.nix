{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "consul_exporter";
  version = "0.6.0";

  goPackagePath = "github.com/prometheus/consul_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "v${version}";
    sha256 = "0s30blb4d8zw9f6x7dsnc1rxmxzsaih9w3xxxgr6c9xsm347mj86";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
    platforms = platforms.unix;
  };
}
