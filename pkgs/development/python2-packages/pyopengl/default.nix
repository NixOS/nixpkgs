{ fetchurl, stdenv, python, mesa, freeglut, pil, buildPythonPackage }:

let version = "3.0.0b5";
in
  buildPythonPackage {
    name = "pyopengl-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/pyopengl/PyOpenGL-${version}.tar.gz";
      sha256 = "1rjpl2qdcqn4wamkik840mywdycd39q8dn3wqfaiv35jdsbifxx3";
    };

    propagatedBuildInputs = [ mesa freeglut pil ];

    meta = {
      homepage = http://pyopengl.sourceforge.net/;
      description = "PyOpenGL, the Python OpenGL bindings";

      longDescription = ''
        PyOpenGL is the cross platform Python binding to OpenGL and
        related APIs.  The binding is created using the standard (in
        Python 2.5) ctypes library, and is provided under an extremely
        liberal BSD-style Open-Source license.
      '';

      license = "BSD-style";
    };
  }
