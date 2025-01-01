{
  lib,
  mkDerivation,
  include,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  statHook,
  uudecode,
  config,
  genassym,
  defaultMakeFlags,
}:
let
  base = import ./base.nix {
    inherit
      lib
      mkDerivation
      include
      bsdSetupHook
      netbsdSetupHook
      makeMinimal
      install
      tsort
      lorder
      statHook
      uudecode
      config
      genassym
      defaultMakeFlags
      ;
  };
in
mkDerivation (
  base
  // {
    pname = "sys-headers";
    installPhase = "includesPhase";
    dontBuild = true;
    noCC = true;
  }
)
