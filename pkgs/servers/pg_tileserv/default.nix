{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-62cJ0j/UfPW/ujKr0iA7Be8wZYlZ68mpJX8v1tAVREc=";
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
