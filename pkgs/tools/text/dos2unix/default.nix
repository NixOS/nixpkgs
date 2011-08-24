{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation {
  name = "dos2unix-5.3.1";
  
  src = fetchurl {
    url = http://waterlan.home.xs4all.nl/dos2unix/dos2unix-5.3.1.tar.gz;
    sha256 = "0bwqw3wi0j4f1x8d39xw5v57ac0bc58j41vjx8v2qm1smg9jyci1";
  };

  configurePhase = ''
    sed -i -e s,/usr,$out, Makefile
  '';

  buildInputs = [ perl gettext ];

  meta = {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
