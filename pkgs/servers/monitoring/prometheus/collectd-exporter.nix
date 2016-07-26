{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "collectd-exporter-${version}";
  version = "0.3.1";
  rev = version;

  goPackagePath = "github.com/prometheus/collectd_exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "collectd_exporter";
    sha256 = "1p0kb7c8g0r0sp5a6xrx8vnwbw14hhwlqzk4n2xx2y8pvnbivajz";
  };

  goDeps = ./collectd-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    homepage = https://github.com/prometheus/collectd_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
