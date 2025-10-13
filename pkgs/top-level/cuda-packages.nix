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
# - `prev` should only be used to access attributes which are going to be overridden.
# - `final` should only be used to access `callPackage` to build new packages.
# - Attribute names are evaluated eagerly ("NAMESET STRICTNESS").
#   - Extensions must not depend on `final` when computing names and count of new attributes.
#
# Silvan's recommendation then is to explicitly use `callPackage` to provide everything our
# extensions need to compute the attribute names, without relying on `final`.
#
# I've (@connorbaker) attempted to do that, though I'm unsure of how this will interact with overrides.
{
  config,
  _cuda,
  cudaMajorMinorVersion,
  lib,
  pkgs,
  stdenv,
  runCommand,
}:
let
  inherit (lib)
    attrsets
    customisation
    fixedPoints
    lists
    strings
    versions
    ;

  cudaLib = _cuda.lib;

  # Since Jetson capabilities are never built by default, we can check if any of them were requested
  # through final.config.cudaCapabilities and use that to determine if we should change some manifest versions.
  # Copied from backendStdenv.
  jetsonCudaCapabilities = lib.filter (
    cudaCapability: _cuda.db.cudaCapabilityToInfo.${cudaCapability}.isJetson
  ) _cuda.db.allSortedCudaCapabilities;
  hasJetsonCudaCapability =
    lib.intersectLists jetsonCudaCapabilities (config.cudaCapabilities or [ ]) != [ ];
  redistSystem = _cuda.lib.getRedistSystem hasJetsonCudaCapability stdenv.hostPlatform.system;

  # We must use an instance of Nixpkgs where the CUDA package set we're building is the default; if we do not, members
  # of the versioned, non-default package sets may rely on (transitively) members of the default, unversioned CUDA
  # package set.
  # See `Using cudaPackages.pkgs` in doc/languages-frameworks/cuda.section.md for more information.
  pkgs' =
    let
      cudaPackagesUnversionedName = "cudaPackages";
      cudaPackagesMajorVersionName = cudaLib.mkVersionedName cudaPackagesUnversionedName (
        versions.major cudaMajorMinorVersion
      );
      cudaPackagesMajorMinorVersionName = cudaLib.mkVersionedName cudaPackagesUnversionedName cudaMajorMinorVersion;
    in
    # If the CUDA version of pkgs matches our CUDA version, we are constructing the default package set and can use
    # pkgs without modification.
    if pkgs.cudaPackages.cudaMajorMinorVersion == cudaMajorMinorVersion then
      pkgs
    else
      pkgs.extend (
        final: _: {
          recurseForDerivations = false;
          # The CUDA package set will be available as cudaPackages_x_y, so we need only update the aliases for the
          # minor-versioned and unversioned package sets.
          # cudaPackages_x = cudaPackages_x_y
          ${cudaPackagesMajorVersionName} = final.${cudaPackagesMajorMinorVersionName};
          # cudaPackages = cudaPackages_x
          ${cudaPackagesUnversionedName} = final.${cudaPackagesMajorVersionName};
        }
      );

  passthruFunction = final: {
    # NOTE:
    # It is important that _cuda is not part of the package set fixed-point. As described by
    # @SomeoneSerge:
    # > The layering should be: configuration -> (identifies/is part of) cudaPackages -> (is built using) cudaLib.
    # > No arrows should point in the reverse directions.
    # That is to say that cudaLib should only know about package sets and configurations, because it implements
    # functionality for interpreting configurations, resolving them against data, and constructing package sets.
    # This decision is driven both by a separation of concerns and by "NAMESET STRICTNESS" (see above).
    # Also see the comment in `pkgs/top-level/all-packages.nix` about the `_cuda` attribute.

    inherit cudaMajorMinorVersion;

    pkgs = pkgs';

    cudaNamePrefix = "cuda${cudaMajorMinorVersion}";

    cudaMajorVersion = versions.major cudaMajorMinorVersion;
    cudaOlder = strings.versionOlder cudaMajorMinorVersion;
    cudaAtLeast = strings.versionAtLeast cudaMajorMinorVersion;

    flags =
      cudaLib.formatCapabilities {
        inherit (final.backendStdenv) cudaCapabilities cudaForwardCompat;
        inherit (_cuda.db) cudaCapabilityToInfo;
      }
      # TODO(@connorbaker): Enable the corresponding warnings in `../development/cuda-modules/aliases.nix` after some
      # time to allow users to migrate to cudaLib and backendStdenv.
      // {
        inherit (cudaLib) dropDots;
        cudaComputeCapabilityToName =
          cudaCapability: _cuda.db.cudaCapabilityToInfo.${cudaCapability}.archName;
        dropDot = cudaLib.dropDots;
        isJetsonBuild = final.backendStdenv.hasJetsonCudaCapability;
      };

    # Loose packages
    # Barring packages which share a home (e.g., cudatoolkit), new packages
    # should be added to ../development/cuda-modules/packages in "by-name" style, where they will be automatically
    # discovered and added to the package set.

    # TODO: Move to aliases.nix once all Nixpkgs has migrated to the splayed CUDA packages
    cudatoolkit = final.callPackage ../development/cuda-modules/cudatoolkit/redist-wrapper.nix { };

    tests =
      let
        bools = [
          true
          false
        ];
        configs = {
          openCVFirst = bools;
          useOpenCVDefaultCuda = bools;
          useTorchDefaultCuda = bools;
        };
        builder =
          {
            openCVFirst,
            useOpenCVDefaultCuda,
            useTorchDefaultCuda,
          }@config:
          {
            name = strings.concatStringsSep "-" (
              [
                "test"
                (if openCVFirst then "opencv" else "torch")
              ]
              ++ lists.optionals (if openCVFirst then useOpenCVDefaultCuda else useTorchDefaultCuda) [
                "with-default-cuda"
              ]
              ++ [
                "then"
                (if openCVFirst then "torch" else "opencv")
              ]
              ++ lists.optionals (if openCVFirst then useTorchDefaultCuda else useOpenCVDefaultCuda) [
                "with-default-cuda"
              ]
            );
            value = final.callPackage ../development/cuda-modules/tests/opencv-and-torch config;
          };
      in
      attrsets.listToAttrs (attrsets.mapCartesianProduct builder configs)
      // {
        flags = final.callPackage ../development/cuda-modules/tests/flags.nix { };
      };
  };

  composedExtension = fixedPoints.composeManyExtensions (
    [
      (
        final: _:
        {
          # Prevent missing attribute errors
          # NOTE(@connorbaker): CUDA 12.3 does not have a cuda_compat package; indeed, none of the release supports
          # Jetson devices. To avoid errors in the case that cuda_compat is not defined, we have a dummy package which
          # is always defined, but does nothing, will not build successfully, and has no platforms.
          cuda_compat = runCommand "cuda_compat" { meta.platforms = [ ]; } "false";
        }
        // lib.packagesFromDirectoryRecursive {
          inherit (final) callPackage;
          directory = ../development/cuda-modules/packages;
        }
      )
      (import ../development/cuda-modules/cuda/extension.nix { inherit cudaMajorMinorVersion lib; })
      (import ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit
          cudaLib
          cudaMajorMinorVersion
          lib
          redistSystem
          stdenv
          ;
        pname = "cudnn";
        redistName = "cudnn";
        releasesModule = ../development/cuda-modules/cudnn/releases.nix;
        shimsFn = ../development/cuda-modules/cudnn/shims.nix;
      })
      (import ../development/cuda-modules/cutensor/extension.nix {
        inherit
          cudaLib
          cudaMajorMinorVersion
          lib
          redistSystem
          ;
      })
      (import ../development/cuda-modules/cusparselt/extension.nix {
        inherit
          cudaLib
          lib
          redistSystem
          ;
      })
      (import ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit
          cudaLib
          cudaMajorMinorVersion
          lib
          redistSystem
          stdenv
          ;
        pname = "tensorrt";
        redistName = "tensorrt";
        releasesModule = ../development/cuda-modules/tensorrt/releases.nix;
        shimsFn = ../development/cuda-modules/tensorrt/shims.nix;
      })
      (import ../development/cuda-modules/cuda-library-samples/extension.nix { inherit lib stdenv; })
    ]
    ++ lib.optionals config.allowAliases [
      (import ../development/cuda-modules/aliases.nix { inherit lib; })
    ]
    ++ _cuda.extensions
  );

  cudaPackages = customisation.makeScope pkgs'.newScope (
    fixedPoints.extends composedExtension passthruFunction
  );
in
cudaPackages
