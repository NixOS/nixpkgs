/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ nixpkgs ? { outPath = (import ./../.. {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
}:

with import ../../lib;
with import ./release-lib.nix {inherit supportedSystems; };

let
  packagePython = mapAttrs (name: value:
    let res = builtins.tryEval (
      if isDerivation value then
        value.meta.isBuildPythonPackage or []
      else if value.recurseForDerivations or false || value.recurseForRelease or false then
        packagePython value
      else
        []);
    in if res.success then res.value else []
    );
in (mapTestOn (packagePython pkgs))
