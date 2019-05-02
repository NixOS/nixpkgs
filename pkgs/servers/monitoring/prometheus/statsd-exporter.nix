{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "statsd_exporter-${version}";
  version = "0.9.0";
  rev = version;

  goPackagePath = "github.com/prometheus/statsd_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "0bgi00005j41p650rb6n1iz2w9m4p22d1w91f2hwlh5bqxf55al3";
  };

  meta = with stdenv.lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = https://github.com/prometheus/statsd_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
