{stdenv, fetchurl, pkgconfig, wxGTK, python}:

assert wxGTK.compat22;

stdenv.mkDerivation {
  name = "wxPython-2.5.2.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/wxPythonSrc-2.5.2.8.tar.gz;
    md5 = "573fd376fd39b66ad5fbf44b487aa0b2";
  };
  buildInputs = [pkgconfig wxGTK (wxGTK.gtk) python];
  inherit wxGTK; # !!! move this down
} // { inherit python; } 
