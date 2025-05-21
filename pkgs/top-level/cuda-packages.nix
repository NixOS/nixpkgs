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
  cudaMajorMinorVersion,
  lib,
  newScope,
  pkgs,
  stdenv,
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
  # MUST be defined outside fix-point (cf. "NAMESET STRICTNESS" above)
  fixups = import ../development/cuda-modules/fixups { inherit lib; };
  gpus = import ../development/cuda-modules/gpus.nix;
  nvccCompatibilities = import ../development/cuda-modules/nvcc-compatibilities.nix;
  flags = import ../development/cuda-modules/flags.nix {
    inherit
      config
      cudaMajorMinorVersion
      gpus
      lib
      stdenv
      ;
  };

  mkVersionedPackageName =
    name: version: name + "_" + strings.replaceStrings [ "." ] [ "_" ] (versions.majorMinor version);

  passthruFunction = final: {
    inherit
      cudaMajorMinorVersion
      fixups
      flags
      gpus
      lib
      nvccCompatibilities
      pkgs
      ;
    cudaMajorVersion = versions.major cudaMajorMinorVersion;
    cudaOlder = strings.versionOlder cudaMajorMinorVersion;
    cudaAtLeast = strings.versionAtLeast cudaMajorMinorVersion;

    # NOTE: mkVersionedPackageName is an internal, implementation detail and should not be relied on by outside consumers.
    # It may be removed in the future.
    inherit mkVersionedPackageName;

    # Maintain a reference to the final cudaPackages.
    # Without this, if we use `final.callPackage` and a package accepts `cudaPackages` as an
    # argument, it's provided with `cudaPackages` from the top-level scope, which is not what we
    # want. We want to provide the `cudaPackages` from the final scope -- that is, the *current*
    # scope. However, we also want to prevent `pkgs/top-level/release-attrpaths-superset.nix` from
    # recursing more than one level here.
    cudaPackages = final // {
      __attrsFailEvaluation = true;
    };

    # Loose packages
    # Barring packages which share a home (e.g., cudatoolkit and cudatoolkit-legacy-runfile), new packages
    # should be added to ../development/cuda-modules/packages in "by-name" style, where they will be automatically
    # discovered and added to the package set.

    # TODO: Move to aliases.nix once all Nixpkgs has migrated to the splayed CUDA packages
    cudatoolkit = final.callPackage ../development/cuda-modules/cudatoolkit/redist-wrapper.nix { };
    cudatoolkit-legacy-runfile = final.callPackage ../development/cuda-modules/cudatoolkit { };

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
      attrsets.listToAttrs (attrsets.mapCartesianProduct builder configs);
  };

  composedExtension = fixedPoints.composeManyExtensions (
    [
      (
        final: _:
        lib.packagesFromDirectoryRecursive {
          inherit (final) callPackage;
          directory = ../development/cuda-modules/packages;
        }
      )
      (import ../development/cuda-modules/cuda/extension.nix { inherit cudaMajorMinorVersion lib; })
      (import ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit
          cudaMajorMinorVersion
          flags
          lib
          mkVersionedPackageName
          stdenv
          ;
        pname = "cudnn";
        redistName = "cudnn";
        releasesModule = ../development/cuda-modules/cudnn/releases.nix;
        shimsFn = ../development/cuda-modules/cudnn/shims.nix;
      })
      (import ../development/cuda-modules/cutensor/extension.nix {
        inherit
          cudaMajorMinorVersion
          flags
          lib
          mkVersionedPackageName
          stdenv
          ;
      })
      (import ../development/cuda-modules/cusparselt/extension.nix {
        inherit
          cudaMajorMinorVersion
          flags
          lib
          mkVersionedPackageName
          stdenv
          ;
      })
      (import ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit
          cudaMajorMinorVersion
          flags
          lib
          mkVersionedPackageName
          stdenv
          ;
        pname = "tensorrt";
        redistName = "tensorrt";
        releasesModule = ../development/cuda-modules/tensorrt/releases.nix;
        shimsFn = ../development/cuda-modules/tensorrt/shims.nix;
      })
      (import ../development/cuda-modules/cuda-samples/extension.nix {
        inherit cudaMajorMinorVersion lib stdenv;
      })
      (import ../development/cuda-modules/cuda-library-samples/extension.nix { inherit lib stdenv; })
    ]
    ++ lib.optionals config.allowAliases [ (import ../development/cuda-modules/aliases.nix) ]
  );

  cudaPackages = customisation.makeScope newScope (
    fixedPoints.extends composedExtension passthruFunction
  );
in
# We want to warn users about the upcoming deprecation of old CUDA
# versions, without breaking Nixpkgs CI with evaluation warnings. This
# gross hack ensures that the warning only triggers if aliases are
# enabled, which is true by default, but not for ofborg.
lib.warnIf (cudaPackages.cudaOlder "12.0" && config.allowAliases)
  "CUDA versions older than 12.0 will be removed in Nixpkgs 25.05; see the 24.11 release notes for more information"
  cudaPackages
