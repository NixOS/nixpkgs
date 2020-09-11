{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "kapacitor";
  version = "1.5.6";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "1jb04lnxjrms7x5nlrsd1s465rramm9z4zkqpfw1vfdsqa2dd8rc";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
