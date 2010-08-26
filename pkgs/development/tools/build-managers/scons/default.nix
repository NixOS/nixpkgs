{stdenv, fetchurl, python, makeWrapper}:

let
  name = "scons";
  version = "2.0.1";
in

stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}-${version}.tar.gz";
    sha256 = "0qk74nrnm9qlijrq6gmy8cyhjgp0gis4zx44divnr8n487d5308a";
  };

  propagatedBuildInputs = [python makeWrapper];
  buildPhase = "python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) --hardlink-scons -O1";
  installPhase = "for n in $out/bin/*; do wrapProgram $n --suffix PYTHONPATH ':' \"$(toPythonPath $out)\"; done";

  meta = {
    homepage = "http://scons.org/";
    description = "An improved, cross-platform substitute for Make";
    license = "MIT";
    longDescription =
    '' SCons is an Open Source software construction tool. Think of
       SCons as an improved, cross-platform substitute for the classic
       Make utility with integrated functionality similar to
       autoconf/automake and compiler caches such as ccache. In short,
       SCons is an easier, more reliable and faster way to build
       software.
    '';
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
