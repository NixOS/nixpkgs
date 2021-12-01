{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "07xj807cbggnh8k7d2i7h326p4wjb8sz5ng0hbdnznvyc4sb2cdw";
  };

  vendorSha256 = "sha256-qdlh9H039GwKTxOhx+dzyUHkzJbaOeuguKnBOyAPe/E=";

  ldflags = [ "-s" "-w" "-X main.programVersion=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
