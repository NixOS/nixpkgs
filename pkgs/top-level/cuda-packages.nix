{ lib
, pkgs
, cudaVersion
}:

with lib;

let

  scope = makeScope pkgs.newScope (final: {
    # Here we put package set configuration and utility functions.
    inherit cudaVersion;
    cudaMajorVersion = versions.major final.cudaVersion;
    cudaMajorMinorVersion = lib.versions.majorMinor final.cudaVersion;
    inherit lib pkgs;

    addBuildInputs = drv: buildInputs: drv.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or []) ++ buildInputs;
    });
  });

  cutensorExtension = final: prev: let
    ### CuTensor

    buildCuTensorPackage = final.callPackage ../development/libraries/science/math/cutensor/generic.nix;

    # FIXME: Include non-x86_64 platforms
    cuTensorVersions = {
      "1.2.2.5" = {
        hash = "sha256-lU7iK4DWuC/U3s1Ct/rq2Gr3w4F2U7RYYgpmF05bibY=";
      };
      "1.5.0.3" = {
        hash = "sha256-T96+lPC6OTOkIs/z3QWg73oYVSyidN0SVkBWmT9VRx0=";
      };
      "2.0.0.7" = {
        hash = "sha256-32M4rtGOW2rgxJUhBT0WBtKkHhh9f17M+RgK9rvE72g=";
      };
    };

    inherit (final) cudaMajorMinorVersion cudaMajorVersion;

    cudaToCutensor = {
      "10" = "1.2.25";
      "11" = "1.5.0.3";
      "12" = "2.0.0.7";
    };

    versionNewer = lib.flip lib.versionOlder;
    latestVersion = (builtins.head (lib.sort versionNewer (builtins.attrNames cuTensorVersions)));

    cutensor = buildCuTensorPackage rec {
      version = cudaToCutensor.${cudaMajorVersion} or latestVersion;
      inherit (cuTensorVersions.${version}) hash;
      # This can go into generic.nix
      libPath = "lib/${if cudaMajorVersion == "10" then cudaMajorMinorVersion else cudaMajorVersion}";
    };
  in { inherit cutensor; };

  extraPackagesExtension = final: prev: {

    nccl = final.callPackage ../development/libraries/science/math/nccl { };

    nccl-tests = final.callPackage ../development/libraries/science/math/nccl/tests.nix { };

    autoAddOpenGLRunpathHook = final.callPackage ( { makeSetupHook, addOpenGLRunpath }:
      makeSetupHook {
        name = "auto-add-opengl-runpath-hook";
        propagatedBuildInputs = [
          addOpenGLRunpath
        ];
      } ../development/compilers/cudatoolkit/auto-add-opengl-runpath-hook.sh
    ) {};

  };

  composedExtension = composeManyExtensions ([
    extraPackagesExtension
    (import ../development/compilers/cudatoolkit/extension.nix)
    (import ../development/compilers/cudatoolkit/redist/extension.nix)
    (import ../development/compilers/cudatoolkit/redist/overrides.nix)
    (import ../development/libraries/science/math/cudnn/extension.nix)
    (import ../development/libraries/science/math/tensorrt/extension.nix)
    (import ../test/cuda/cuda-samples/extension.nix)
    (import ../test/cuda/cuda-library-samples/extension.nix)
    cutensorExtension
  ]);

in (scope.overrideScope composedExtension)
