{
  cudaPackages,
  lib,
  pkgsHostHost,
  python,
  torch,
}:
let
  # Installed JIT tools execute on, and generate code for, the package's HOST.
  runtimePkgs = cudaPackages.pkgs.pkgsHostHost;
  cc = pkgsHostHost.targetPackages.stdenv.cc;
  nvcc = runtimePkgs.cudaPackages.cuda_nvcc;
in
(cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; }) {
  name = "torch-cpp-extension";
  libraries = [ torch ];
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      cc
      nvcc
      runtimePkgs.ninja
      runtimePkgs.bash
    ])
    "--set"
    "CXX"
    (lib.getExe' cc "${cc.targetPrefix}c++")
    "--set"
    "CUDA_HOME"
    (toString (lib.getBin nvcc))
    "--set-default"
    "TORCH_CUDA_ARCH_LIST"
    "native"
    "--set-default"
    "MAX_JOBS"
    "2"
  ];
} (builtins.readFile ./cpp-extension.py)
