{ version, sha256 }:

{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "scons";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/scons/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  setupHook = ./setup-hook.sh;

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
