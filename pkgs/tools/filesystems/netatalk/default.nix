{ fetchurl, stdenv, pkgconfig, db, libgcrypt, avahi, libiconv, pam, openssl }:

stdenv.mkDerivation rec {
  name = "netatalk-3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/${name}.tar.bz2";
    sha256 = "1d8dc8ysslkis4yl1xab1w9p0pz7a1kg0i6fds4wxsp4fhb6wqhq";
  };

  buildInputs = [ pkgconfig db libgcrypt avahi libiconv pam openssl ];

  configureFlags = [
    "--with-bdb=${db}"
    "--with-openssl=${openssl}"
  ];

  enableParallelBuild = true;

  meta = {
    description = "Apple File Protocl Server";
    homepage = http://netatalk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
