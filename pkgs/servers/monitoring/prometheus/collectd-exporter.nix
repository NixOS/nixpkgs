{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "collectd-exporter";
  version = "0.5.0";
  rev = version;

  goPackagePath = "github.com/prometheus/collectd_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "collectd_exporter";
    sha256 = "0vb6vnd2j87iqxdl86j30dk65vrv4scprv200xb83203aprngqgh";
  };

  passthru.tests = { inherit (nixosTests.prometheus-exporters) collectd; };

  meta = with lib; {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    homepage = "https://github.com/prometheus/collectd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
