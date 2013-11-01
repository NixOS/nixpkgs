{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.15";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha1 = "63ebf0ab375150903c65738070e4105200197fd4";
  };

  buildInputs = [ readline bzip2 ];

  doCheck = true;

  meta = {
    description = "free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
    license = "GPLv3+";
    platforms = stdenv.lib.platforms.gnu; # arbitrary choice
  };
}
