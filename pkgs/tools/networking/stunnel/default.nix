{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "stunnel-4.53";
  
  src = fetchurl {
    url = http://www.stunnel.org/downloads/stunnel-4.53.tar.gz;
    sha256 = "3e640aa4c96861d10addba758b66e99e7c5aec8697764f2a59ca2268901b8e57";
  };

  buildInputs = [openssl];
  
  meta = {
    description = "Stunnel - Universal SSL wrapper";
    homepage = http://www.stunnel.org/;
    license = "GPLv2";
  };
}
