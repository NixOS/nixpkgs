{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.18";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1233bppjvdpbbl425ii6l7xvgy0879ghhnmwrph5b6c4g3dgvddp";
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
