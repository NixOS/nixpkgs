# The `splicedPackages' package set, and its use by `callPackage`
#
# The `buildPackages` pkg set is a new concept, and the vast majority package
# expression (the other *.nix files) are not designed with it in mind. This
# presents us with a problem with how to get the right version (build-time vs
# run-time) of a package to a consumer that isn't used to thinking so cleverly.
#
# The solution is to splice the package sets together as we do below, so every
# `callPackage`d expression in fact gets both versions. Each derivation (and
# each derivation's outputs) consists of the run-time version, augmented with
# a `__spliced.buildHost` field for the build-time version, and
# `__spliced.hostTarget` field for the run-time version.
#
# For performance reasons, rather than uniformally splice in all cases, we only
# do so when `pkgs` and `buildPackages` are distinct. The `actuallySplice`
# parameter there the boolean value of that equality check.
lib: pkgs: actuallySplice:

let
  inherit (builtins) isList isString tryEval;
  inherit (lib.customisation) mapCrossIndex renameCrossIndexFrom;
  inherit (lib)
    attrByPath
    callPackageWith
    filterAttrs
    genAttrs
    isAttrs
    isDerivation
    mapAttrs
    optional
    optionalAttrs
    splitString
    ;

  spliceReal =
    inputs:
    let
      mash =
        # Other pkgs sets
        inputs.buildBuild
        // inputs.buildTarget
        // inputs.hostHost
        // inputs.targetTarget
        # The same pkgs sets one probably intends
        // inputs.buildHost
        // inputs.hostTarget;
      merge =
        name: defaultValue:
        let
          # `or {}` is for the non-derivation attsert splicing case, where `{}` is the identity.
          value' = mapCrossIndex (x: x.${name} or { }) inputs;

          augmentedValue = defaultValue // {
            __spliced = filterAttrs (k: v: inputs.${k} ? ${name}) value';
          };
          # Get the set of outputs of a derivation. If one derivation fails to
          # evaluate we don't want to diverge the entire splice, so we fall back
          # on {}
          tryGetOutputs =
            value0:
            let
              inherit (tryEval value0) success value;
            in
            getOutputs (optionalAttrs success value);
          getOutputs =
            value: genAttrs (value.outputs or (optional (value ? out) "out")) (output: value.${output});
          outputNames = defaultValue.outputs or (optional (defaultValue ? out) "out");
          outputSplice = spliceReal (
            mapCrossIndex tryGetOutputs value' // { hostTarget = getOutputs value'.hostTarget; }
          );
        in
        # The derivation along with its outputs, which we recur
        # on to splice them together.
        if isDerivation defaultValue then
          augmentedValue // genAttrs outputNames (out: outputSplice.${out})
        else if isAttrs defaultValue then
          spliceReal value'
        else
          # Don't be fancy about non-derivations. But we could have used used
          # `__functor__` for functions instead.
          defaultValue;
    in
    mapAttrs merge mash;

  splicePackages =
    {
      pkgsBuildBuild,
      pkgsBuildHost,
      pkgsBuildTarget,
      pkgsHostHost,
      pkgsHostTarget,
      pkgsTargetTarget,
    }@args:
    if actuallySplice then spliceReal (renameCrossIndexFrom "pkgs" args) else pkgsHostTarget;

  splicedPackages =
    splicePackages {
      inherit (pkgs)
        pkgsBuildBuild
        pkgsBuildHost
        pkgsBuildTarget
        pkgsHostHost
        pkgsHostTarget
        pkgsTargetTarget
        ;
    }
    // {
      # These should never be spliced under any circumstances
      inherit (pkgs)
        pkgsBuildBuild
        pkgsBuildHost
        pkgsBuildTarget
        pkgsHostHost
        pkgsHostTarget
        pkgsTargetTarget
        buildPackages
        pkgs
        targetPackages
        ;
    };

  pkgsForCall = if actuallySplice then splicedPackages else pkgs;

in

{
  inherit splicePackages;

  # We use `callPackage' to be able to omit function arguments that can be
  # obtained from `pkgs` or `buildPackages`.
  # Use `newScope' for sets of packages in `pkgs' (see e.g. `gnome' below).
  callPackage = pkgs.newScope { };

  callPackages = lib.callPackagesWith pkgsForCall;

  newScope = extra: callPackageWith (pkgsForCall // extra);

  pkgs = if actuallySplice then splicedPackages // { recurseForDerivations = false; } else pkgs;

  # prefill 2 fields of the function for convenience
  makeScopeWithSplicing = lib.makeScopeWithSplicing splicePackages pkgs.newScope;
  makeScopeWithSplicing' = lib.makeScopeWithSplicing' {
    inherit splicePackages;
    inherit (pkgs) newScope;
  };

  # generate 'otherSplices' for 'makeScopeWithSplicing'
  generateSplicesForMkScope =
    attrs:
    let
      split =
        X:
        [ X ]
        ++ (
          if isList attrs then
            attrs
          else if isString attrs then
            splitString "." attrs
          else
            throw "generateSplicesForMkScope must be passed a list of string or string"
        );
      bad = throw "attribute should be found";
    in
    {
      selfBuildBuild = attrByPath (split "pkgsBuildBuild") bad pkgs;
      selfBuildHost = attrByPath (split "pkgsBuildHost") bad pkgs;
      selfBuildTarget = attrByPath (split "pkgsBuildTarget") bad pkgs;
      selfHostHost = attrByPath (split "pkgsHostHost") bad pkgs;
      selfHostTarget = attrByPath (split "pkgsHostTarget") bad pkgs;
      selfTargetTarget = attrByPath (split "pkgsTargetTarget") { } pkgs;
    };

  # Haskell package sets need this because they reimplement their own
  # `newScope`.
  __splicedPackages =
    if actuallySplice then splicedPackages // { recurseForDerivations = false; } else pkgs;
}
