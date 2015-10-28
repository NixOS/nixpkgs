{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "16.2";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/${name}-src.tar.gz";
    sha256 = "19ww3cf1qvivdj2pk676g9gwvfkj5gasvwqnbisx9ihss4bmdx9r";
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
