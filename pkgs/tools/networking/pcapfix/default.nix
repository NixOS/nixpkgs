{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcapfix-1.1.2";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/${name}.tar.gz";
    sha256 = "0dl6pgqw6d8i5rhn6xwdx7sny16lpf771sn45c3p0l8z4mfzg6ay";
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
