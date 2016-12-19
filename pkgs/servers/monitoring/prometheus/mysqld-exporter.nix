{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mysqld_exporter-${version}";
  version = "0.9.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "0ldjrbhm6n7in4lj6l78xii10mg162rsp09ymjm7y2xar9sd70vp";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = https://github.com/prometheus/mysqld_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
