{ stdenv, fetchurl, openssl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "5.7p3";

  src = fetchurl {
    url = "mirror://openbsd/OpenNTPD/${name}.tar.gz";
    sha256 = "4f417c8a4c21ed7ec3811107829f931404f9bf121855b8571a2ca3355695343a";
  };

  patches = [ ./no-install.patch ];

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    homepage = "http://www.openntpd.org/";
    license = licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
