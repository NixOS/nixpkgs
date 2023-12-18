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
  callPackage,
  cudaVersion,
  lib,
  hostPlatform,
  newScope,
  pkgs,
  __attrsFailEvaluation ? true,
}:
let
  inherit (lib)
    attrsets
    fixedPoints
    modules
    options
    strings
    trivial
    types
    versions
    ;
  # Utility function
  # nullableOr : Optional a -> a -> a
  nullableOr = nullable: default: if nullable != null then nullable else default;

  evaluatedModules = modules.evalModules {
    modules = [
      {
        options.cudaVersion = options.mkOption {
          description = "The version of CUDA to use.";
          type = types.str;
        };
        config = {
          inherit cudaVersion;
        };
      }
      ../development/cuda-modules/modules
    ];
  };

  genericManifestBuilderFn =
    {
      callPackage,
      pname,
      redistName,
      manifests,
      libPath ? null,
      overrideAttrsFns ? [ ],
    }:
    let
      drv = callPackage ../development/cuda-modules/generic-builders/manifest.nix {
        inherit
          pname
          redistName
          manifests
          libPath
          ;
      };
    in
    builtins.foldl' (drv: overrideAttrsFn: drv.overrideAttrs overrideAttrsFn) drv overrideAttrsFns;

  # Backbone
  gpus = builtins.import ../development/cuda-modules/gpus.nix;
  nvccCompatibilities = builtins.import ../development/cuda-modules/nvcc-compatibilities.nix;
  flags = callPackage ../development/cuda-modules/flags.nix { inherit cudaVersion gpus; };
  passthruFunction =
    (
      final:
      {
        inherit cudaVersion lib pkgs;
        inherit
          gpus
          nvccCompatibilities
          flags
          evaluatedModules
          ;
        cudaMajorVersion = versions.major cudaVersion;
        cudaMajorMinorVersion = versions.majorMinor cudaVersion;
        # cudaVersionOlder : Version -> Boolean
        cudaVersionOlder = strings.versionOlder cudaVersion;
        # cudaVersionAtLeast : Version -> Boolean
        cudaVersionAtLeast = strings.versionAtLeast cudaVersion;

        # Maintain a reference to the final cudaPackages.
        # Without this, if we use `final.callPackage` and a package accepts `cudaPackages` as an argument,
        # it's provided with `cudaPackages` from the top-level scope, which is not what we want. We want to
        # provide the `cudaPackages` from the final scope -- that is, the *current* scope.
        cudaPackages = final;

        # TODO(@connorbaker): `cudaFlags` is an alias for `flags` which should be removed in the future.
        cudaFlags = flags;

        # Exposed as cudaPackages.backendStdenv.
        # This is what nvcc uses as a backend,
        # and it has to be an officially supported one (e.g. gcc11 for cuda11).
        #
        # It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
        # when linked with other C++ libraries.
        # E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
        # Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
        backendStdenv = final.callPackage ../development/cuda-modules/backend-stdenv.nix { };

        # Loose packages
        cudatoolkit = final.callPackage ../development/cuda-modules/cudatoolkit { };
        saxpy = final.callPackage ../development/cuda-modules/saxpy { };
        nccl = final.callPackage ../development/cuda-modules/nccl { };
        nccl-tests = final.callPackage ../development/cuda-modules/nccl-tests { };
      }
      # Setup hooks
      // builtins.import ../development/cuda-modules/setup-hooks { inherit (final) callPackage; }
      # Redistributable packages
      // (
        let
          redistName = "cuda";
          inherit (evaluatedModules.config.${redistName}) manifests;

          # NOTE: The attribute values need to be callPackage'd before being used.
          fixupFns = builtins.import ../development/cuda-modules/cuda/fixups.nix;
          # NOTE: fixupFn is good to go as-is.
          metaFixupFn = builtins.import ../development/cuda-modules/cuda/meta-fixup.nix {
            inherit lib manifests nullableOr;
          };

          # Builder function which builds a single redist package for a given platform.
          # buildRedistPackage : PackageName -> Derivation
          buildRedistPackage =
            pname:
            genericManifestBuilderFn {
              inherit (final) callPackage;
              inherit manifests pname redistName;
              overrideAttrsFns = [
                metaFixupFn
              ] ++ lib.optionals (builtins.hasAttr pname fixupFns) [ (final.callPackage fixupFns.${pname} { }) ];
            };

          redistPackages = trivial.pipe manifests.feature [
            # Get all the package names
            builtins.attrNames
            # Build the redist packages
            (trivial.flip attrsets.genAttrs buildRedistPackage)
          ];
        in
        redistPackages
      )
      # CUDNN
      // (builtins.import ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit (final) callPackage;
        inherit
          cudaVersion
          flags
          mkVersionedPackageName
          hostPlatform
          lib
          evaluatedModules
          ;
        pname = "cudnn";
        shimsFn = ../development/cuda-modules/cudnn/shims.nix;
        fixupFn = ../development/cuda-modules/cudnn/fixup.nix;
      })
    );

  mkVersionedPackageName =
    name: version:
    strings.concatStringsSep "_" [
      name
      (strings.replaceStrings [ "." ] [ "_" ] (versions.majorMinor version))
    ];

  composedExtension =
    fixedPoints.composeManyExtensions
      [
        # (callPackage ../development/cuda-modules/cutensor/extension.nix {
        #   inherit cudaVersion flags mkVersionedPackageName;
        # })
        # (callPackage ../development/cuda-modules/generic-builders/multiplex.nix {
        #   inherit cudaVersion flags mkVersionedPackageName;
        #   pname = "tensorrt";
        #   releasesModule = ../development/cuda-modules/tensorrt/releases.nix;
        #   shimsFn = ../development/cuda-modules/tensorrt/shims.nix;
        #   fixupFn = ../development/cuda-modules/tensorrt/fixup.nix;
        # })
        # (callPackage ../test/cuda/cuda-samples/extension.nix { inherit cudaVersion; })
        # (callPackage ../test/cuda/cuda-library-samples/extension.nix { })
      ];

  # cudaPackages = customisation.makeScope newScope (
  #   fixedPoints.extends composedExtension passthruFunction
  # );

  cudaPackages = pkgs.makeScopeWithSplicing' {
    otherSplices = pkgs.generateSplicesForMkScope "cudaPackages";
    f = fixedPoints.extends composedExtension passthruFunction;
    # f = final: {
    #   # Recursive reference to the initial cudaPackages' cudaVersion.
    #   inherit (config.cudaPackages) cudaVersion;
    #   gpus = builtins.import ../gpus.nix;
    #   nvccCompatibilities = builtins.import ../nvcc-compatibilities.nix;
    #   cudaMajorVersion = versions.major final.cudaVersion;
    #   cudaMajorMinorVersion = versions.majorMinor final.cudaVersion;
    #   # flags = final.callPackage ../flags.nix { };
    #   # Exposed as cudaPackages.backendStdenv.
    #   # This is what nvcc uses as a backend,
    #   # and it has to be an officially supported one (e.g. gcc11 for cuda11).
    #   #
    #   # It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
    #   # when linked with other C++ libraries.
    #   # E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
    #   # Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
    #   backendStdenv = final.callPackage ../backend-stdenv.nix { };
    # };
  };
in
cudaPackages // { inherit __attrsFailEvaluation; }
