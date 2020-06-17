{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "kapacitor";
  version = "1.5.4";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "1sd0gwqwa2bk81lshs8cy49mk1nh4azjkk0283rh0rkimy90l0zz";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
