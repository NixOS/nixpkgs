{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gputils-${version}";
  version = "1.5.0-1";

  src = fetchurl {
    url = "mirror://sourceforge/gputils/${name}.tar.bz2";
    sha256 = "055v83fdgqljprapf7rmh8x66mr13fj0qypj49xba5spx0ca123g";
  };

  meta = with stdenv.lib; {
    homepage = https://gputils.sourceforge.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ yorickvp ];
    platforms = platforms.linux;
  };
}
