{ stdenv, fetchurl, openssl, expat, libevent, ldns }:

stdenv.mkDerivation rec {
  name = "unbound-1.4.21";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "0w09m2rbn688rsk37k5xm3vkk5h2hxhivsr374j7h7vjf9x82bsh";
  };
 
  buildInputs = [openssl expat libevent ldns];

  configureFlags = [ "--with-ssl=${openssl}" "--with-libexpat=${expat}"
    "--localstatedir=/var" ];

  meta = {
    description = "Validating, recursive, and caching DNS resolver";
    license = "BSD";
    homepage = http://www.unbound.net;
    platforms = with stdenv.lib.platforms; linux;
  };
}
