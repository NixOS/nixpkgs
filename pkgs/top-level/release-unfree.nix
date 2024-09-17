/*
    NixOS unstable packages

    This release file is currently not tested on hydra.nixos.org
    because it requires unfree software, but it is tested by
    <https://hydra.nix-community.org/jobset/nixpkgs/unfree>.

    Cf. https://github.com/nix-community/infra/pull/1406

    Test for example like this:

        $ hydra-eval-jobs pkgs/top-level/release-unfree.nix -I .
*/

{
  # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  # Attributes passed to nixpkgs.
  nixpkgsArgs ? {
    config = {
      allowAliases = false;
      allowUnfree = true;
      cudaSupport = true;
      inHydra = true;
    };
  },
  # We only build the full package set on infrequently releasing channels.
  full ? false,
}:

let
  release-lib = import ./release-lib.nix {
    inherit supportedSystems nixpkgsArgs;
  };

  inherit (release-lib)
    lib
    mapTestOn
    pkgs
    ;

  # similar to release-lib.packagePlatforms, but also includes some condition for which package to pick
  packagesWith =
    prefix: cond:
    lib.mapAttrs (
      name: value:
      let
        attrPath = "${prefix}.${name}";
        res = builtins.tryEval (
          if lib.isDerivation value then
            lib.optionals (cond attrPath value) (
              # logic copied from release-lib packagePlatforms
              value.meta.hydraPlatforms
                or (lib.subtractLists (value.meta.badPlatforms or [ ]) (value.meta.platforms or [ "x86_64-linux" ]))
            )
          else if
            value.recurseForDerivations or false
            || value.recurseForRelease or false
            || value.__recurseIntoDerivationForReleaseJobs or false
          then
            # Recurse
            packagesWith attrPath cond value
          else
            [ ]
        );
      in
      lib.optionals res.success res.value
    );

  isUnfree = pkg: lib.lists.any (l: !(l.free or true)) (lib.lists.toList (pkg.meta.license or [ ]));

  isSource =
    pkg: !lib.lists.any (x: !(x.isSource)) (lib.lists.toList (pkg.meta.sourceProvenance or [ ]));

  isNotLinuxKernel =
    attrPath: !(lib.hasPrefix "linuxKernel" attrPath || lib.hasPrefix "linuxPackages" attrPath);

  # This is handled by release-cuda.nix
  isNotCudaPackage = attrPath: !(lib.hasPrefix "cuda" attrPath);

  canSubstituteSrc =
    pkg:
    # requireFile don't allow using substituters and are therefor skipped
    pkg.src.allowSubstitutes or true;

  cond =
    attrPath: pkg:
    (isUnfree pkg)
    && (isSource pkg)
    && (canSubstituteSrc pkg)
    && (
      if full then
        true
      else
        # By default we also filter for these things
        (isNotCudaPackage attrPath) && (isNotLinuxKernel attrPath)
    );

  packages = packagesWith "" cond pkgs;

  jobs = mapTestOn packages;
in
jobs
