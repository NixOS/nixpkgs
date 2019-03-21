{ stdenv, fetchurl, libressl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "6.2p3";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/${name}.tar.gz";
    sha256 = "0fn12i4kzsi0zkr4qp3dp9bycmirnfapajqvdfx02zhr4hanj0kv";
  };

  prePatch = ''
    sed -i '20i#include <sys/cdefs.h>' src/ntpd.h
    sed -i '19i#include <sys/cdefs.h>' src/log.c
  '';

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-cacert=/etc/ssl/certs/ca-certificates.crt"
  ];

  buildInputs = [ libressl ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.openntpd.org/;
    license = licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
    platforms = platforms.all;
  };
}
