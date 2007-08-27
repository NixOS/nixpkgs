{stdenv, fetchurl, pkgconfig, wxGTK, python}:

assert wxGTK.unicode;

stdenv.mkDerivation {
  name = "wxPython-2.6.3.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/wxpython/wxPython-src-2.6.3.3.tar.bz2;
    md5 = "66b9c5f8e20a9505c39dab1a1234daa9";
  };
  buildInputs = [pkgconfig wxGTK (wxGTK.gtk) python];
  inherit wxGTK; # !!! move this down
}
