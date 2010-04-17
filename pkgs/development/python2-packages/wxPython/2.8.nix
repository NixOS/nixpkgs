{stdenv, fetchurl, pkgconfig, wxGTK, python}:

assert wxGTK.unicode;

stdenv.mkDerivation {
  name = "wxPython-2.8.4.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/wxpython/wxPython-src-2.8.4.0.tar.bz2;
    sha256 = "0lkj29jcw3kqaf2iphgmmn9cqf2ppkm6qqr9izlx4bvn9dihgq6h";
  };
  buildInputs = [pkgconfig wxGTK (wxGTK.gtk) python];
  passthru = {inherit wxGTK;};
}
