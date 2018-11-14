{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  name = "nats-streaming-server-${version}";
  version = "0.11.0";
  rev = "v${version}";

  goPackagePath = "github.com/nats-io/nats-streaming-server";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nats-io";
    repo = "nats-streaming-server";
	sha256 = "0skkx3f7dpbf6nqpsbsk8ssn8hl55s9k76a5y5ksyqar5bdxvds5";
  };

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://nats.io/;
    platforms = platforms.all;
  };
}
