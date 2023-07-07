{ lib
, stdenv
, fetchurl
, fetchpatch
, acl
, autoreconfHook
, avahi
, db
, ed
, libevent
, libgcrypt
, libiconv
, libtirpc
, openssl
, pam
, perl
, pkg-config
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netatalk";
  version = "3.1.15";

  src = fetchurl {
    url = "mirror://sourceforge/netatalk/netatalk/netatalk-${finalAttrs.version}.tar.bz2";
    hash = "sha256-2NSlzA/Yaw2Q4BfWTB9GI+jNv72lcPxCOt4RUak9GfU=";
  };

  patches = [
    ./000-no-suid.patch
    ./001-omit-localstatedir-creation.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    acl
    avahi
    db
    libevent
    libgcrypt
    libiconv
    openssl
    pam
  ];

  configureFlags = [
    "--with-bdb=${db.dev}"
    "--with-ssl-dir=${openssl.dev}"
    "--with-lockfile=/run/lock/netatalk"
    "--localstatedir=/var/lib"
  ];

  postInstall = ''
    sed -i -e "s%/usr/bin/env python%${python3}/bin/python3%" $out/bin/afpstats
    buildPythonPath ${python3.pkgs.dbus-python}
    patchPythonScript $out/bin/afpstats
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Apple Filing Protocol Server";
    homepage = "http://netatalk.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jcumming ];
  };
})
