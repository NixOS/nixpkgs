{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.19";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "7f09319d044b0f6ee71fe3587bb873be701723ac0952cff5069046a78de8fd86";
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
