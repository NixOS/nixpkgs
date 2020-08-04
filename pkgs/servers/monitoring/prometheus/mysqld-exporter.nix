{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mysqld_exporter";
  version = "0.12.1";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "0nzbfzx4dzs3cagdid1fqddrqimgr8x6r8gmmxglrss05c8srgs8";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = "https://github.com/prometheus/mysqld_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley globin ];
    platforms = platforms.unix;
  };
}
