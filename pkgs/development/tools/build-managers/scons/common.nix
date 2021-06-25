{ version, sha256 }:

{ fetchurl, python3Packages, lib }:

python3Packages.buildPythonApplication rec {
  pname = "scons";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/scons/${pname}-${version}.tar.gz";
    inherit sha256;
  };

  setupHook = ./setup-hook.sh;

  postPatch = lib.optionalString (lib.versionAtLeast version "4.0.0") ''
    substituteInPlace setup.cfg \
      --replace "build/dist" "dist"
  '' + lib.optionalString (lib.versionAtLeast version "4.1.0") ''
    substituteInPlace setup.cfg \
      --replace "build/doc/man/" ""
  '';

  # The release tarballs don't contain any tests (runtest.py and test/*):
  doCheck = lib.versionOlder version "4.0.0";

  postInstall = lib.optionalString (lib.versionAtLeast version "4.1.0") ''
    mkdir -p "$out/share/man/man1"
    mv "$out/"*.1 "$out/share/man/man1/"
  '';

  meta = with lib; {
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
    maintainers = [ ];
  };
}
