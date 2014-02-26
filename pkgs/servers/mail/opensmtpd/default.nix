{ stdenv, fetchurl, libevent, zlib, openssl, db, bison, pam }:

stdenv.mkDerivation rec {
  name = "opensmtpd-${version}";
  version = "201307151923p1";

  buildInputs = [ libevent zlib openssl db bison pam ];

  src = fetchurl {
    url = "http://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "0cggq60zzz5mgj093pmgwjp4bm6znnhyv6ibp1vhkba7cxjavr4g";
  };  

  configureFlags = [ 
    "--with-mantype=doc"
    "--with-pam"
    "--without-bsd-auth"
    "--with-sock-dir=/run"
    "--with-privsep-user=smtpd"
    "--with-queue-user=smtpq"
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
