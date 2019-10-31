{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "postgres_exporter";
  version = "0.6.0";

  goPackagePath = "github.com/wrouesnel/postgres_exporter";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "0a903mklp3aardlbz5fkslisav9khd1w3akcf9xkc5nfinr6xnqb";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ];
  };
}
