{ stdenv, fetchurl, readline, bzip2 }:

stdenv.mkDerivation rec {
  name = "gnupg-1.4.21";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0xi2mshq8f6zbarb5f61c9w2qzwrdbjm4q8fqsrwlzc51h8a6ivb";
  };

  buildInputs = [ readline bzip2 ];

  doCheck = true;

  meta = {
    description = "Free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.gnu; # arbitrary choice
  };
}
