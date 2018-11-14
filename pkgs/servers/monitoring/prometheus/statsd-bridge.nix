{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "statsd_exporter-${version}";
  version = "0.4.0";
  rev = version;

  goPackagePath = "github.com/prometheus/statsd_bridge";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "1w11n7g663g7d7mbf6jfzcqmcm9rhaxy52bg0rqnad9v0rs5qxr6";
  };

  goDeps = ./statsd-bridge_deps.nix;

  meta = with stdenv.lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = https://github.com/prometheus/statsd_bridge;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
