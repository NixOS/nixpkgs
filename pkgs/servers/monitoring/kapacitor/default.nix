{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "kapacitor";
  version = "1.5.5";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "17zk7fs6yl5hmhr3inwkafwmg2ihaicj43gdi5888dinhpa9bij1";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
