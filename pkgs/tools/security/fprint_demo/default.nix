{ stdenv, fetchgit, autoreconfHook, pkgconfig, libfprint, gtk2 }:

stdenv.mkDerivation rec {
  name = "fprint_demo";

  src = fetchgit {
    url = "git://github.com/dsd/fprint_demo";
    rev = "5d86c3f778bf97a29b73bdafbebd1970e560bfb0";
    sha256 = "fe5bbf8d062fedd6fa796e50c5bd95fef49580eb0a890f78d6f55bd51cc94234";
  };

  buildInputs = [ libfprint gtk2 ];
  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/fprint/fprint_demo/";
    description = "A simple GTK+ application to demonstrate and test libfprint's capabilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
