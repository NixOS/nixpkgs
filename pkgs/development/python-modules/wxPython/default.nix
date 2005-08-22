{stdenv, fetchurl, pkgconfig, wxGTK, python}:

assert wxGTK.compat22;

stdenv.mkDerivation {
  name = "wxPython-2.4.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/wxPythonSrc-2.4.2.4.tar.gz;
    md5 = "ea4eb68e10a0c2a9be643b35dcb78e41";
  };
  buildInputs = [pkgconfig wxGTK (wxGTK.gtk) python];
  inherit wxGTK; # !!! move this down
} // { inherit python; } 
