{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "kapacitor-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "14l9bhj6qdif79s4dyqqbnjgj3m4iarvw0ckld1wdhpdgvl8w9qh";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = https://influxdata.com/time-series-platform/kapacitor/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
