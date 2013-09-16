{ fetchurl, stdenv, pkgconfig, db48, libgcrypt, avahi, libiconv, pam, openssl }:

stdenv.mkDerivation rec {
  name = "netatalk-3.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/${name}.tar.bz2";
    sha256 = "1adlcj509czxsx60r1s96qlznspp5nz7dxc5fws11danidr4fhl8";
  };

  buildInputs = [ pkgconfig db48 libgcrypt avahi libiconv pam openssl ];

  configureFlags = [
    "--with-bdb=${db48}"
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
