{ stdenv, fetchurl, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam, cacert
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.7.1p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "67e9dd9682ca8c181e84e66c76245a4a8f6205834f915a2c021cdfeb22049e3a";
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
