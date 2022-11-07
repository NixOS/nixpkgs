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

  proxyVendor = true; # fix vendor with go > 1.17, should be able to remove when package is bumped
  vendorSha256 = "sha256-pUcwd/mtj6vwoJNmXFtTqrOYJg9h1GKl6hndk/tFbm4=";

  ldflags = [ "-s" "-w" "-X github.com/CrunchyData/pg_featureserv/conf.setVersion=${version}" ];

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
