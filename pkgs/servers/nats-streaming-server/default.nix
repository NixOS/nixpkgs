{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-streaming-server";
  version = "0.16.2";
  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "0xrgwsw4xrn6fjy1ra4ycam50kdhyqqsms4yxblj5c5z7w4hnlmk";
  };

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://nats.io/;
    platforms = platforms.all;
  };
}
