{ lib, fetchurl, python3 }:

let
  pname = "scons";
  version = "3.1.2";
  src = fetchurl {
    url = "mirror://sourceforge/scons/scons-${version}.tar.gz";
    hash = "sha256-eAHz9i9lRSjict94C+EMDpM36JdlC2Ldzunzn94T+Ps=";
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;

  setupHook = ./setup-hook.sh;

  doCheck = true;

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
