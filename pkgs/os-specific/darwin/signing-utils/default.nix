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
    runHook preInstall

    substituteAll ${./utils.sh} $out

    runHook postInstall
  '';

  # Substituted variables
  inherit sigtool;
  codesignAllocate = "${cctools}/bin/${cctools.targetPrefix}codesign_allocate";
}
