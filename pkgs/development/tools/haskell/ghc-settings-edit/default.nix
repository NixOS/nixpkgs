{
  mkDerivation,
  base,
  containers,
  lib,
  ghc,
}:

mkDerivation {
  pname = "ghc-settings-edit";
  version = "0.1.0";
  src = builtins.path {
    path = ./.;
    name = "source";
    filter = path: _: (builtins.baseNameOf path) != "default.nix";
  };
  # 8.0.1's Cabal is old, can't parse licenses with dashes, and seemingly can't parse multiple licenses either
  postPatch = lib.optionalString (lib.strings.versionOlder ghc.version "8.6.5") ''
    substituteInPlace ghc-settings-edit.cabal \
      --replace-fail 'cabal-version: 2.2' 'cabal-version: 1.24' \
      --replace-fail 'license: MIT AND BSD-3-Clause' 'license: BSD3'
  '';
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
