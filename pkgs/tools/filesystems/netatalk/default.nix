{ fetchurl, stdenv, pkgconfig, db, libgcrypt, avahi, libiconv, pam, openssl }:

stdenv.mkDerivation rec{
  name = "netatalk-3.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/${name}.tar.bz2";
    sha256 = "14793m7q6z3l49khyqg7c2d6nppfh49mz3x5m6hg5nbavnd6w2q4";
  };

  buildInputs = [ pkgconfig db libgcrypt avahi libiconv pam openssl ];

  patches = ./omitLocalstatedirCreation.patch;

  configureFlags = [
    "--with-bdb=${db}"
    "--with-openssl=${openssl}"
    "--with-lockfile=/run/lock/netatalk"
    "--localstatedir=/var/lib"
  ];

  enableParallelBuild = true;

  meta = {
    description = "Apple File Protocol Server";
    homepage = http://netatalk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jcumming emery ];
  };
}
