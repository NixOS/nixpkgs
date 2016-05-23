{ stdenv, fetchurl, autoconf, automake, libtool, bison
, libasr, libevent, zlib, openssl, db, pam
}:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.9.2p1";

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ libasr libevent zlib openssl db pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "07d7f1m5sxyz6mkk228rcm7fsf7350994ayvmhgph333q5rz48im";
  };

  patches = [ ./proc_path.diff ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-mantype=doc"
    "--with-pam"
    "--without-bsd-auth"
    "--with-sock-dir=/run"
    "--with-user-smtpd=smtpd"
    "--with-user-queue=smtpq"
    "--with-group-queue=smtpq"
    "--with-ca-file=/etc/ssl/certs/ca-certificates.crt"
    "--with-libevent-dir=${libevent.dev}"
    "--enable-table-db"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.opensmtpd.org/;
    description = ''
      A free implementation of the server-side SMTP protocol as defined by
      RFC 5321, with some additional standard extensions
    '';
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rickynils obadz ];
  };
}
