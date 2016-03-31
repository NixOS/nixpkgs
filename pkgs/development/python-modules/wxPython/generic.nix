{ stdenv, fetchurl, pkgconfig, python, isPy3k, isPyPy, wxGTK, openglSupport ? true, pyopengl
, version, sha256, wrapPython, setuptools, libX11, ...
}:

assert wxGTK.unicode;

stdenv.mkDerivation rec {
  name = "wxPython-${version}";
  inherit version;

  disabled = isPy3k || isPyPy;
  doCheck = false;

  sourceRoot = "wxPython-src-${version}/wxPython";

  hardeningDisable = [ "format" ];

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    inherit sha256;
  };

  pythonPath = [ python setuptools ];
  buildInputs = [ python setuptools pkgconfig wxGTK (wxGTK.gtk) wrapPython libX11 ]  ++ stdenv.lib.optional openglSupport pyopengl;

  NIX_LDFLAGS = "-lX11 -lgdk-x11-2.0";

  installPhase = ''
    ${python.interpreter} setup.py install WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=${if openglSupport then "1" else "0"} UNICODE=1 --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK openglSupport; };
}
