{ stdenv, fetchurl, openssl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "5.7p4";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/${name}.tar.gz";
    sha256 = "08ybpi351284wj53qqrmg13j8l7md397yrqsmg0aqxg3frcxk4x9";
  };

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  buildInputs = [ openssl ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.openntpd.org/";
    license = licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
