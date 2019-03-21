{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcapfix-1.1.3";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/${name}.tar.gz";
    sha256 = "0f9g6yh1dc7x1n28xs4lcwlk6sa3mpz0rbw0ddhajqidag2k07sr";
  };

  postPatch = ''sed -i "s|/usr|$out|" Makefile'';

  meta = with stdenv.lib; {
    homepage = https://f00l.de/pcapfix/;
    description = "Repair your broken pcap and pcapng files";
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}
