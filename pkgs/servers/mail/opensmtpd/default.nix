{ stdenv, fetchurl, libasr, libevent, zlib, openssl, db, bison, pam }:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.4.4p1";

  buildInputs = [ libasr libevent zlib openssl db bison pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "1gcfdmpkk892wnnhwc2nb559bwl3k892w7saj4q8m6jfll53660i";
  };

  configureFlags = [
    "--with-mantype=doc"
    "--with-pam"
    "--without-bsd-auth"
    "--with-sock-dir=/run"
    "--with-privsep-user=smtpd"
    "--with-queue-user=smtpq"
    "--with-ca-file=/etc/ssl/certs/ca-bundle.crt"
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
