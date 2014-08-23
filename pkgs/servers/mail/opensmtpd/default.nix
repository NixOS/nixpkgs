{ stdenv, fetchurl, libevent, zlib, openssl, db, bison, pam }:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "5.4.2p1";

  buildInputs = [ libevent zlib openssl db bison pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "18nrzfjhv9znb5dbhc5k3fi31a3vr1r8j36q3fzghkh47n6z9yjg";
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
    homepage = "http://www.postfix.org/";
    description = ''
      A free implementation of the server-side SMTP protocol as defined by
      RFC 5321, with some additional standard extensions.
    '';
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}
