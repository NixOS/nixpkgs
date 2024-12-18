{ stdenvNoCC
, sigtool
, cctools
}:

let
  stdenv = stdenvNoCC;
in

stdenv.mkDerivation {
  name = "signing-utils";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    substituteAll ${./utils.sh} $out
  '';

  # Substituted variables
  inherit sigtool;
  codesignAllocate = "${cctools}/bin/${cctools.targetPrefix}codesign_allocate";
}
