{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6KFYTZq126uvxQ5IOrMN+hpnAk/WtmS1Dam7w6Oif1M=";
  };

  vendorSha256 = "sha256-qdlh9H039GwKTxOhx+dzyUHkzJbaOeuguKnBOyAPe/E=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.programVersion=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
