{ stdenv, fetchurl, pkgconfig, wxGTK, pythonPackages }:

assert wxGTK.unicode;

let version = "2.8.12.1"; in

stdenv.mkDerivation {
  name = "wxPython-${version}";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "1l1w4i113csv3bd5r8ybyj0qpxdq83lj6jrc5p7cc10mkwyiagqz";
  };
  
  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) pythonPackages.python pythonPackages.wrapPython ];
  
  passthru = { inherit wxGTK; };
}
