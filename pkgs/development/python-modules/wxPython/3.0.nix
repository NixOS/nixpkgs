{ stdenv, fetchurl, pkgconfig, wxGTK, pythonPackages, openglSupport ? true, python, isPyPy }:

assert wxGTK.unicode;

with stdenv.lib;

let version = "3.0.0.0"; in

if isPyPy then throw "wxPython-${version} not supported for interpreter ${python.executable}" else stdenv.mkDerivation {
  name = "wxPython-${version}";
  
  builder = ./builder3.0.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "af88695e820dd914e8375dc91ecb736f6fb605979bb38460ace61bbea494dc11";
  };
  
  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) pythonPackages.python pythonPackages.wrapPython ]
                ++ optional openglSupport pythonPackages.pyopengl;

  inherit openglSupport;

  passthru = { inherit wxGTK openglSupport; };
}
