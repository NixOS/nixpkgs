{
  mkDerivation,
  base,
  containers,
  lib,
}:

mkDerivation {
  pname = "ghc-settings-edit";
  version = "0.1.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Setup.hs
      ./ghc-settings-edit.lhs
      ./ghc-settings-edit.cabal
    ];
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    containers
  ];
  license = [
    lib.licenses.mit
    lib.licenses.bsd3
  ];
  description = "Tool for editing GHC's settings file";
  mainProgram = "ghc-settings-edit";
}
