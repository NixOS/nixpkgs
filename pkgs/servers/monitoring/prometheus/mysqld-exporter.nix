{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mysqld_exporter-${version}";
  version = "0.1.0";
  rev = version;

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "10xnyxyb6saz8pq3ijp424hxy59cvm1b5c9zcbw7ddzzkh1f6jd9";
  };

  goDeps = ./mysqld-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = https://github.com/prometheus/mysqld_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
