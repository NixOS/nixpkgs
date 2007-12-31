{stdenv, fetchurl, libpcap}:

stdenv.mkDerivation {
  name = "tcpdump-3.9.8";
  src = fetchurl {
    url = http://www.tcpdump.org/release/tcpdump-3.9.8.tar.gz;
    sha256 = "16fjm1ih56mwqniffp63adbxwfj5n10x1a7l22j3cx683pmwh293";
  };
  buildInputs = [libpcap];
}
