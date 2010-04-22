{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "scons-" + version;

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}.tar.gz";
    sha256 = "4bde47b9a40fe767f089f5996d56b6e85a2d4929309b9c07a2dff363a78b0002";
  };

  propagatedBuildInputs = [python makeWrapper];
  buildPhase = "python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) --hardlink-scons -O1";
  installPhase = "for n in $out/bin/*; do wrapProgram $n --suffix PYTHONPATH ':' \"$(toPythonPath $out)\"; done";

  meta = {
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

  maintainers = [ stdenv.lib.maintainers.simons ];
}
