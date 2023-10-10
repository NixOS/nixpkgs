{ callPackage
, recurseIntoAttrs
, cudaPackages
, python3Packages
, elfutils
, boost179
}:

let
  rocmUpdateScript = callPackage ./update.nix { };
in rec {
  ## RadeonOpenCompute ##
  llvm = recurseIntoAttrs (callPackage ./llvm/default.nix { inherit rocmUpdateScript rocm-device-libs rocm-runtime rocm-thunk clr; });

  rocm-core = callPackage ./rocm-core {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  rocm-cmake = callPackage ./rocm-cmake {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  rocm-thunk = callPackage ./rocm-thunk {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  rocm-smi = python3Packages.callPackage ./rocm-smi {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  # Eventually will be in the LLVM repo
  rocm-device-libs = callPackage ./rocm-device-libs {
    inherit rocmUpdateScript rocm-cmake;
    stdenv = llvm.rocmClangStdenv;
  };

  rocm-runtime = callPackage ./rocm-runtime {
    inherit rocmUpdateScript rocm-device-libs rocm-thunk;
    stdenv = llvm.rocmClangStdenv;
  };

  # Eventually will be in the LLVM repo
  rocm-comgr = callPackage ./rocm-comgr {
    inherit rocmUpdateScript rocm-cmake rocm-device-libs;
    stdenv = llvm.rocmClangStdenv;
  };

  rocminfo = callPackage ./rocminfo {
    inherit rocmUpdateScript rocm-cmake rocm-runtime;
    stdenv = llvm.rocmClangStdenv;
  };

  clang-ocl = callPackage ./clang-ocl {
    inherit rocmUpdateScript rocm-cmake rocm-device-libs;
    stdenv = llvm.rocmClangStdenv;
  };

  # Unfree
  hsa-amd-aqlprofile-bin = callPackage ./hsa-amd-aqlprofile-bin {
    stdenv = llvm.rocmClangStdenv;
  };

  # Broken, too many errors
  rdc = callPackage ./rdc {
    inherit rocmUpdateScript rocm-smi rocm-runtime;
    # stdenv = llvm.rocmClangStdenv;
  };

  rocm-docs-core = python3Packages.callPackage ./rocm-docs-core { };

  ## ROCm-Developer-Tools ##
  hip-common = callPackage ./hip-common {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  # Eventually will be in the LLVM repo
  hipcc = callPackage ./hipcc {
    inherit rocmUpdateScript;
    stdenv = llvm.rocmClangStdenv;
  };

  # Replaces hip, opencl-runtime, and rocclr
  clr = callPackage ./clr {
    inherit rocmUpdateScript hip-common hipcc rocm-device-libs rocm-comgr rocm-runtime roctracer rocminfo rocm-smi;
    inherit (llvm) clang;
    stdenv = llvm.rocmClangStdenv;
  };

  hipify = callPackage ./hipify {
    inherit rocmUpdateScript;
    inherit (llvm) clang;
    stdenv = llvm.rocmClangStdenv;
  };

  # Needs GCC
  rocprofiler = callPackage ./rocprofiler {
    inherit (llvm) clang;
    inherit rocmUpdateScript clr rocm-thunk roctracer rocm-smi hsa-amd-aqlprofile-bin;
  };

  # Needs GCC
  roctracer = callPackage ./roctracer {
    inherit rocmUpdateScript rocm-device-libs rocm-runtime rocprofiler clr;
    inherit (llvm) clang;
  };

  # Needs GCC
  rocgdb = callPackage ./rocgdb {
    inherit rocmUpdateScript;
    elfutils = elfutils.override { enableDebuginfod = true; };
  };

  rocdbgapi = callPackage ./rocdbgapi {
    inherit rocmUpdateScript rocm-cmake rocm-comgr rocm-runtime;
    stdenv = llvm.rocmClangStdenv;
  };

  rocr-debug-agent = callPackage ./rocr-debug-agent {
    inherit rocmUpdateScript clr rocdbgapi;
    stdenv = llvm.rocmClangStdenv;
  };

  ## ROCmSoftwarePlatform ##
  rocprim = callPackage ./rocprim {
    inherit rocmUpdateScript rocm-cmake clr;
    stdenv = llvm.rocmClangStdenv;
  };

  rocsparse = callPackage ./rocsparse {
    inherit rocmUpdateScript rocm-cmake rocprim clr;
    stdenv = llvm.rocmClangStdenv;
  };

  rocthrust = callPackage ./rocthrust {
    inherit rocmUpdateScript rocm-cmake rocprim clr;
    stdenv = llvm.rocmClangStdenv;
  };

  rocrand = callPackage ./rocrand {
    inherit rocmUpdateScript rocm-cmake clr;
    stdenv = llvm.rocmClangStdenv;
  };

  hiprand = rocrand; # rocrand includes hiprand

  rocfft = callPackage ./rocfft {
    inherit rocmUpdateScript rocm-cmake rocrand rocfft clr;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rccl = callPackage ./rccl {
    inherit rocmUpdateScript rocm-cmake rocm-smi clr hipify;
    stdenv = llvm.rocmClangStdenv;
  };

  hipcub = callPackage ./hipcub {
    inherit rocmUpdateScript rocm-cmake rocprim clr;
    stdenv = llvm.rocmClangStdenv;
  };

  hipsparse = callPackage ./hipsparse {
    inherit rocmUpdateScript rocm-cmake rocsparse clr;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  hipfort = callPackage ./hipfort {
    inherit rocmUpdateScript rocm-cmake;
    stdenv = llvm.rocmClangStdenv;
  };

  hipfft = callPackage ./hipfft {
    inherit rocmUpdateScript rocm-cmake rocfft clr;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  tensile = python3Packages.callPackage ./tensile {
    inherit rocmUpdateScript rocminfo;
    stdenv = llvm.rocmClangStdenv;
  };

  rocblas = callPackage ./rocblas {
    inherit rocmUpdateScript rocm-cmake clr tensile;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocsolver = callPackage ./rocsolver {
    inherit rocmUpdateScript rocm-cmake rocblas rocsparse clr;
    stdenv = llvm.rocmClangStdenv;
  };

  rocwmma = callPackage ./rocwmma {
    inherit rocmUpdateScript rocm-cmake rocm-smi rocblas clr;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocalution = callPackage ./rocalution {
    inherit rocmUpdateScript rocm-cmake rocprim rocsparse rocrand rocblas clr;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocmlir = callPackage ./rocmlir {
    inherit rocmUpdateScript rocm-cmake clr;
    stdenv = llvm.rocmClangStdenv;
  };

  rocmlir-rock = rocmlir.override {
    buildRockCompiler = true;
  };

  hipsolver = callPackage ./hipsolver {
    inherit rocmUpdateScript rocm-cmake rocblas rocsolver clr;
    stdenv = llvm.rocmClangStdenv;
  };

  hipblas = callPackage ./hipblas {
    inherit rocmUpdateScript rocm-cmake rocblas rocsolver clr;
    stdenv = llvm.rocmClangStdenv;
  };

  # hipBlasLt - Very broken with Tensile at the moment, only supports GFX9
  # hipTensor - Only supports GFX9

  miopengemm = callPackage ./miopengemm {
    inherit rocmUpdateScript rocm-cmake clr;
    stdenv = llvm.rocmClangStdenv;
  };

  composable_kernel = callPackage ./composable_kernel {
    inherit rocmUpdateScript rocm-cmake clr;
    inherit (llvm) openmp clang-tools-extra;
    stdenv = llvm.rocmClangStdenv;
  };

  half = callPackage ./half {
    inherit rocmUpdateScript rocm-cmake;
    stdenv = llvm.rocmClangStdenv;
  };

  miopen = callPackage ./miopen {
    inherit rocmUpdateScript rocm-cmake rocblas clang-ocl miopengemm composable_kernel rocm-comgr clr rocm-docs-core half;
    inherit (llvm) clang-tools-extra;
    stdenv = llvm.rocmClangStdenv;
    rocmlir = rocmlir-rock;
    boost = boost179.override { enableStatic = true; };
  };

  miopen-hip = miopen.override {
    useOpenCL = false;
  };

  miopen-opencl = miopen.override {
    useOpenCL = true;
  };

  migraphx = callPackage ./migraphx {
    inherit rocmUpdateScript rocm-cmake rocblas composable_kernel miopengemm miopen clr half rocm-device-libs;
    inherit (llvm) openmp clang-tools-extra;
    stdenv = llvm.rocmClangStdenv;
    rocmlir = rocmlir-rock;
  };
}
