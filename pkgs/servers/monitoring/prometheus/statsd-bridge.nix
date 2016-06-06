{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "statsd_bridge-${version}";
  version = "0.1.0";
  rev = version;
  
  goPackagePath = "github.com/prometheus/statsd_bridge";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "statsd_bridge";
    sha256 = "1fndpmd1k0a3ar6f7zpisijzc60f2dng5399nld1i1cbmd8jybjr";
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
