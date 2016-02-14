{ stdenv, fetchurl, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam, cacert
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.7.3p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "848a3c72dd22b216bb924b69dc356fc297e8b3671ec30856978950208cba74dd";
  };

  patches = [ ./proc_path.diff ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-mantype=doc"
    "--with-pam"
    "--without-bsd-auth"
    "--with-sock-dir=/run"
    "--with-privsep-user=smtpd"
    "--with-queue-user=smtpq"
    "--with-ca-file=/etc/ssl/certs/ca-certificates.crt"
    "--with-libevent-dir=${libevent.dev}"
    "--enable-table-db"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    homepage = https://www.opensmtpd.org/;
    description = ''
      A free implementation of the server-side SMTP protocol as defined by
      RFC 5321, with some additional standard extensions
    '';
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}
