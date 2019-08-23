{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcapfix-1.1.4";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/${name}.tar.gz";
    sha256 = "0m6308ka33wqs568b7cwa1f5q0bv61j2nwfizdyzrazw673lnh6d";
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
