{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0f7pjagr3zcqmbhmk446j6n7nanyhvyq4rn68f5wljl9g68ni7sj";
  };

  modSha256 = "13a969yki47gw4b3mwhsgl0x53xylmflsykcs63f8pmigckw7jac";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
