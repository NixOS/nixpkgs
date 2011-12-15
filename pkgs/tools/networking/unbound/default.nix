{ stdenv, fetchurl, openssl, expat, libevent, ldns }:

stdenv.mkDerivation rec {
  name = "unbound-1.4.13";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "04r379gma1ghr9zjc1fmncpw8kka4f0mpcmrzidsp264aqkxriw3";
  };
 
  buildInputs = [openssl expat libevent ldns];

  configureFlags = [ "--with-ssl=${openssl}" "--with-libexpat=${expat}"
    "--localstatedir=/var" ];

  meta = {
    description = "Unbound, a validating, recursive, and caching DNS resolver.";
    license = "BSD";
    homepage = http://www.unbound.net;
    platforms = with stdenv.lib.platforms; linux;
  };
}
