{ fetchurl, stdenv, pkgconfig, db, libgcrypt, avahi, libiconv, pam, openssl, acl }:

stdenv.mkDerivation rec{
  name = "netatalk-3.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/${name}.tar.bz2";
    sha256 = "0wf09fyqzza024qr1s26z5x7rsvh9zb4pv598gw7gm77wjcr6174";
  };

  buildInputs = [ pkgconfig db libgcrypt avahi libiconv pam openssl acl ];

  patches = ./omitLocalstatedirCreation.patch;

  configureFlags = [
    "--with-bdb=${db}"
    "--with-openssl=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--localstatedir=/var/lib"
  ];

  enableParallelBuild = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = http://netatalk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
