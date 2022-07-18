/*
    Test CUDA packages.

    This release file will not be tested on hydra.nixos.org
    because it requires unfree software.

    Test for example like this:

        $ hydra-eval-jobs pkgs/top-level/release-cuda.nix --option restrict-eval false -I foo=. --arg nixpkgs '{ outPath = ./.; revCount = 0; shortRev = "aabbcc"; }'

*/

{ # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "x86_64-linux"
  ]
, # Attributes passed to nixpkgs.
  nixpkgsArgs ? { config = { allowUnfree = true; inHydra = true; }; }
}:

with import ./release-lib.nix {inherit supportedSystems nixpkgsArgs; };
with lib;

let
  # Package sets to evaluate
  packageSets = [
    "cudaPackages_10_0"
    "cudaPackages_10_1"
    "cudaPackages_10_2"
    "cudaPackages_10"
    "cudaPackages_11_0"
    "cudaPackages_11_1"
    "cudaPackages_11_2"
    "cudaPackages_11_3"
    "cudaPackages_11_4"
    "cudaPackages_11_5"
    "cudaPackages_11_6"
    "cudaPackages_11"
    "cudaPackages"
  ];

  evalPackageSet = pset: mapTestOn { ${pset} = packagePlatforms pkgs.${pset}; };

  jobs = (mapTestOn ({
    # Packages to evaluate
    python3.pkgs.caffeWithCuda = linux;
    python3.pkgs.jaxlibWithCuda = linux;
    python3.pkgs.libgpuarray = linux;
    python3.pkgs.tensorflowWithCuda = linux;
    python3.pkgs.pyrealsense2WithCuda = linux;
    python3.pkgs.pytorchWithCuda = linux;
    python3.pkgs.jaxlib = linux;
  }) // (genAttrs packageSets evalPackageSet));

in jobs
