{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.22.8";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "sha256-fzBVG3XPvaJnfsebA4muWDmkgw8kwzpOv/C68/j/tSs=";
  };

  vendorSha256 = "sha256-EQl3ME/l0mEkqjy2DCjUBv6LVbR6OaEUkwNIBPfXiDA=";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
