{ fetchurl, lib, stdenv, autoreconfHook, pkg-config, perl, python
, db, libgcrypt, avahi, libiconv, pam, openssl, acl
, ed, libtirpc, libevent
}:

stdenv.mkDerivation rec {
  pname = "netatalk";
  version = "3.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${version}.tar.bz2";
    sha256 = "1ld5mnz88ixic21m6f0xcgf8v6qm08j6xabh1dzfj6x47lxghq0m";
  };

  patches = [
    ./no-suid.patch
    ./omitLocalstatedirCreation.patch
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config perl python python.pkgs.wrapPython ];

  buildInputs = [ db libgcrypt avahi libiconv pam openssl acl libevent ];

  configureFlags = [
    "--with-bdb=${db.dev}"
    "--with-ssl-dir=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--with-libevent=${libevent.dev}"
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
      ${libtirpc}/lib/libtirpc.so \\
    .
    w
    EOF
  '';

  postInstall = ''
    buildPythonPath ${python.pkgs.dbus-python}
    patchPythonScript $out/bin/afpstats
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
