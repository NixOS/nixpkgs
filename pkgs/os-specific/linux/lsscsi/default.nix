{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lsscsi-0.31";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.31.tgz";
    sha256 = "1jpk15y9vqjb1lcj4pdzygpg0jf0lja7azjldpywc0s805rikgqj";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
