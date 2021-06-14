{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mesos_exporter";
  version = "1.1.2";

  goPackagePath = "github.com/prometheus/mesos_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mesos";
    repo = "mesos_exporter";
    sha256 = "0nvjlpxdhh60wcdw2fdc8h0vn6fxkz0nh7zrx43hjxymvc15ixza";
  };

  meta = with lib; {
    description = "Export Mesos metrics to Prometheus";
    homepage = "https://github.com/prometheus/mesos_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
