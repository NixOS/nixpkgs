{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "kapacitor-${version}";
  version = "1.4.0";

  goPackagePath = "github.com/influxdata/kapacitor";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    sha256 = "1qanf7qljzqqkyw2cdazg0ll13q8a3fs3sqydcgfbgpdmf707sj2";
  };

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    license = licenses.mit;
    homepage = https://influxdata.com/time-series-platform/kapacitor/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
