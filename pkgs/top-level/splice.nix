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
  defaultBuildScope = pkgs.buildPackages // pkgs.buildPackages.xorg;
  # TODO(@Ericson2314): we shouldn't preclude run-time fetching by removing
  # these attributes. We should have a more general solution for selecting
  # whether `nativeDrv` or `crossDrv` is the default in `defaultScope`.
  pkgsWithoutFetchers = lib.filterAttrs (n: _: !lib.hasPrefix "fetch" n) pkgs;
  defaultRunScope = pkgsWithoutFetchers // pkgs.xorg;

  splicer = buildPkgs: runPkgs: let
    mash = buildPkgs // runPkgs;
    merge = name: {
      inherit name;
      value = let
        defaultValue = mash.${name};
        buildValue = buildPkgs.${name} or {};
        runValue = runPkgs.${name} or {};
        augmentedValue = defaultValue
          // (lib.optionalAttrs (buildPkgs ? ${name}) { nativeDrv = buildValue; })
          // (lib.optionalAttrs (runPkgs ? ${name}) { crossDrv = runValue; });
        # Get the set of outputs of a derivation
        getOutputs = value:
          lib.genAttrs (value.outputs or []) (output: value.${output});
      in
        # Certain *Cross derivations will fail assertions, but we need their
        # nativeDrv. We are assuming anything that fails to evaluate is an
        # attrset (including derivation) and thus can be unioned.
        if !(builtins.tryEval defaultValue).success then augmentedValue
        # The derivation along with its outputs, which we recur
        # on to splice them together.
        else if lib.isDerivation defaultValue then augmentedValue
          // splicer (getOutputs buildValue) (getOutputs runValue)
        # Just recur on plain attrsets
        else if lib.isAttrs defaultValue then splicer buildValue runValue
        # Don't be fancy about non-derivations. But we could have used used
        # `__functor__` for functions instead.
        else defaultValue;
    };
  in lib.listToAttrs (map merge (lib.attrNames mash));

  splicedPackages =
    if actuallySplice
    then splicer defaultBuildScope defaultRunScope // {
      # These should never be spliced under any circumstances
      inherit (pkgs) pkgs buildPackages __targetPackages
        buildPlatform targetPlatform hostPlatform;
    }
    else pkgs // pkgs.xorg;

in

{
  # We use `callPackage' to be able to omit function arguments that can be
  # obtained `pkgs` or `buildPackages` and their `xorg` package sets. Use
  # `newScope' for sets of packages in `pkgs' (see e.g. `gnome' below).
  callPackage = pkgs.newScope {};

  callPackageWithOutput = pkgs.newScopeWithOutput {};

  callPackages = lib.callPackagesWith splicedPackages;

  newScope = extra: lib.callPackageWith (splicedPackages // extra);

  newScopeWithOutput = extra: lib.callPackageWithOutputWith (splicedPackages // extra);
}
