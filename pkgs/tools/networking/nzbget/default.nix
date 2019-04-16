{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "20.0";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "0vyhmjg3ipjlv41il6kklys3m6rhqifdkv25a7ak772l6ba3dp04";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://nzbget.net;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
