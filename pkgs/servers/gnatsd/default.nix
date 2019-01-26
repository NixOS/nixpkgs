{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  name = "gnatsd-${version}";
  version = "1.2.0";
  rev = "v${version}";

  goPackagePath = "github.com/nats-io/gnatsd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nats-io";
    repo = "gnatsd";
    sha256 = "186xywzdrmvlhlh9wgjs71rqvgab8vinlr3gkzkknny82nv7hcjw";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://nats.io/;
    platforms = platforms.all;
  };
}
