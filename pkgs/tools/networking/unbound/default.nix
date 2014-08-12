{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-1.4.22";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "17yjly9c00zfgbzvllqzjh668a4yk6vrinf47yrcs3hrna0m1bqw";
  };
 
  buildInputs = [openssl expat libevent];

  configureFlags = [ "--with-ssl=${openssl}" "--with-libexpat=${expat}"
    "--localstatedir=/var" ];

  meta = {
    description = "Validating, recursive, and caching DNS resolver";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = [ stdenv.lib.maintainers.emery ];
    platforms = stdenv.lib.platforms.unix;
  };
}
