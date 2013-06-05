{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "stunnel-4.56";
  
  src = fetchurl {
    url = http://www.stunnel.org/downloads/stunnel-4.56.tar.gz;
    sha256 = "14qjhwfa0y17ipnd5mc970vfmralvgaxfl6fk0rl91vdwbxjrblw";
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
