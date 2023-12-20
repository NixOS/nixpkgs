# Notes:
#
# Silvan (Tweag) covered some things on recursive attribute sets in the Nix Hour:
# https://www.youtube.com/watch?v=BgnUFtd1Ivs
#
# I (@connorbaker) highly recommend watching it.
#
# Most helpful comment regarding recursive attribute sets:
#
# https://github.com/NixOS/nixpkgs/pull/256324#issuecomment-1749935979
#
# To summarize:
#
# - `prev` should only be used to access attributes which are going to be overriden.
# - `final` should only be used to access `callPackage` to build new packages.
# - Attribute names should be computable without relying on `final`.
#   - Extensions should take arguments to build attribute names before relying on `final`.
#
# Silvan's recommendation then is to explicitly use `callPackage` to provide everything our extensions need
# to compute the attribute names, without relying on `final`.
#
# I've (@connorbaker) attempted to do that, though I'm unsure of how this will interact with overrides.
{
  lib,
  hostPlatform,
  pkgs,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  __attrsFailEvaluation ? true,
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    strings
    trivial
    versions
    ;

  # cuda-modules contains all the information we need to build our packages.
  cuda-modules = modules.evalModules {
    modules = [
      {
        # Apply any user-specified overrides.
        imports = pkgs.config.extraCudaModules or [ ];

        inherit (pkgs.config) cudaSupport;
        cudaCapabilities = pkgs.config.cudaCapabilities or [ ];
        cudaForwardCompat = pkgs.config.cudaForwardCompat or true;
      }
      ../development/cuda-modules/modules
    ];
  };
  config = attrsets.dontRecurseIntoAttrs cuda-modules.config;

  mkVersionedPackageName =
    name: version:
    strings.concatStringsSep "_" [
      name
      (strings.replaceStrings [ "." ] [ "_" ] (versions.majorMinor version))
    ];

  # Create a fixed-point for makeScopeWithSplicing' parameterized by cudaVersion.
  makeCudaPackages =
    cudaVersion:
    let
      # Flags used to enable different features of cudaPackages -- we cannot use final.callPackage
      # because we use `flags` to determine the presence of certain packages, which would cause
      # infinite recursion.
      flags = builtins.import ../development/cuda-modules/flags.nix {
        inherit
          pkgs
          lib
          config
          cudaVersion
          hostPlatform
          ;
      };

      # Fixed-length cudaVersion strings
      cudaMajorVersion = versions.major cudaVersion;
      cudaMajorMinorVersion = versions.majorMinor cudaVersion;

      # cudaVersionOlder : Version -> Boolean
      cudaVersionOlder = strings.versionOlder cudaVersion;
      # cudaVersionAtLeast : Version -> Boolean
      cudaVersionAtLeast = strings.versionAtLeast cudaVersion;
    in

    final:
    let
      # NOTE: Use of `final.callPackage` for `callPackageOnAttrs` doesn't run the risk of infinite recursion,
      # as the `final` argument is not used to compute the attribute names.
      callPackageOnAttrs = attrsets.mapAttrs (_: value: final.callPackage value { });

      # Helper function which wraps the generic manifest builder.
      # Manifests have the shape { ${version} = { redistrib, feature }; }
      # This builder will create an attribute set containing packages from each pair of redistributable and feature
      # manifests for a given redistName.
      #
      # If `version` is non-null, only the package set for that version will be returned. No suffix will be appended.
      #
      # Otherwise, package sets for each version will be suffixed with the version and unioned with each other and the
      # package set from the newest version of the manifest, which will not be suffixed.
      # This means that packages from the newest manifest are available both with and without a suffix, while packages
      # from older manifests are only available with a suffix.
      genericManifestBuilderFn =
        {
          redistName,
          useLibPath,
          # If version is specified, only build the redistributable package for that version.
          version ? null,
        }:
        let
          # TODO(@connorbaker): Update the modules so it's named versionedManifests.
          # Retrieve all versions of the manifests available for our redistName.
          # versionedManifests :: { ${version} = { redistrib, feature }; }
          versionedManifests =
            let
              allVersionedManifests =
                attrsets.attrByPath
                  [
                    redistName
                    "manifests"
                  ]
                  { }
                  config;
            in
            if version != null then
              # If version is specified, only build the redistributable package for that version.
              # If we're specifying the version explicitly, it is assumed that it exists.
              # It will be bother the only and the nested manifest.
              { "${version}" = allVersionedManifests.${version}; }
            else
              allVersionedManifests;

          # Our cudaVersion tells us which version of CUDA we're building against.
          # The subdirectories in lib/ tell us which versions of CUDA are supported.
          # Typically the names will look like this:
          #
          # - 10.2
          # - 11
          # - 11.0
          # - 12
          #
          # Not every package uses this layout, but we can precompute it here.
          # libPath :: String
          libPath =
            if useLibPath then if cudaVersion == "10.2" then cudaVersion else cudaMajorVersion else null;

          # Build a redistributable package given the version and corresponding manifest.
          buildPackageSetFromVersionedManifest =
            let
              # Retrieve our fixup functions which do not rely on the version of the manifest being processed.
              indexedFixupFn = trivial.pipe config.${redistName}.indexedFixupFn [
                # If it's a path, we need to import it before passing it along.
                # The default value is an empty attrset so we don't need to import it.
                (maybePath: if builtins.isPath maybePath then builtins.import maybePath else maybePath)
                # Use callPackage on the values in the attrset.
                callPackageOnAttrs
              ];
            in
            # version :: String
            version:
            let
              # Retrieve our indexedFixupFn, which does not rely on the version of the manifest being processed.
              generalFixupFn = final.callPackage config.${redistName}.generalFixupFn {
                inherit redistName version;
              };
            in
            # manifests :: { redistrib, feature }
            manifests:

            # Map over the attribute names of the feature manifest, which contain only package names.
            attrsets.genAttrs (builtins.attrNames manifests.feature) (
              # pname :: String
              pname:
              trivial.pipe pname [
                # Build the package
                (
                  pname:
                  final.callPackage ../development/cuda-modules/generic-builders/manifest.nix {
                    inherit
                      pname
                      redistName
                      manifests
                      libPath
                      ;
                  }
                )
                # General package fixup
                (drv: drv.overrideAttrs generalFixupFn)
                # Package-specific fixup if it exists
                (drv: drv.overrideAttrs (attrsets.attrByPath [ pname ] { } indexedFixupFn))
              ]
            );

          # For each version in our manifests, build a package set.
          # Do not rename packages yet; that's handled later.
          versionedPackageSets = attrsets.mapAttrs buildPackageSetFromVersionedManifest versionedManifests;

          # Fold over any remaining package sets and append a suffix to the package names.
          flattenedVersionedSuffixedPackageSets =
            attrsets.concatMapAttrs
              (
                # version :: String
                version:
                # packages :: { ${pname} = drv; }
                packages:
                attrsets.mapAttrs'
                  (pname: drv: {
                    name = mkVersionedPackageName pname version;
                    value = drv;
                  })
                  packages
              )
              versionedPackageSets;
        in
        trivial.throwIf (versionedPackageSets == { })
          ''
            No manifests found for ${redistName}.
            Please check that there are in fact manifest files present and that there are not filtered out by a version
            check or (within the module evaluation) by an incorrect manifest filename (which would case the regex to
            fail to match).
          ''
          (
            let
              # Since versionedPackageSets is non-empty, we can safely assume that newestToOldestVersion is non-empty.
              newestToOldestVersion = lists.sort (trivial.flip strings.versionOlder) (
                builtins.attrNames versionedManifests
              );
              newestVersion = builtins.head newestToOldestVersion;
              newestPackageSet = versionedPackageSets.${newestVersion};
            in
            if version != null then
              # If version is non-null, just return the newest package set.
              newestPackageSet
            else
              # Otherwise, return the flattened package set unioned with the default package set (the newest).
              newestPackageSet // flattenedVersionedSuffixedPackageSets
          );
      # Helper function which wraps the generic multiplex builder.
      genericMultiplexBuilderFn =
        pname:
        (builtins.import ../development/cuda-modules/generic-builders/multiplex.nix {
          inherit (final) callPackage;
          inherit
            cudaVersion
            mkVersionedPackageName
            hostPlatform
            lib
            config
            flags
            pname
            ;
        });
    in
    # Basic things callPackage should have available
    {
      inherit lib pkgs;
      inherit config cudaVersion flags;
      inherit cudaVersionAtLeast cudaVersionOlder;
      inherit cudaMajorVersion cudaMajorMinorVersion;

      # TODO(@connorbaker): `cudaFlags` is an alias for `flags` which should be removed in the future.
      cudaFlags = flags;

      # Maintain a reference to the final cudaPackages.
      # Without this, if we use `final.callPackage` and a package accepts `cudaPackages` as an argument,
      # it's provided with `cudaPackages` from the top-level scope, which is not what we want. We want to
      # provide the `cudaPackages` from the final scope -- that is, the *current* scope.
      cudaPackages = final;
    }
    # Loose packages
    // {
      cudatoolkit = final.callPackage ../development/cuda-modules/cudatoolkit { };
      saxpy = final.callPackage ../development/cuda-modules/saxpy { };
      nccl = final.callPackage ../development/cuda-modules/nccl { };
      nccl-tests = final.callPackage ../development/cuda-modules/nccl-tests { };
      # Exposed as cudaPackages.backendStdenv.
      # This is what nvcc uses as a backend,
      # and it has to be an officially supported one (e.g. gcc11 for cuda11).
      #
      # It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
      # when linked with other C++ libraries.
      # E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
      # Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
      backendStdenv = final.callPackage ../development/cuda-modules/backend-stdenv.nix { };
    }
    # Setup hooks
    // callPackageOnAttrs (builtins.import ../development/cuda-modules/setup-hooks)
    # Redistributable packages
    // genericManifestBuilderFn {
      redistName = "cuda";
      useLibPath = false;
      version = cudaVersion;
    }
    # CuTensor
    # Our build for cutensor is actually multiplexed -- we build a cutensor package for each version of CUDA that
    # cutensor supports. Currently, we don't know ahead of time what the contents of the lib directory are for
    # each package, so building these is best-effort.
    // genericManifestBuilderFn {
      redistName = "cutensor";
      useLibPath = true;
    }
    # CUDNN
    // genericMultiplexBuilderFn "cudnn"
    # TensorRT
    // genericMultiplexBuilderFn "tensorrt";
in
trivial.pipe config.versions [
  (builtins.map (
    cudaVersion: {
      name = mkVersionedPackageName "cudaPackages" cudaVersion;
      value =
        attrsets.recurseIntoAttrs (
          makeScopeWithSplicing' {
            otherSplices = generateSplicesForMkScope "cudaPackages";
            f = makeCudaPackages cudaVersion;
          }
        )
        // {
          inherit __attrsFailEvaluation;
        };
    }
  ))
  # Make sure not to recurse into config
  builtins.listToAttrs
]

# TODO(@connorbaker): migrate tests away from extensions.
#   composedExtension =
#     fixedPoints.composeManyExtensions
#       [
#         # (callPackage ../test/cuda/cuda-samples/extension.nix { inherit cudaVersion; })
#         # (callPackage ../test/cuda/cuda-library-samples/extension.nix { })
#       ];
