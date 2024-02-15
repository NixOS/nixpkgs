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

  spliceReal =
    { pkgsBuildBuild
    , pkgsBuildHost
    , pkgsBuildTarget
    , pkgsHostHost
    , pkgsHostTarget
    , pkgsTargetTarget
    }:
    let
      mash =
        # Other pkgs sets
        pkgsBuildBuild // pkgsBuildTarget // pkgsHostHost // pkgsTargetTarget
        # The same pkgs sets one probably intends
        // pkgsBuildHost // pkgsHostTarget;
      merge = name: {
        inherit name;
        value =
          let
            defaultValue = mash.${name};
            # `or {}` is for the non-derivation attsert splicing case, where `{}` is the identity.
            valueBuildBuild = pkgsBuildBuild.${name} or { };
            valueBuildHost = pkgsBuildHost.${name} or { };
            valueBuildTarget = pkgsBuildTarget.${name} or { };
            valueHostHost = pkgsHostHost.${name} or { };
            valueHostTarget = pkgsHostTarget.${name} or { };
            valueTargetTarget = pkgsTargetTarget.${name} or { };
            augmentedValue = defaultValue
              // {
              __spliced =
                (lib.optionalAttrs (pkgsBuildBuild ? ${name}) { buildBuild = valueBuildBuild; })
                  // (lib.optionalAttrs (pkgsBuildHost ? ${name}) { buildHost = valueBuildHost; })
                  // (lib.optionalAttrs (pkgsBuildTarget ? ${name}) { buildTarget = valueBuildTarget; })
                  // (lib.optionalAttrs (pkgsHostHost ? ${name}) { hostHost = valueHostHost; })
                  // (lib.optionalAttrs (pkgsHostTarget ? ${name}) { hostTarget = valueHostTarget; })
                  // (lib.optionalAttrs (pkgsTargetTarget ? ${name}) {
                  targetTarget = valueTargetTarget;
                });
            };
            # Get the set of outputs of a derivation. If one derivation fails to
            # evaluate we don't want to diverge the entire splice, so we fall back
            # on {}
            tryGetOutputs = value0:
              let
                inherit (builtins.tryEval value0) success value;
              in
              getOutputs (lib.optionalAttrs success value);
            getOutputs = value: lib.genAttrs
              (value.outputs or (lib.optional (value ? out) "out"))
              (output: value.${output});
          in
          # The derivation along with its outputs, which we recur
            # on to splice them together.
          if lib.isDerivation defaultValue then augmentedValue // spliceReal {
            pkgsBuildBuild = tryGetOutputs valueBuildBuild;
            pkgsBuildHost = tryGetOutputs valueBuildHost;
            pkgsBuildTarget = tryGetOutputs valueBuildTarget;
            pkgsHostHost = tryGetOutputs valueHostHost;
            pkgsHostTarget = getOutputs valueHostTarget;
            pkgsTargetTarget = tryGetOutputs valueTargetTarget;
            # Just recur on plain attrsets
          } else if lib.isAttrs defaultValue then
            spliceReal
              {
                pkgsBuildBuild = valueBuildBuild;
                pkgsBuildHost = valueBuildHost;
                pkgsBuildTarget = valueBuildTarget;
                pkgsHostHost = valueHostHost;
                pkgsHostTarget = valueHostTarget;
                pkgsTargetTarget = valueTargetTarget;
                # Don't be fancy about non-derivations. But we could have used used
                # `__functor__` for functions instead.
              } else defaultValue;
      };
    in
    lib.listToAttrs (map merge (lib.attrNames mash));

  splicePackages =
    { pkgsBuildBuild
    , pkgsBuildHost
    , pkgsBuildTarget
    , pkgsHostHost
    , pkgsHostTarget
    , pkgsTargetTarget
    } @ args:
    if actuallySplice then spliceReal args else pkgsHostTarget;

  splicedPackages = splicePackages
    {
      inherit (pkgs)
        pkgsBuildBuild pkgsBuildHost pkgsBuildTarget
        pkgsHostHost pkgsHostTarget
        pkgsTargetTarget
        ;
    } // {
    # These should never be spliced under any circumstances
    inherit (pkgs)
      pkgsBuildBuild pkgsBuildHost pkgsBuildTarget
      pkgsHostHost pkgsHostTarget
      pkgsTargetTarget
      buildPackages pkgs targetPackages
      ;
    inherit (pkgs.stdenv) buildPlatform targetPlatform hostPlatform;
  };

  splicedPackagesWithXorg = splicedPackages // builtins.removeAttrs splicedPackages.xorg [
    "callPackage"
    "newScope"
    "overrideScope"
    "packages"
  ];

in

{
  inherit splicePackages;

  # We use `callPackage' to be able to omit function arguments that can be
  # obtained `pkgs` or `buildPackages` and their `xorg` package sets. Use
  # `newScope' for sets of packages in `pkgs' (see e.g. `gnome' below).
  callPackage = pkgs.newScope { };

  callPackages = lib.callPackagesWith splicedPackagesWithXorg;

  newScope = extra: lib.callPackageWith (splicedPackagesWithXorg // extra);

  # prefill 2 fields of the function for convenience
  makeScopeWithSplicing = lib.makeScopeWithSplicing splicePackages pkgs.newScope;
  makeScopeWithSplicing' = lib.makeScopeWithSplicing' { inherit splicePackages; inherit (pkgs) newScope; };

  # generate 'otherSplices' for 'makeScopeWithSplicing'
  generateSplicesForMkScope = attr:
    let
      split = X: lib.splitString "." "${X}.${attr}";
    in
    {
      # nulls should never be reached
      selfBuildBuild = lib.attrByPath (split "pkgsBuildBuild") null pkgs;
      selfBuildHost = lib.attrByPath (split "pkgsBuildHost") null pkgs;
      selfBuildTarget = lib.attrByPath (split "pkgsBuildTarget") null pkgs;
      selfHostHost = lib.attrByPath (split "pkgsHostHost") null pkgs;
      selfHostTarget = lib.attrByPath (split "pkgsHostTarget") null pkgs;
      selfTargetTarget = lib.attrByPath (split "pkgsTargetTarget") { } pkgs;
    };

  # Haskell package sets need this because they reimplement their own
  # `newScope`.
  __splicedPackages = splicedPackages // { recurseForDerivations = false; };
}
