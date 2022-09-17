{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_featureserv";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lfsbsgcb7z8ljxn1by37rbx02vaprrpacybk1kja1rjli7ik7m9";
  };

  vendorSha256 = "1jqrkx850ghmpnfjhqky93r8fq7q63m5ivs0lzljzbvn7ya75f2r";

  ldflags = [ "-s" "-w" "-X github.com/CrunchyData/pg_featureserv/conf.setVersion=${version}" ];

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
