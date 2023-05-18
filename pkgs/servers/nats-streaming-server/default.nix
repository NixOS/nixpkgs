{ buildGoModule, fetchFromGitHub, lib  }:

with lib;

buildGoModule rec {
  pname   = "nats-streaming-server";
  version = "0.25.4";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-/uPkcJOUDPVcdNBo6PxbJEvrrbElQ8lzMERZv6lOZwQ=";
  };

  vendorHash = "sha256-Ah7F4+l1Bmr5j15x7fsEOzFIvxDR4OuJFTY95ZYyOYc=";

  # tests fail and ask to `go install`
  doCheck = false;

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
