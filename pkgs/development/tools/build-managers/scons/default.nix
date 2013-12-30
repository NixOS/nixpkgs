{stdenv, fetchurl, python, makeWrapper}:

let
  name = "scons";
  version = "2.3.0";
in

stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/scons/${name}-${version}.tar.gz";
    sha256 = "0jrv8v5dpdp231n1gsfmirqy27f7qas6m255jjm2qjygk6chchll";
  };

  buildInputs = [python makeWrapper];

  preConfigure = ''
    for i in "script/"*; do
     substituteInPlace $i --replace "/usr/bin/env python" "${python}/bin/python"
    done
  '';
  buildPhase = "python setup.py install --prefix=$out --install-data=$out/share --install-lib=$(toPythonPath $out) --symlink-scons -O1";
  installPhase = "for n in $out/bin/*-${version}; do wrapProgram $n --suffix PYTHONPATH ':' \"$(toPythonPath $out)\"; done";

  meta = {
    homepage = "http://scons.org/";
    description = "An improved, cross-platform substitute for Make";
    license = "MIT";
    longDescription = ''
      SCons is an Open Source software construction tool. Think of
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
