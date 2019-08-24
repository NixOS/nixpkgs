{ stdenv, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  pname = "postgres_exporter";
  version = "0.5.1";

  goPackagePath = "github.com/wrouesnel/postgres_exporter";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "1awcqhiak56nrsaa49lkw6mcbrlm86ls14sp9v69h3a0brc1q7bn";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
