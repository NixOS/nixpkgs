{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.11";
  
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-6.11.tar.gz;
    sha256 = "1klb7bm461nm02161wn25ivnbq2d09lidi4sdicdv4md38lpd6gb";
  };

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";
  };
}
