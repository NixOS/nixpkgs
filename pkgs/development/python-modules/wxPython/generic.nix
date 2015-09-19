{ stdenv, fetchurl, pkgconfig, python, buildPythonPackage, isPy3k, isPyPy, wxGTK, openglSupport ? true, pyopengl
, version, sha256, ...
}:

assert wxGTK.unicode;

buildPythonPackage rec {

  disabled = isPy3k || isPyPy;
  doCheck = false;

  name = "wxPython-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    inherit sha256;
  };

  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) ]
                ++ stdenv.lib.optional openglSupport pyopengl;

  preConfigure = "cd wxPython";

  setupPyBuildFlags = [ "WXPORT=gtk2" "NO_HEADERS=1" "BUILD_GLCANVAS=${if openglSupport then "1" else "0"}" "UNICODE=1" ];

  installPhase = ''
    ${python}/bin/${python.executable} setup.py ${stdenv.lib.concatStringsSep " " setupPyBuildFlags} install --prefix=$out
  '';

  passthru = { inherit wxGTK openglSupport; };
}
