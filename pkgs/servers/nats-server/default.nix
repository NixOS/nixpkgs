{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-server";
  version = "2.7.0";

  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-LQ817nZrFkF1zdj2m2SQK58BqDbUPSnncSWR+Woi+Ao=";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
    homepage = "https://nats.io/";
  };
}
