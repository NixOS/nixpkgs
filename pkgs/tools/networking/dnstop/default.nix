{ stdenv, fetchurl, libpcap, ncurses }:

stdenv.mkDerivation rec {
  name = "dnstop-20140915";

  src = fetchurl {
    url = "http://dns.measurement-factory.com/tools/dnstop/src/${name}.tar.gz";
    sha256 = "0yn5s2825l826506gclbcfk3lzllx9brk9rzja6yj5jv0013vc5l";
  };

  buildInputs = [ libpcap ncurses ];

  preInstall = ''
    mkdir -p $out/share/man/man8 $out/bin
  '';

  meta = { 
    description = "libpcap application that displays DNS traffic on your network";
    homepage = "http://dns.measurement-factory.com/tools/dnstop";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
