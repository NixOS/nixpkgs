{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-1.0.0";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-1.0.0.tar.bz2;
    sha256 = "1v00ikxn9j7vid0jrf7hh7wvk8scv69isif26ngh3jngs2wk42cj";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
