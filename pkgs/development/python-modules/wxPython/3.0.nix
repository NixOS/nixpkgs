{ stdenv, fetchurl, pkgconfig, wxGTK, pythonPackages, openglSupport ? true, python, isPyPy }:

assert wxGTK.unicode;

with stdenv.lib;

let version = "3.0.2.0"; in

if isPyPy then throw "wxPython-${version} not supported for interpreter ${python.executable}" else stdenv.mkDerivation {
  name = "wxPython-${version}";
  
  builder = ./builder3.0.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";
  };
  
  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) pythonPackages.python pythonPackages.wrapPython ]
                ++ optional openglSupport pythonPackages.pyopengl;

  inherit openglSupport;

  passthru = { inherit wxGTK openglSupport; };
  
  meta = {
    platforms = stdenv.lib.platforms.all;
  };
}
