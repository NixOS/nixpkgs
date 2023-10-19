{ version, sha256 }:

{ fetchurl, python, lib }:

python.pkgs.buildPythonApplication rec {
  pname = "scons";
  inherit version;

  src = fetchurl {
    url =
      if lib.versionAtLeast version "4.3.0" then
        "mirror://sourceforge/project/scons/scons/${version}/SCons-${version}.tar.gz"
      else
        "mirror://sourceforge/scons/scons-${version}.tar.gz";
    inherit sha256;
  };

  setupHook = ./setup-hook.sh;

  patches = lib.optionals (lib.versionAtLeast version "4.3.0") [
    ./env.patch
  ];

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

  passthru = {
    # expose the used python version so tools using this (and extensing scos with other python modules)
    # can use the exact same python version.
    inherit python;
  };

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
