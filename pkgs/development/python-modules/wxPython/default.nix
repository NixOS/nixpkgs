{stdenv, fetchurl, wxGTK, python}:

assert wxGTK.compat22;

stdenv.mkDerivation {
  name = "wxPython-2.4.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/wxpython/wxPythonSrc-2.4.2.4.tar.gz;
    md5 = "ea4eb68e10a0c2a9be643b35dcb78e41";
  };
  pkgconfig = wxGTK.pkgconfig;
  gtk = wxGTK.gtk;
  inherit wxGTK python;
}
