{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nginxlog_exporter";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
    sha256 = "0cma6hgagqdms6x40v0q4jn8gjq1awyg1aqk5l8mz7l6k132qq7k";
  };

  goPackagePath = "github.com/martin-helmich/prometheus-nginxlog-exporter";

  goDeps = ./nginxlog-exporter_deps.nix;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
    platforms = platforms.all;
  };
}
