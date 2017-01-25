{ stdenv, fetchurl, libressl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "6.0p1";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/${name}.tar.gz";
    sha256 = "1s3plmxmybwpfrimq6sc54wxnn6ca7rb2g5k2bdjm4c88w4q1axi";
  };

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  buildInputs = [ libressl ];

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
