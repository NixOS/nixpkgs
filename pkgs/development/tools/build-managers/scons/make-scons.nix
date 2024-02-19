{ lib, fetchFromGitHub, python3 }:

{ pname ? "scons"
, version
, hash
, patches ? [ ]
, setupHook ? ./setup-hook.sh
, doCheck ? false
, postPatch ? ""
, preConfigure ? ""
, postInstall ? ""
}:

python3.pkgs.buildPythonApplication {
  inherit pname version
    patches postPatch preConfigure postInstall setupHook doCheck;

  src = fetchFromGitHub {
    owner = "Scons";
    repo = "scons";
    rev = version;
    inherit hash;
  };

  outputs = [ "out" "man" ];

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
# TODO: patch to get rid of distutils and other deprecations
