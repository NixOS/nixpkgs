{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "nzbget-${version}";
  version = "21.0";

  src = fetchurl {
    url = "https://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    sha256 = "0lwd0pfrs4a5ms193hgz2qiyf7grrc925dw6y0nfc0gkp27db9b5";
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
