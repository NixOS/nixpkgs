{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "doctl-${version}";
  version = "1.3.1";
  rev = "a57555c195d06bc7aa5037af77fde0665ad1231f";
  goPackagePath = "github.com/digitalocean/doctl";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    rev = "${rev}";
    sha256 = "03z652fw0a628gv666w8vpi05a4sdilvs1j5scjhcbi82zsbkvma";
  };

  meta = {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
  };
}
