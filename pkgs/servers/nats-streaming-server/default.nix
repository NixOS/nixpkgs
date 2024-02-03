{ buildGoModule, fetchFromGitHub, lib  }:

with lib;

buildGoModule rec {
  pname   = "nats-streaming-server";
  version = "0.25.5";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-rx6H3YXyg53th81w1SsKg5h9wj2vswnArDO0TNUlvpE=";
  };

  vendorHash = "sha256-erTxz3YpE64muc9OgP38BrPNH5o3tStSYsCbBd++kFU=";

  # tests fail and ask to `go install`
  doCheck = false;

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
