{ buildGoModule, fetchFromGitHub, lib  }:

with lib;

buildGoModule rec {
  pname   = "nats-streaming-server";
  version = "0.24.3";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-vpDOiFuxLpqor+9SztdZrJvwC8QGwt5+df4R2OTcxlA=";
  };

  vendorSha256 = "sha256:1m783cq20xlv5aglf252g5127r5ilfq4fqj00vim38v271511hmy";

  # tests fail and ask to `go install`
  doCheck = false;

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
