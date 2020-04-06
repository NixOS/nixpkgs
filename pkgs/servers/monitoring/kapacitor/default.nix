{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "kapacitor";
  version = "1.5.1";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "17f3my1zmqmcx7qqhdcq8n73l60bsxnnxqgvnw0cnf0xsa5g1yks";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = https://influxdata.com/time-series-platform/kapacitor/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
