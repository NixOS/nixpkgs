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
  llvm = recurseIntoAttrs (callPackage ./llvm/default.nix { inherit rocmUpdateScript; });

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

  # Broken, too many errors
  rdc = callPackage ./rdc {
    inherit rocmUpdateScript rocm-smi rocm-runtime;
    # stdenv = llvm.rocmClangStdenv;
  };

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

  clr = callPackage ./clr {
    inherit rocmUpdateScript hip-common hipcc rocm-device-libs rocm-comgr rocm-runtime roctracer rocminfo;
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














  composable_kernel = callPackage ./composable_kernel {
    inherit (llvm) openmp clang-tools-extra;
    stdenv = llvm.rocmClangStdenv;
  };

  hipcub = callPackage ./hipcub {
    stdenv = llvm.rocmClangStdenv;
  };

  hipsparse = callPackage ./hipsparse {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  hipfort = callPackage ./hipfort {
    stdenv = llvm.rocmClangStdenv;
  };

  hipfft = callPackage ./hipfft {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  hipsolver = callPackage ./hipsolver {
    stdenv = llvm.rocmClangStdenv;
  };

  hipblas = callPackage ./hipblas {
    stdenv = llvm.rocmClangStdenv;
  };

  migraphx = callPackage ./migraphx {
    inherit (llvm) clang-tools-extra openmp;
    stdenv = llvm.rocmClangStdenv;
    rocmlir = rocmlir-rock;
  };

  rccl = callPackage ./rccl {
    stdenv = llvm.rocmClangStdenv;
  };

  rocalution = callPackage ./rocalution {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocsolver = callPackage ./rocsolver {
    stdenv = llvm.rocmClangStdenv;
  };

  rocmlir = callPackage ./rocmlir {
    stdenv = llvm.rocmClangStdenv;
  };

  rocmlir-rock = rocmlir.override {
    buildRockCompiler = true;
  };

  rocprim = callPackage ./rocprim {
    stdenv = llvm.rocmClangStdenv;
  };

  rocsparse = callPackage ./rocsparse {
    stdenv = llvm.rocmClangStdenv;
  };

  rocfft = callPackage ./rocfft {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocrand = callPackage ./rocrand {
    stdenv = llvm.rocmClangStdenv;
  };

  tensile = python3Packages.callPackage ./tensile {
    stdenv = llvm.rocmClangStdenv;
  };

  rocwmma = callPackage ./rocwmma {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rocblas = callPackage ./rocblas {
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  miopengemm = callPackage ./miopengemm {
    stdenv = llvm.rocmClangStdenv;
  };

  rocthrust = callPackage ./rocthrust {
    stdenv = llvm.rocmClangStdenv;
  };

  miopen = callPackage ./miopen {
    inherit (llvm) llvm clang-tools-extra;
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
}
