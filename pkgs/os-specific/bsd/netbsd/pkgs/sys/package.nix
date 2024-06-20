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
  rsync,
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
      rsync
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
    pname = "sys";
    installPhase = null;
    noCC = false;
    dontBuild = false;
  }
)
