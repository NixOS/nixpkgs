{ stdenv, fetchurl, libressl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "6.2p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/${name}.tar.gz";
    sha256 = "1g6hi03ylhv47sbar3xxgsrar8schqfwn4glckh6m6lni67ndq85";
  };

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
    maintainers = with maintainers; [ wkennington ];
  };
}
