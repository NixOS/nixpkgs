{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "postgres_exporter";
  version = "0.8.0";

  goPackagePath = "github.com/wrouesnel/postgres_exporter";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "0mid2kvskab3a32jscygg5jh0741nr7dvxzj4v029yiiqcx55nrc";
  };

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ];
  };
}
