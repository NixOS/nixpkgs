{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.5.0-1";
  name = "gputils-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/gputils/${name}.tar.bz2";
    sha256 = "055v83fdgqljprapf7rmh8x66mr13fj0qypj49xba5spx0ca123g";
  };
  meta = with stdenv.lib; {
    homepage = http://sdcc.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.yorickvp ];
  };
}
