{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  name = "dos2unix-7.3.2";
  
  src = fetchurl {
    url = "http://waterlan.home.xs4all.nl/dos2unix/${name}.tar.gz";
    sha256 = "12c68c6wjnwrkyjj99fn6d0i4bf53aldj259lhjwq0g0nc5yxs67";
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
