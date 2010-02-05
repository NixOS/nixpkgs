{ stdenv, fetchurl, libpcap }:

stdenv.mkDerivation rec {
  name = "tcpdump-4.0.0";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "112j0d12l5zsq56akn4n23i98pwblfb7qhblk567ddbl0bz9xsaz";
  };

  buildInputs = [ libpcap ];

  meta = {
    description = "tcpdump, a famous network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
  };
}
