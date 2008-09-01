{stdenv, fetchurl, libpcap}:

stdenv.mkDerivation rec {
  name = "tcpdump-3.9.4";

  src = fetchurl {
    url = "mirror://tcpdump/release/${name}.tar.gz";
    sha256 = "1dbknf6ys7n3mmlb6klr0jh0jgnnq3zd9y44kjdxcbmbdjhp1rvy";
  };

  buildInputs = [libpcap];

  meta = {
    description = "tcpdump, a famous network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
  };
}
