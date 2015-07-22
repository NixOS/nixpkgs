{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib }:

let
  version = "15.0";
in
stdenv.mkDerivation rec {
  name = "nzbget-${version}";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/${name}-src.tar.gz";
    sha256 = "02nclq97gqr4zwww4j1l9sds2rwrwwvwvh2gkjhwvr0pb4z3zw9y";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nzbget.net;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
  };
}
