{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib }:

stdenv.mkDerivation rec {
  name = "nzbget-15.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "02nclq97gqr4zwww4j1l9sds2rwrwwvwvh2gkjhwvr0pb4z3zw9y";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nzbget.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
  };
}
