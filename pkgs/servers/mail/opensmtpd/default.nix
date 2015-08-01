{ stdenv, fetchurl, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam, cacert
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.4.5p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "15sicrpqsgg72igdckkwpmbgrapcjbfjsdrvm0zl8z13kgp6r4ks";
  };

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
