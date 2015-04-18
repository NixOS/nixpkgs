{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-14.2";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "0xs620hjxi9fkab6bmgy7zhwd0h035jpabf0wp2nc5y0gnsay95v";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls libgcrypt ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lz";

  meta = with stdenv.lib; {
    homepage = http://nzbget.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
  };
}
