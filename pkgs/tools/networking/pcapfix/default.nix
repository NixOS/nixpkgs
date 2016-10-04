{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcapfix-1.1.0";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/${name}.tar.gz";
    sha256 = "025jpsqav9wg9lql7jfpd67z1113j8gzmjc5nqf5q07b01nnpfgj";
  };

  postPatch = ''sed -i "s|/usr|$out|" Makefile'';

  meta = with stdenv.lib; {
    homepage = "https://f00l.de/pcapfix/";
    description = "Repair your broken pcap and pcapng files";
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}
