{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gawk-3.1.6";
  
  src = fetchurl {
    url = mirror://gnu/gawk/gawk-3.1.6.tar.bz2;
    sha256 = "0v6ba4hxfiiy3bny5japd3zmzxlh8vdkmswk96yngd6i1dddsgsi";
  };

  meta = {
    homepage = http://www.gnu.org/software/gawk/;
    description = "GNU implementation of the AWK programming language";
  };
}
