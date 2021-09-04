{  buildGoPackage, fetchFromGitHub, lib  }:

with lib;

buildGoPackage rec {
  pname   = "nats-server";
  version = "2.4.0";

  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-v758qj1dy8zh3zfZxKkKALxZqNAxc1XdtTW4dxU4l5A=";
  };

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
