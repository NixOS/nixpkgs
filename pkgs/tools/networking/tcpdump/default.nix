{stdenv, fetchurl, libpcap}:

stdenv.mkDerivation {
  name = "tcpdump-3.9.5";
  src = fetchurl {
    url = http://www.tcpdump.org/release/tcpdump-3.9.5.tar.gz;
    md5 = "2135e7b1f09af0eaf66d2af822bed44a";
  };
  buildInputs = [libpcap];
}
