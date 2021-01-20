{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-streaming-server";
  version = "0.19.0";
  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "1wa2xby7v45f9idnhbkglknipm24wqx7mxmkyqz3amq17j4xfy7c";
  };

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
