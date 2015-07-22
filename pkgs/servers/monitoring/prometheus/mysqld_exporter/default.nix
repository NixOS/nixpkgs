{ goPackages, lib, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-mysqld-exporter-${rev}";
  rev = "0.1.0";
  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "mysqld_exporter";
    inherit rev;
    sha256 = "10xnyxyb6saz8pq3ijp424hxy59cvm1b5c9zcbw7ddzzkh1f6jd9";
  };

  buildInputs = with goPackages; [
    mysql
    prometheus.client_golang
  ];

  meta = with lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = https://github.com/prometheus/mysqld_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
