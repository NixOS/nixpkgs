{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "unbound-1.4.1";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "2573db422d7a856a3783b96698f2d5ca18a849d0bd6f0e36eb37a4f0a65b60e2";
  };
 
  buildInputs = [openssl];

  configureFlags = "--with-ssl=${openssl}";

  meta = {
    description = "Unbound, a validating, recursive, and caching DNS resolver.";
    license = "BSD";
    homepage = http://www.unbound.net;
  };
}
