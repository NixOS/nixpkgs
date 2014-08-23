{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.17";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0nvv1bd8v13gh2m1429azws7ks0ix9y1yv87ak9k9i1dsqcrvpg6";
  };

  buildInputs = [ readline bzip2 ];

  doCheck = true;

  meta = {
    description = "free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.gnu; # arbitrary choice
  };
}
