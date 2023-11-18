{ lib, fetchurl, python3 }:

let
  pname = "scons";
  version = "4.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/scons/scons-${version}.tar.gz";
    hash = "sha256-ctKNdi4hJnh/Fz49WeCJI5+LL06e8xFNV/ELEgaYXYU=";
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "build/dist" "dist" \
      --replace "build/doc/man/" ""
  '';

  postInstall = ''
    mkdir -p "$out/share/man/man1"
    mv "$out/"*.1 "$out/share/man/man1/"
  '';

  setupHook = ./setup-hook.sh;

  # The release tarballs don't contain any tests (runtest.py and test/*):
  doCheck = false;

  passthru = {
    # expose the used python version so tools using this (and extensing scos
    # with other python modules) can use the exact same python version.
    inherit python3;
    python = python3;
  };

  meta = {
    description = "An improved, cross-platform substitute for Make";
    longDescription = ''
      SCons is an Open Source software construction tool. Think of SCons as an
      improved, cross-platform substitute for the classic Make utility with
      integrated functionality similar to autoconf/automake and compiler caches
      such as ccache. In short, SCons is an easier, more reliable and faster way
      to build software.
    '';
    homepage = "https://scons.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
