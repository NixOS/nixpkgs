{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-streaming-server";
  version = "0.17.0";
  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "1dla70k6rxg34qzspq0j12zcjk654jrf3gm7gd45w4qdg8h2fyyg";
  };

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
    platforms = platforms.all;
  };
}
