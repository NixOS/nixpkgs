{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "kapacitor";
  version = "1.5.7";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "0lzx25d4y5d8rsddgnypfskcxa5qlwc294sdzmn8dlq995yphpac";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
