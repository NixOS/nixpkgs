{stdenv, fetchurl, python2Packages}:

let
  name = "scons";
  version = "2.5.1";
in python2Packages.buildPythonApplication {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}-${version}.tar.gz";
    sha256 = "1wji1z9jdkhnmm99apx6fhld9cs52rr56aigniyrcsmlwy52298b";
  };
  # No tests
  doCheck = false;

  meta = {
    homepage = http://scons.org/;
    description = "An improved, cross-platform substitute for Make";
    license = stdenv.lib.licenses.mit;
    longDescription = ''
      SCons is an Open Source software construction tool. Think of
      SCons as an improved, cross-platform substitute for the classic
      Make utility with integrated functionality similar to
      autoconf/automake and compiler caches such as ccache. In short,
      SCons is an easier, more reliable and faster way to build
      software.
    '';
    platforms = stdenv.lib.platforms.all;
  };
}
