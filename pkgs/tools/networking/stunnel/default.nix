{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "stunnel-5.00";
  
  src = fetchurl {
    url = http://www.stunnel.org/downloads/stunnel-5.00.tar.gz;
    sha256 = "04xwfppvmj0wrzar3rbypax93jb10f1skh3gq86gy6pglx96v648";
  };

  buildInputs = [openssl];

  configureFlags = [
    "--with-ssl=${openssl}"
  ];
  
  meta = {
    description = "Stunnel - Universal SSL wrapper";
    homepage = http://www.stunnel.org/;
    license = "GPLv2";
  };
}
