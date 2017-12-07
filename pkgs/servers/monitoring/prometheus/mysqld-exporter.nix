{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mysqld_exporter-${version}";
  version = "0.10.0";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/mysqld_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "mysqld_exporter";
    sha256 = "1133bgyp5vljz2qvfh0qzq8h8bkc8vci3jnmbr633bh3jpaqm2py";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for MySQL server metrics";
    homepage = https://github.com/prometheus/mysqld_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
