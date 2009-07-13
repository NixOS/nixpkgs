{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "scons-" + version;

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}.tar.gz";
    sha256 = "2806451e02a42789decb6d08098b798b6b81a0a39d8d3b2fbdd3fe84ebd8a246";
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
}
