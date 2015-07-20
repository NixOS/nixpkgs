{ goPackages, lib, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-collectd-exporter-${rev}";
  rev = "0.1.0";
  goPackagePath = "github.com/prometheus/collectd_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "collectd_exporter";
    inherit rev;
    sha256 = "165zsdn0lffb6fvxz75szmm152a6wmia5skb96k1mv59qbmn9fi1";
  };

  buildInputs = [ goPackages.prometheus.client_golang ];

  meta = with lib; {
    description = "Relay server for exporting metrics from collectd to Prometheus";
    homepage = "https://github.com/prometheus/alertmanager";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
