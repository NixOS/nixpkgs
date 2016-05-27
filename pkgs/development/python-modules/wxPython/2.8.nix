{ fetchurl
, lib
, pythonPackages
, openglSupport ? true
, libX11
, wxGTK
, pkgconfig
}:

assert wxGTK.unicode;

with pythonPackages;

buildPythonPackage rec {
  name = "wxPython-${version}";
  version = "2.8.12.1";

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "1l1w4i113csv3bd5r8ybyj0qpxdq83lj6jrc5p7cc10mkwyiagqz";
  };

  propagatedBuildInputs = [ pkgconfig wxGTK (wxGTK.gtk) libX11 ]  ++ lib.optional openglSupport pyopengl;
  preConfigure = "cd wxPython";

  NIX_LDFLAGS = "-lX11 -lgdk-x11-2.0";

  buildPhase = "";

  installPhase = ''
    ${python.interpreter} setup.py install WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=${if openglSupport then "1" else "0"} UNICODE=1 --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK openglSupport; };
}
