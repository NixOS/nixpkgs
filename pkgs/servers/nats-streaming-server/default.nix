{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  name = "nats-streaming-server-${version}";
  version = "0.11.2";
  rev = "v${version}";

  goPackagePath = "github.com/nats-io/nats-streaming-server";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nats-io";
    repo = "nats-streaming-server";
    sha256 = "1jd9c5yw3xxp5hln1g8w48l4cslhxbv0k2af47g6pya09kwknqkq";
  };

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://nats.io/;
    platforms = platforms.all;
  };
}
