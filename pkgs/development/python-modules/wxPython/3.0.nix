{ fetchurl
, lib
, openglSupport ? true
, libX11
, wxGTK
, pkgconfig
, buildPythonPackage
, pyopengl
, isPy3k
, isPyPy
, python
}:

assert wxGTK.unicode;

buildPythonPackage rec {
  name = "wxPython-${version}";
  version = "3.0.2.0";

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";
  };

  hardeningDisable = [ "format" ];

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
