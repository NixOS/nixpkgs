{ stdenv, fetchgit, autoreconfHook, pkgconfig, libfprint, gtk2 }:

stdenv.mkDerivation rec {
  name = "fprint_demo-2008-03-03";

  src = fetchgit {
    url = "git://github.com/dsd/fprint_demo";
    rev = "5d86c3f778bf97a29b73bdafbebd1970e560bfb0";
    sha256 = "1rysqd8kdqgis1ykrbkiy1bcxav3vna8zdgbamyxw4hj5764xdcm";
  };

  buildInputs = [ libfprint gtk2 ];
  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/fprint_demo/";
    description = "A simple GTK+ application to demonstrate and test libfprint's capabilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
