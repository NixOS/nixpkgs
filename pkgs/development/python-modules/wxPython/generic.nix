{ stdenv, fetchurl, pkgconfig, python, isPy3k, isPyPy, wxGTK, openglSupport ? true, pyopengl
, version, sha256, wrapPython, setuptools, ...
}:

assert wxGTK.unicode;

stdenv.mkDerivation rec {
  name = "wxPython-${version}";
  inherit version;

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    inherit sha256;
  };

  pythonPath = [ python setuptools ];
  buildInputs = [ python setuptools pkgconfig wxGTK (wxGTK.gtk) wrapPython ]  ++ stdenv.lib.optional openglSupport pyopengl;
  preConfigure = "cd wxPython";

  installPhase = ''
    ${python.interpreter} setup.py install WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=${if openglSupport then "1" else "0"} UNICODE=1 --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK openglSupport; };
}
