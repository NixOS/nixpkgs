{ stdenv, fetchurl, systemd, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.06";
  name = "ndjbdns-${version}";

  src = fetchurl {
    url = "http://pjp.dgplug.org/ndjbdns/${name}.tar.gz";
    sha256 = "09qi5a9abqm08iqmxj74fzzq9x1w5lzr1jlbzj2hl8hz0g2sgraw";
  };

  buildInputs = [ pkgconfig systemd ];

  meta = with stdenv.lib; {
    description = "A brand new release of the Djbdns";
    longDescription = ''
      Djbdns is a fully‐fledged Domain Name System(DNS), originally written by the eminent author of qmail, Dr. D J Bernstein.
    '';
    homepage = http://pjp.dgplug.org/ndjbdns/;
    license = licenses.gpl2;
    maintainers = [ maintainers.msackman ];
    platforms = platforms.linux;
  };

}
