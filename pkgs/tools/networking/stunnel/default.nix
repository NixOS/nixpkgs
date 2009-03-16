{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "stunnel-4.26";
  
  src = fetchurl {
    url = http://www.stunnel.org/download/stunnel/src/stunnel-4.26.tar.gz;
    sha256 = "1lvbd25krcz1sqk5pj2fv3r32h0160qdxrbzlqqs0kz8f987krp9";
  };

  buildInputs = [openssl];
  
  meta = {
    description = "Stunnel - Universal SSL wrapper";
    homepage = http://www.stunnel.org/;
    license = "GPLv2";
  };
}
