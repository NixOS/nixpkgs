/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
}:

with import ./release-lib.nix {inherit supportedSystems; };
with lib;

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
