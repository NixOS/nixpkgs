{ fetchurl, stdenv, pkgconfig, db, libgcrypt, avahi, libiconv, pam, openssl, acl, ed, glibc }:

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

  # Expose librpcsvc to the linker for afpd
  # Fixes errors that showed up when closure-size was merged:
  # afpd-nfsquota.o: In function `callaurpc':
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_args'
  # netatalk-3.1.7/etc/afpd/nfsquota.c:78: undefined reference to `xdr_getquota_rslt'
  postConfigure = ''
    ${ed}/bin/ed -v etc/afpd/Makefile << EOF
    /^afpd_LDADD
    /am__append_2
    a
      ${glibc.static}/lib/librpcsvc.a \\
    .
    w
    EOF
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = http://netatalk.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
