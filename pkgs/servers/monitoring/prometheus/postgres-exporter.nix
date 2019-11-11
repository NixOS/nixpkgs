{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "postgres_exporter";
  version = "0.7.0";

  goPackagePath = "github.com/wrouesnel/postgres_exporter";

  src = fetchFromGitHub {
    owner = "wrouesnel";
    repo = "postgres_exporter";
    rev = "v${version}";
    sha256 = "0xi61090kmkp1cid3hx00csfa4w8nvaw8ky0w004czwqlyids6jg";
  };

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for PostgreSQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz globin willibutz ];
  };
}
