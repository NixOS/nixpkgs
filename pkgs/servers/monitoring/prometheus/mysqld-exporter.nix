{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mysqld_exporter";
  version = "0.11.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "1684jf96dy5bs0y0689vlcw82lqw8kw2phlnp6pq1cq56fcwdxjn";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = https://github.com/prometheus/mysqld_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley globin ];
    platforms = platforms.unix;
  };
}
