{stdenv, fetchurl, libpcap}:

stdenv.mkDerivation rec {
  name = "tcpdump-3.9.8";

  src = fetchurl {
    url = "mirror://tcpdump/release/${name}.tar.gz";
    sha256 = "16fjm1ih56mwqniffp63adbxwfj5n10x1a7l22j3cx683pmwh293";
  };

  buildInputs = [libpcap];

  meta = {
    description = "tcpdump, a famous network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
  };
}
