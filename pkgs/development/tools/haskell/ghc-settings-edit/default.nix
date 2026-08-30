{
  mkDerivation,
  base,
  containers,
  lib,
}:

mkDerivation {
  pname = "ghc-settings-edit";
  version = "0.1.0";
  src = builtins.path {
    path = ./.;
    name = "source";
    filter = path: _: (baseNameOf path) != "default.nix";
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
