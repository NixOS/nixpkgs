{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pcapfix-1.1.1";

  src = fetchurl {
    url = "https://f00l.de/pcapfix/${name}.tar.gz";
    sha256 = "07dfgl99iv88mgpnpfcb9y7h0zjq9fcf4sp5s7d0d3d5a5sshjay";
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
