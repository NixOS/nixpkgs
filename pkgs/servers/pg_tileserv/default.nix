{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "19ycpir662dv6jg3fnlj3208cjhy0lxww3wc3h19x96556yklnfg";
  };

  vendorSha256 = "1wpzj6par25z7cyyz6p41cxdll4nzb0jjdl1pffgawiy9z7j17vb";

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
