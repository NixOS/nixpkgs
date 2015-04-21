{ stdenv, lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-mesos-exporter-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "a4a6638d6db6b5137e130cd4903b30dd82b78e9a";
  goPackagePath = "github.com/prometheus/mesos_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mesos_exporter";
    sha256 = "1h4yxfcr8l9i2m1s5ygk3slhxdrs4mvmpn3sq8m5s205abvp891q";
  };

  buildInputs = [ goPackages.mesos-stats ];

  meta = with lib; {
    description = "Export Mesos metrics to Prometheus";
    homepage = https://github.com/prometheus/mesos_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
