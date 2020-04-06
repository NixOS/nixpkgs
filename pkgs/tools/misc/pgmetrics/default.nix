{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "06w2kqjq2yq9yypg6biywrybnmi4jlnnigd7az72hp7lzf2nhl62";
  };

  modSha256 = "0h375zk0ik06g0b5vmi00b1wn5q2c0r137f7qf6l8k8p886x41h6";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
