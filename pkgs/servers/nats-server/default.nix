{  buildGoModule, fetchFromGitHub, lib  }:

with lib;

buildGoModule rec {
  pname   = "nats-server";
  version = "2.1.0";


  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "1zp43v69cawbp6bpby1vx51z6nyv8gxnnl2qkhwr9zrgnhlcflnl";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
    platforms = platforms.all;
  };
}