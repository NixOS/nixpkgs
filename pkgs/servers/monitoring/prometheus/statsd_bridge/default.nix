{ lib, goPackages, fetchFromGitHub }:

let self = goPackages.buildGoPackage rec {
  name = "prometheus-statsd-bridge-${version}";
  version = "0.1.0";
  goPackagePath = "github.com/prometheus/statsd_bridge";

  src = fetchFromGitHub {
    rev = version;
    owner = "prometheus";
    repo = "statsd_bridge";
    sha256 = "1fndpmd1k0a3ar6f7zpisijzc60f2dng5399nld1i1cbmd8jybjr";
  };

  buildInputs = with goPackages; [
    fsnotify.v0
    prometheus.client_golang
  ];

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = https://github.com/prometheus/statsd_bridge;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
};

in self.bin
