{ lib, stdenv, fetchurl, libpcap, ncurses }:

stdenv.mkDerivation rec {
  pname = "dnstop";
  version = "2014-09-15";

  src = fetchurl {
    url = "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-${lib.replaceStrings ["-"] [""] version}.tar.gz";
    sha256 = "0yn5s2825l826506gclbcfk3lzllx9brk9rzja6yj5jv0013vc5l";
  };

  buildInputs = [ libpcap ncurses ];

  preInstall = ''
    mkdir -p $out/share/man/man8 $out/bin
  '';

  meta = {
    description = "libpcap application that displays DNS traffic on your network";
    homepage = "http://dns.measurement-factory.com/tools/dnstop";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "dnstop";
  };
}
