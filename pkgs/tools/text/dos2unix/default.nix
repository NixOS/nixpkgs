{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation {
  name = "dos2unix-6.0.6";
  
  src = fetchurl {
    url = http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.6.tar.gz;
    sha256 = "0xnj4gmav1ypkgwmqldnq41b6l3cg08dyngkbygn9vrhlvlx9fwa";
  };

  configurePhase = ''
    sed -i -e s,/usr,$out, Makefile
  '';

  buildInputs = [ perl gettext ];

  meta = {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
