{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vdxnh1s8r8ydsjnj70s69nifhpyicb4jmgd5j7i49cr096jg526";
  };

  vendorSha256 = "1wbv1wh3phd9p2hfnffsjv6f8hf9fgkwg88k9w56rx1pgps63nd9";

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
