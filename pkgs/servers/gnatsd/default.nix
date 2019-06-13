{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  name = "gnatsd-${version}";
  version = "1.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/nats-io/gnatsd";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nats-io";
    repo = "gnatsd";
    sha256 = "0wxdvaxl273kd3wcas634hx1wx5piljgbfr6vhf669b1frkgrh2b";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = https://nats.io/;
    platforms = platforms.all;
  };
}
