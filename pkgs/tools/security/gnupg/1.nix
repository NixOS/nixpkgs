{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.20";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1k7d6zi0zznqsmcjic0yrgfhqklqz3qgd3yac7wxsa7s6088p604";
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
