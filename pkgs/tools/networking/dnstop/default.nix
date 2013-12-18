{ stdenv, fetchurl, libpcap, ncurses }:

stdenv.mkDerivation {
  name = "dnstop-20121017";

  src = fetchurl {
    url = http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20121017.tar.gz;
    sha256 = "1xjrz4dzwshfrlc226s390sbwd10j0pl2al09d62955b6xh2vvba";
  };

  buildInputs = [ libpcap ncurses ];

  preInstall = ''
    mkdir -p $out/share/man/man8 $out/bin
  '';

  meta = { 
    description = "libpcap application that displays DNS traffic on your network";
    homepage = "http://dns.measurement-factory.com/tools/dnstop";
    license = "BSD";
  };
}
