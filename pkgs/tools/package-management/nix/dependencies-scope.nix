{
  lib,
  generateSplicesForMkScope,
  newScope,
  splicePackages,
  callPackage,
}:

let
  otherSplices = generateSplicesForMkScope [ "nixDependencies" ];
in
lib.makeScopeWithSplicing'
  {
    inherit splicePackages;
    inherit newScope; # layered directly on pkgs, unlike nixComponents above
  }
  {
    # Technically this should point to the nixDependencies set only, but
    # this is ok as long as the scopes don't intersect.
    inherit otherSplices;
    f = (callPackage ./dependencies.nix { }).scopeFunction;
  }
