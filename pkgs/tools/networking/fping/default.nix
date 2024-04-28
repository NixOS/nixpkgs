{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.2";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    sha256 = "sha256-p2ktENc/sLt24fdFmqfxm7zb/Frb7e8C9GiXSxiw5C8=";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
    mainProgram = "fping";
  };
}
