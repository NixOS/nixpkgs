{stdenv, fetchurl, python, version, versionHash}:

stdenv.mkDerivation {
  name = "scons-${version}";
  meta =
  {
    homepage = "http://scons.org/";
    description = "An improved, cross-platform substitute for Make";
    longDescription =
    '' SCons is an Open Source software construction tool. Think of
       SCons as an improved, cross-platform substitute for the classic
       Make utility with integrated functionality similar to
       autoconf/automake and compiler caches such as ccache. In short,
       SCons is an easier, more reliable and faster way to build
       software.
    '';
  };
  src = fetchurl
  {
    url = "mirror://sourceforge/scons/scons-${version}.tar.gz";
    sha256 = "${versionHash}";
  };
  propagatedBuildInputs = [python];
  buildPhase = "true";
  installPhase = "python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) --hardlink-scons -O1";
}
