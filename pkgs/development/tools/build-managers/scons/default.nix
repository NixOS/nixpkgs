{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation rec {
  name = "scons-${version}";
  version = "1.0.0";
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
  src = fetchurl {
    url = "mirror://sourceforge/scons/scons-${version}.tar.gz";
    sha256 = "13nyy7n0iddr91r136fj15brni8r5f3j6cx57w5aqfvmnb0lv51x";
  };
  propagatedBuildInputs = [python makeWrapper];
  buildPhase = "true";
  installPhase =
  ''
     python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) --hardlink-scons -O1
     for n in $out/bin/*; do wrapProgram $n --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH:\$PYTHONPATH"; done
  '';
}
