{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-${version}";
  version = "1.5.7";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "1a0wfgp6wqpf7cxlcbprqhnjx6z9ywf0rhrpcf7x98l1mbjqh82b";
  };

  buildInputs = [ openssl expat libevent ];

  configureFlags = [
    "--with-ssl=${openssl}"
    "--with-libexpat=${expat}"
    "--with-libevent=${libevent}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--enable-pie"
    "--enable-relro-now"
  ];

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  meta = with stdenv.lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = with maintainers; [ ehmry fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
}
