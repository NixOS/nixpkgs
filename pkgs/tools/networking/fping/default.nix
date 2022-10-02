{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.1";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    sha256 = "sha256-HuUmjAY9dmRq8rRCYFLn2BpCtlfmp32OfT0uYP10Cf4=";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
