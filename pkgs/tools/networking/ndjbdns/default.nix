{ stdenv, fetchurl, systemd, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.05.9";
  name = "ndjbdns-${version}";
  src = fetchurl {
    url = "http://pjp.dgplug.org/ndjbdns/${name}.tar.gz";
    sha256 = "0gf3hlmr6grcn6dzflf83lqqfp6hk3ldhbc7z0a1rrh059m93ap5";
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