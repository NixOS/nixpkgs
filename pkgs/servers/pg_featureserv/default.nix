{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_featureserv";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vfrwncx41yn9n2hqb32av3xgd13fqplrs1qzg5mv25i4qppd88l";
  };

  vendorSha256 = "1jqrkx850ghmpnfjhqky93r8fq7q63m5ivs0lzljzbvn7ya75f2r";

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
