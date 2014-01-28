{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation {
  name = "dos2unix-6.0.4";
  
  src = fetchurl {
    url = http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.4.tar.gz;
    sha256 = "0ymkp55shilzcrn60w1ni92gck7pbqxhi9qsnsii7gkz996j5gb6";
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
