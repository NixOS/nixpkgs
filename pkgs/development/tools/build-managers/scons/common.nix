{ version, sha256 }:

{ stdenv, fetchurl, python3Packages, python2Packages, scons }:

python3Packages.buildPythonApplication rec {
  pname = "scons";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/scons/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  setupHook = ./setup-hook.sh;

  passthru.py2 = scons.override { python3Packages = python2Packages; };

  meta = with stdenv.lib; {
    description = "An improved, cross-platform substitute for Make";
    longDescription = ''
      SCons is an Open Source software construction tool. Think of
      SCons as an improved, cross-platform substitute for the classic
      Make utility with integrated functionality similar to
      autoconf/automake and compiler caches such as ccache. In short,
      SCons is an easier, more reliable and faster way to build
      software.
    '';
    homepage = "https://scons.org/";
    changelog = "https://raw.githubusercontent.com/SConsProject/scons/rel_${version}/src/CHANGES.txt";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.primeos ];
  };
}
