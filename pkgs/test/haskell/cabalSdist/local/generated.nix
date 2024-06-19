# nix run ../../../../..#cabal2nix -- ./.
{ mkDerivation, base, lib }:
mkDerivation {
  pname = "local";
  version = "0.1.0.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./app
      ./CHANGELOG.md
      ./local.cabal
    ];
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  description = "Nixpkgs test case";
  license = lib.licenses.mit;
}
