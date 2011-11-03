{ stdenv, fetchurl, libpcap, ncurses }:

stdenv.mkDerivation {
  name = "dnstop-20110502";

  src = fetchurl {
    url = http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20110502.tar.gz;
    sha256 = "0ra3xjf7dwvq5xm6qbqd2al35vigibihy46rsz1860qrn3wycy12";
  };

  buildInputs = [ libpcap ncurses ];

  preInstall = ''
    ensureDir $out/share/man/man8 $out/bin
  '';

  meta = { 
    description = "libpcap application that displays DNS traffic on your network";
    homepage = "http://dns.measurement-factory.com/tools/dnstop";
    license = "BSD";
  };
}
