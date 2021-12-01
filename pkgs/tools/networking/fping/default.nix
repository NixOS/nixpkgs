{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.0";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    sha256 = "1f2prmii4fyl44cfykp40hp4jjhicrhddh9v3dfs11j6nsww0f7d";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
