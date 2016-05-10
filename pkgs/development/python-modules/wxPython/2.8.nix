{ lib, buildPythonPackage, fetchurl, pkgconfig, isPy3k, isPyPy, wxGTK, openglSupport ? true, pyopengl
, libX11, ...
}:

assert wxGTK.unicode;

buildPythonPackage rec {
  name = "wxPython-${version}";
  version = "2.8.12.1";

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "1l1w4i113csv3bd5r8ybyj0qpxdq83lj6jrc5p7cc10mkwyiagqz";
  };

  buildInputs = [ pkgconfig wxGTK (wxGTK.gtk) libX11 ]  ++ lib.optional openglSupport pyopengl;

  NIX_LDFLAGS = "-lX11 -lgdk-x11-2.0";

  WXPORT="gtk2";
  NO_HEADERS=1;
  BUILD_GLCANVAS=openglSupport;
  UNICODE=1;

  passthru = { inherit wxGTK openglSupport; };

  # setup.py is in the folder `wxPython`.
  # A required directory is apparently not being created so we do so manually.
  preBuild = ''
    pushd wxPython
    mkdir -p build-gtk2.unicode/bdist.linux-x86_64/wheel
  '';
}
