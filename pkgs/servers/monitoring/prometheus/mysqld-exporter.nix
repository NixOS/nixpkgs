{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mysqld_exporter-${version}";
  version = "0.8.1";
  rev = version;

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "0pwf2vii9n9zgad1lxgw28c2743yc9c3qc03516fiwvlqc1cpddr";
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
