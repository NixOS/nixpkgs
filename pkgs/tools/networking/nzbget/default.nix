{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "19.0";

  src = fetchurl {
    url = "http://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "08kgi4zmh4h1pvxh8x4c3ydf9xl2s6ncm579f0wdm2zknvpf0j16";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libxml2 ncurses libsigcxx libpar2 gnutls
                  libgcrypt zlib openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://nzbget.net;
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
