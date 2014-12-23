{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "1v00k4b6m9wk0533s2jpg4rv9lhplh7zdp6vx2yyrmrbzc4jgy0g";
  };

  buildInputs = [openssl expat libevent];

  configureFlags = [
    "--with-ssl=${openssl}"
    "--with-libexpat=${expat}"
    "--with-libevent=${libevent}"
    "--localstatedir=/var"
  ];

  meta = {
    description = "Validating, recursive, and caching DNS resolver";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = [ stdenv.lib.maintainers.emery ];
    platforms = stdenv.lib.platforms.unix;
  };
}
