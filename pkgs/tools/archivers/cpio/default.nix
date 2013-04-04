{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cpio-2.11";

  src = fetchurl {
    url = mirror://gnu/cpio/cpio-2.11.tar.bz2;
    sha256 = "bb820bfd96e74fc6ce43104f06fe733178517e7f5d1cdee553773e8eff7d5bbd";
  };

  patches = [ ./no-gets.patch ];

  meta = {
    homepage = http://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
  };
}
