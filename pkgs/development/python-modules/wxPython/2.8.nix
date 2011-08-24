{ stdenv, fetchurl, pkgconfig, wxGTK, pythonPackages }:

assert wxGTK.unicode;

stdenv.mkDerivation {
  name = "wxPython-2.8.12.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://sourceforge/wxpython/wxPython-src-2.8.12.0.tar.bz2;
    sha256 = "1gdsk1p8ds4jd00habxy4y8m56247a5s1mvq1lm1r6475dvq4pkd";
  };
  
  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) pythonPackages.python pythonPackages.wrapPython ];
  
  passthru = { inherit wxGTK; };
}
