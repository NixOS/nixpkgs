{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "1jly2apag4yg649w3flaq73wdrcfyxnhx5py9j73y7adxmswigbn";
  };

  buildInputs = [ openssl expat libevent ];

  configureFlags = [
    "--with-ssl=${openssl}"
    "--with-libexpat=${expat}"
    "--with-libevent=${libevent}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  meta = {
    description = "Validating, recursive, and caching DNS resolver";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = [ stdenv.lib.maintainers.ehmry ];
    platforms = stdenv.lib.platforms.unix;
  };
}
