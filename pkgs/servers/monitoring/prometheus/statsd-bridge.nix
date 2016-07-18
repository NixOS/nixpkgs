{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "statsd_bridge-${version}";
  version = "0.3.0";
  rev = version;

  goPackagePath = "github.com/prometheus/statsd_bridge";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "1gg9v224n05khcwy27637w3rwh0cymm7hx6bginfxd7730rmpp2r";
  };

  goDeps = ./statsd-bridge_deps.json;

  meta = with stdenv.lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = https://github.com/prometheus/statsd_bridge;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
