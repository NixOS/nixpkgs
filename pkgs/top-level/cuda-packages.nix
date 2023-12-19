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

      # Helper function to get the general fixup function for a redistributable package.
      getGeneralFixupFn =
        {
          redistName,
          args ? { },
        }:
        final.callPackage config.${redistName}.generalFixupFn args;

      # Helper function to get the indexed fixup function for a redistributable package.
      getIndexedFixupFn =
        { redistName }:
        trivial.pipe config.${redistName}.indexedFixupFn [
          # If it's a path, we need to import it before passing it along.
          # The default value is an empty attrset so we don't need to import it.
          (iff: if builtins.isPath iff then builtins.import iff else iff)
          callPackageOnAttrs
        ];

      # Helper function which wraps the generic manifest builder.
      genericManifestBuilderFn =
        {
          pname,
          redistName,
          manifests,
          generalFixupFn,
          indexedFixupFn,
          libPath ? null,
        }:
        trivial.pipe ../development/cuda-modules/generic-builders/manifest.nix [
          # Build the package
          (
            path:
            final.callPackage path {
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
        ];

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
    // (
      let
        redistName = "cuda";

        # Retrieve the manifests for our cudaVersion.
        # We unconditionally access manifests.feature so we need to make sure it exists (even if it is empty).
        # manifests :: { redistrib, feature }
        manifests =
          attrsets.attrByPath
            [
              redistName
              "manifests"
              cudaVersion
            ]
            ({
              redistrib = { };
              feature = { };
            })
            config;

        # Retrieve our fixup functions.
        generalFixupFn = getGeneralFixupFn { 
          inherit redistName;
          args = {inherit manifests; };
        };
        indexedFixupFn = getIndexedFixupFn { inherit redistName; };

        # Build a single redistributable package.
        buildRedistPackage =
          pname:
          genericManifestBuilderFn {
            inherit
              manifests
              pname
              redistName
              generalFixupFn
              indexedFixupFn
              ;
          };

        # Map our buildRedistPackage function over all the packages in manifests.feature.
        # This is an empty attrset if manifests.feature is empty, which is what we want.
        redistPackages = trivial.pipe manifests.feature [
          # Get all the package names
          builtins.attrNames
          # Build the redist packages
          (trivial.flip attrsets.genAttrs buildRedistPackage)
        ];
      in
      redistPackages
    )
    # CuTensor
    // (
      let
        # redistArch :: Optional String
        redistArch = flags.getRedistArch hostPlatform.system;
        redistName = "cutensor";
        pname = "libcutensor";
        
        # Our cudaVersion tells us which version of CUDA we're building against.
        # The subdirectories in lib/ tell us which versions of CUDA are supported.
        # Typically the names will look like this:
        #
        # - 10.2
        # - 11
        # - 11.0
        # - 12
        # libPath :: String
        libPath = if cudaVersion == "10.2" then cudaVersion else cudaMajorVersion;
        
        # Our build for cutensor is actually multiplexed -- we build a cutensor package for each version of CUDA that
        # cutensor supports. Currently, we don't know ahead of time what the contents of the lib directory are for
        # each package, so building these is best-effort.
        # manifests :: { ${version} = { redistrib, feature }; }
        manifests =
          attrsets.filterAttrs
            (
              _version: manifests:
              lists.all trivial.id [
                # Platform must be supported
                (redistArch != null)
                (
                  attrsets.attrByPath
                    [
                      pname
                      redistArch
                    ]
                    null
                    manifests.feature != null
                )
              ]
            )
            config.${redistName}.manifests;

        # Retrieve our fixup functions.
        generalFixupFn = getGeneralFixupFn { inherit redistName; };
        indexedFixupFn = getIndexedFixupFn { inherit redistName; };

        redistPackages =
          attrsets.mapAttrs'
            (version: manifests: {
              name = mkVersionedPackageName pname version;
              value = genericManifestBuilderFn {
                inherit
                  manifests
                  pname
                  redistName
                  generalFixupFn
                  indexedFixupFn
                  libPath
                  ;
              };
            })
            manifests;
      in
      redistPackages
      // attrsets.optionalAttrs (redistPackages != { }) {
        ${pname} =
          let
            # Get the newest version in our pruned manifests.
            nameOfNewest = trivial.pipe manifests [
              # Get all the versions
              builtins.attrNames
              # Sort in descending order
              (lists.sort (trivial.flip strings.versionOlder))
              # Get the first element
              builtins.head
              # Get the name of the newest version
              (mkVersionedPackageName pname)
            ];
          in
          redistPackages.${nameOfNewest};
      }
    )
    # CUDNN
    // (genericMultiplexBuilderFn "cudnn")
    # TensorRT
    // (genericMultiplexBuilderFn "tensorrt");
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
