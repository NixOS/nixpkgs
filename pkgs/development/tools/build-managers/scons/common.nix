{ version, sha256 }:

{ stdenv, fetchurl, python2Packages }:

let name = "scons";
in python2Packages.buildPythonApplication {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}-${version}.tar.gz";
    inherit sha256;
  };

  # Fix a regression in 3.0.0 (causes build errors for some packages)
  patches = stdenv.lib.optional (version == "3.0.0") ./print-statements.patch;

  setupHook = ./setup-hook.sh;

  # If your PATH contains a python.withPackages interpreter and as part of your
  # SConstruct build you want to launch a python script in a subprocess, which
  # should run with '#!/usr/bin/env python', then it would be problematic to have
  # scons wrapped with an additional PATH pointing to a different python
  # interpreter. None of your withPackages-packages would be importable.
  dontWrapPythonPrograms = true;

  meta = with stdenv.lib; {
    homepage = http://scons.org/;
    description = "An improved, cross-platform substitute for Make";
    license = licenses.mit;
    longDescription = ''
      SCons is an Open Source software construction tool. Think of
      SCons as an improved, cross-platform substitute for the classic
      Make utility with integrated functionality similar to
      autoconf/automake and compiler caches such as ccache. In short,
      SCons is an easier, more reliable and faster way to build
      software.
    '';
    platforms = platforms.all;
    maintainers = [ maintainers.primeos ];
  };
}
