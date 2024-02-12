{ lib, fetchFromGitHub, fetchpatch, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "pg_tileserv";
    rev = "v${version}";
    hash = "sha256-xTIx39eLmHBUlaUjQy9KGpi5X4AU93DzX+Ofg5PMLWE=";
  };

  vendorHash = "sha256-8CvYvoIKOYvR7npCV65ZqZGR8KCTH4GabTt/JGQG3uc=";

  ldflags = [ "-s" "-w" "-X main.programVersion=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = teams.geospatial.members;
  };
}
