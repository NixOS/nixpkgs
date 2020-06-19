{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-server";
  version = "2.1.7";

  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "08wqaqar964p9adc0ma8dqg0rf88rylk1m2mddlbbqmd6l4h6m27";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
    platforms = platforms.all;
  };
}
