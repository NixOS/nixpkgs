# The `splicedPackages' package set, and its use by `callPackage`
#
# The `buildPackages` pkg set is a new concept, and the vast majority package
# expression (the other *.nix files) are not designed with it in mind. This
# presents us with a problem with how to get the right version (build-time vs
# run-time) of a package to a consumer that isn't used to thinking so cleverly.
#
# The solution is to splice the package sets together as we do below, so every
# `callPackage`d expression in fact gets both versions. Each# derivation (and
# each derivation's outputs) consists of the run-time version, augmented with a
# `nativeDrv` field for the build-time version, and `crossDrv` field for the
# run-time version.
#
# We could have used any names we want for the disambiguated versions, but
# `crossDrv` and `nativeDrv` were somewhat similarly used for the old
# cross-compiling infrastructure. The names are mostly invisible as
# `mkDerivation` knows how to pull out the right ones for `buildDepends` and
# friends, but a few packages use them directly, so it seemed efficient (to
# @Ericson2314) to reuse those names, at least initially, to minimize breakage.
#
# For performance reasons, rather than uniformally splice in all cases, we only
# do so when `pkgs` and `buildPackages` are distinct. The `actuallySplice`
# parameter there the boolean value of that equality check.
lib: pkgs: actuallySplice:

let
  defaultBuildBuildScope = pkgs.buildPackages.buildPackages // pkgs.buildPackages.buildPackages.xorg;
  defaultBuildHostScope = pkgs.buildPackages // pkgs.buildPackages.xorg;
  defaultBuildTargetScope =
    if pkgs.targetPlatform == pkgs.hostPlatform
    then defaultBuildHostScope
    else assert pkgs.hostPlatform == pkgs.buildPlatform; defaultHostTargetScope;
  defaultHostHostScope = {}; # unimplemented
  # TODO(@Ericson2314): we shouldn't preclude run-time fetching by removing
  # these attributes. We should have a more general solution for selecting
  # whether `nativeDrv` or `crossDrv` is the default in `defaultScope`.
  pkgsWithoutFetchers = lib.filterAttrs (n: _: !lib.hasPrefix "fetch" n) pkgs;
  targetPkgsWithoutFetchers = lib.filterAttrs (n: _: !lib.hasPrefix "fetch" n) pkgs.targetPackages;
  defaultHostTargetScope = pkgsWithoutFetchers // pkgs.xorg;
  defaultTargetTargetScope = targetPkgsWithoutFetchers // targetPkgsWithoutFetchers.xorg or {};

  splicer = pkgsBuildBuild: pkgsBuildHost: pkgsBuildTarget:
            pkgsHostHost: pkgsHostTarget:
            pkgsTargetTarget: let
    mash =
      # Other pkgs sets
      pkgsBuildBuild // pkgsBuildTarget // pkgsHostHost // pkgsTargetTarget
      # The same pkgs sets one probably intends
      // pkgsBuildHost // pkgsHostTarget;
    merge = name: {
      inherit name;
      value = let
        defaultValue = mash.${name};
        # `or {}` is for the non-derivation attsert splicing case, where `{}` is the identity.
        valueBuildBuild = pkgsBuildBuild.${name} or {};
        valueBuildHost = pkgsBuildHost.${name} or {};
        valueBuildTarget = pkgsBuildTarget.${name} or {};
        valueHostHost = throw "`valueHostHost` unimplemented: pass manually rather than relying on splicer.";
        valueHostTarget = pkgsHostTarget.${name} or {};
        valueTargetTarget = pkgsTargetTarget.${name} or {};
        augmentedValue = defaultValue
          # TODO(@Ericson2314): Stop using old names after transition period
          // (lib.optionalAttrs (pkgsBuildHost ? ${name}) { nativeDrv = valueBuildHost; })
          // (lib.optionalAttrs (pkgsHostTarget ? ${name}) { crossDrv = valueHostTarget; })
          // {
            __spliced =
                 (lib.optionalAttrs (pkgsBuildBuild ? ${name}) { buildBuild = valueBuildBuild; })
              // (lib.optionalAttrs (pkgsBuildTarget ? ${name}) { buildTarget = valueBuildTarget; })
              // { hostHost = valueHostHost; }
              // (lib.optionalAttrs (pkgsTargetTarget ? ${name}) { targetTarget = valueTargetTarget;
          });
        };
        # Get the set of outputs of a derivation. If one derivation fails to
        # evaluate we don't want to diverge the entire splice, so we fall back
        # on {}
        tryGetOutputs = value0: let
          inherit (builtins.tryEval value0) success value;
        in getOutputs (lib.optionalAttrs success value);
        getOutputs = value: lib.genAttrs
          (value.outputs or (lib.optional (value ? out) "out"))
          (output: value.${output});
      in
        # The derivation along with its outputs, which we recur
        # on to splice them together.
        if lib.isDerivation defaultValue then augmentedValue // splicer
          (tryGetOutputs valueBuildBuild) (tryGetOutputs valueBuildHost) (tryGetOutputs valueBuildTarget)
          (tryGetOutputs valueHostHost) (getOutputs valueHostTarget)
          (tryGetOutputs valueTargetTarget)
        # Just recur on plain attrsets
        else if lib.isAttrs defaultValue then splicer
          valueBuildBuild valueBuildHost valueBuildTarget
          {} valueHostTarget
          valueTargetTarget
        # Don't be fancy about non-derivations. But we could have used used
        # `__functor__` for functions instead.
        else defaultValue;
    };
  in lib.listToAttrs (map merge (lib.attrNames mash));

  splicedPackages =
    if actuallySplice
    then
      splicer
        defaultBuildBuildScope defaultBuildHostScope defaultBuildTargetScope
        defaultHostHostScope defaultHostTargetScope
        defaultTargetTargetScope
      // {
        # These should never be spliced under any circumstances
        inherit (pkgs) pkgs buildPackages targetPackages
          buildPlatform targetPlatform hostPlatform;
      }
    else pkgs // pkgs.xorg;

in

{
  # We use `callPackage' to be able to omit function arguments that can be
  # obtained `pkgs` or `buildPackages` and their `xorg` package sets. Use
  # `newScope' for sets of packages in `pkgs' (see e.g. `gnome' below).
  callPackage = pkgs.newScope {};

  callPackages = lib.callPackagesWith splicedPackages;

  newScope = extra: lib.callPackageWith (splicedPackages // extra);
}
