{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-server";
  version = "2.1.8";

  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "1qwgsxr0fpkpw30asir1m7d8sx6p8qv6qq6jv3lac7wlfim7r2xl";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
