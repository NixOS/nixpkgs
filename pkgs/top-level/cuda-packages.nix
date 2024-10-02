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
# Silvan's recommendation then is to explicitly use `callPackage` to provide everything our
# extensions need to compute the attribute names, without relying on `final`.
#
# I've (@connorbaker) attempted to do that, though I'm unsure of how this will interact with overrides.
{
  callPackage,
  cudaVersion,
  lib,
  newScope,
  pkgs,
  config,
}:
let
  inherit (lib)
    attrsets
    customisation
    fixedPoints
    lists
    strings
    trivial
    versions
    ;
  # Backbone
  gpus = builtins.import ../development/cuda-modules/gpus.nix;
  nvccCompatibilities = builtins.import ../development/cuda-modules/nvcc-compatibilities.nix;
  flags = callPackage ../development/cuda-modules/flags.nix { inherit cudaVersion gpus; };
  passthruFunction = final: ({
    inherit cudaVersion lib pkgs;
    inherit gpus nvccCompatibilities flags;
    cudaMajorVersion = versions.major cudaVersion;
    cudaMajorMinorVersion = versions.majorMinor cudaVersion;
    cudaOlder = strings.versionOlder cudaVersion;
    cudaAtLeast = strings.versionAtLeast cudaVersion;

    # Maintain a reference to the final cudaPackages.
    # Without this, if we use `final.callPackage` and a package accepts `cudaPackages` as an
    # argument, it's provided with `cudaPackages` from the top-level scope, which is not what we
    # want. We want to provide the `cudaPackages` from the final scope -- that is, the *current*
    # scope. However, we also want to prevent `pkgs/top-level/release-attrpaths-superset.nix` from
    # recursing more than one level here.
    cudaPackages = final // {
      __attrsFailEvaluation = true;
    };

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

    # TODO: Move to aliases.nix once all Nixpkgs has migrated to the splayed CUDA packages
    cudatoolkit = final.callPackage ../development/cuda-modules/cudatoolkit/redist-wrapper.nix { };
    cudatoolkit-legacy-runfile = final.callPackage ../development/cuda-modules/cudatoolkit { };

    saxpy = final.callPackage ../development/cuda-modules/saxpy { };
    nccl = final.callPackage ../development/cuda-modules/nccl { };
    nccl-tests = final.callPackage ../development/cuda-modules/nccl-tests { };

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

    writeGpuTestPython = final.callPackage ../development/cuda-modules/write-gpu-test-python.nix { };
  });

  mkVersionedPackageName =
    name: version:
    strings.concatStringsSep "_" [
      name
      (strings.replaceStrings [ "." ] [ "_" ] (versions.majorMinor version))
    ];

  composedExtension = fixedPoints.composeManyExtensions (
    [
      (import ../development/cuda-modules/setup-hooks/extension.nix)
      (callPackage ../development/cuda-modules/cuda/extension.nix { inherit cudaVersion; })
      (import ../development/cuda-modules/cuda/overrides.nix)
      (callPackage ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit cudaVersion flags mkVersionedPackageName;
        pname = "cudnn";
        releasesModule = ../development/cuda-modules/cudnn/releases.nix;
        shimsFn = ../development/cuda-modules/cudnn/shims.nix;
        fixupFn = ../development/cuda-modules/cudnn/fixup.nix;
      })
      (callPackage ../development/cuda-modules/cutensor/extension.nix {
        inherit cudaVersion flags mkVersionedPackageName;
      })
      (callPackage ../development/cuda-modules/generic-builders/multiplex.nix {
        inherit cudaVersion flags mkVersionedPackageName;
        pname = "tensorrt";
        releasesModule = ../development/cuda-modules/tensorrt/releases.nix;
        shimsFn = ../development/cuda-modules/tensorrt/shims.nix;
        fixupFn = ../development/cuda-modules/tensorrt/fixup.nix;
      })
      (callPackage ../development/cuda-modules/cuda-samples/extension.nix { inherit cudaVersion; })
      (callPackage ../development/cuda-modules/cuda-library-samples/extension.nix { })
    ]
    ++ lib.optionals config.allowAliases [ (import ../development/cuda-modules/aliases.nix) ]
  );

  cudaPackages = customisation.makeScope newScope (
    fixedPoints.extends composedExtension passthruFunction
  );
in
cudaPackages
