{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_featureserv";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kii9Qbff6dIAaHx3QfNPTg8g+QrBpZghGlHxrsGaMbo=";
  };

  vendorHash = "sha256-BHiEVyi3FXPovYy3iDP8q+y+LgfI4ElDPVZexd7nnuo=";

  ldflags = [ "-s" "-w" "-X github.com/CrunchyData/pg_featureserv/conf.setVersion=${version}" ];

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = teams.geospatial.members;
  };
}
