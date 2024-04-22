{ gcc12Stdenv # FIXME: Try removing this with a new ROCm release https://github.com/NixOS/nixpkgs/issues/271943
, callPackage
, recurseIntoAttrs
, symlinkJoin
, fetchFromGitHub
, cudaPackages
, python3Packages
, elfutils
, boost179
, opencv
, ffmpeg_4
, libjpeg_turbo
, rapidjson-unstable
}:

let
  rocmUpdateScript = callPackage ./update.nix { };
in rec {
  ## ROCm ##
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
    stdenv = gcc12Stdenv;
    # stdenv = llvm.rocmClangStdenv;
  };

  rocm-docs-core = python3Packages.callPackage ./rocm-docs-core { stdenv = gcc12Stdenv; };

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
    inherit rocmUpdateScript clr rocm-core rocm-thunk rocm-device-libs roctracer rocdbgapi rocm-smi hsa-amd-aqlprofile-bin;
    inherit (llvm) clang;
    stdenv = gcc12Stdenv;
  };

  # Needs GCC
  roctracer = callPackage ./roctracer {
    inherit rocmUpdateScript rocm-device-libs rocm-runtime clr;
    stdenv = gcc12Stdenv;
  };

  # Needs GCC
  rocgdb = callPackage ./rocgdb {
    inherit rocmUpdateScript;
    elfutils = elfutils.override { enableDebuginfod = true; };
    stdenv = gcc12Stdenv;
  };

  rocdbgapi = callPackage ./rocdbgapi {
    inherit rocmUpdateScript rocm-cmake rocm-comgr rocm-runtime;
    stdenv = llvm.rocmClangStdenv;
  };

  rocr-debug-agent = callPackage ./rocr-debug-agent {
    inherit rocmUpdateScript clr rocdbgapi;
    stdenv = llvm.rocmClangStdenv;
  };

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
    inherit rocblas rocmUpdateScript rocm-cmake clr tensile;
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

  rpp = callPackage ./rpp {
    inherit rocmUpdateScript rocm-cmake rocm-docs-core clr half;
    inherit (llvm) openmp;
    stdenv = llvm.rocmClangStdenv;
  };

  rpp-hip = rpp.override {
    useOpenCL = false;
    useCPU = false;
  };

  rpp-opencl = rpp.override {
    useOpenCL = true;
    useCPU = false;
  };

  rpp-cpu = rpp.override {
    useOpenCL = false;
    useCPU = true;
  };

  mivisionx = callPackage ./mivisionx {
    inherit rocmUpdateScript rocm-cmake rocm-device-libs clr rpp rocblas miopengemm miopen migraphx half rocm-docs-core;
    inherit (llvm) clang openmp;
    opencv = opencv.override { enablePython = true; };
    ffmpeg = ffmpeg_4;
    rapidjson = rapidjson-unstable;
    stdenv = llvm.rocmClangStdenv;

    # Unfortunately, rocAL needs a custom libjpeg-turbo until further notice
    # See: https://github.com/ROCm/MIVisionX/issues/1051
    libjpeg_turbo = libjpeg_turbo.overrideAttrs {
      version = "2.0.6.1";

      src = fetchFromGitHub {
        owner = "rrawther";
        repo = "libjpeg-turbo";
        rev = "640d7ee1917fcd3b6a5271aa6cf4576bccc7c5fb";
        sha256 = "sha256-T52whJ7nZi8jerJaZtYInC2YDN0QM+9tUDqiNr6IsNY=";
      };

      # overwrite all patches, since patches for newer version do not apply
      patches = [ ../6/0001-Compile-transupp.c-as-part-of-the-library.patch ];
    };
  };

  mivisionx-hip = mivisionx.override {
    rpp = rpp-hip;
    useOpenCL = false;
    useCPU = false;
  };

  mivisionx-opencl = mivisionx.override {
    rpp = rpp-opencl;
    miopen = miopen-opencl;
    useOpenCL = true;
    useCPU = false;
  };

  mivisionx-cpu = mivisionx.override {
    rpp = rpp-cpu;
    useOpenCL = false;
    useCPU = true;
  };

  ## Meta ##
  # Emulate common ROCm meta layout
  # These are mainly for users. I strongly suggest NOT using these in nixpkgs derivations
  # Don't put these into `propagatedBuildInputs` unless you want PATH/PYTHONPATH issues!
  # See: https://rocm.docs.amd.com/en/docs-5.7.1/_images/image.004.png
  # See: https://rocm.docs.amd.com/en/docs-5.7.1/deploy/linux/os-native/package_manager_integration.html
  meta = rec {
    rocm-developer-tools = symlinkJoin {
      name = "rocm-developer-tools-meta";

      paths = [
        hsa-amd-aqlprofile-bin
        rocm-core
        rocr-debug-agent
        roctracer
        rocdbgapi
        rocprofiler
        rocgdb
        rocm-language-runtime
      ];
    };

    rocm-ml-sdk = symlinkJoin {
      name = "rocm-ml-sdk-meta";

      paths = [
        rocm-core
        miopen-hip
        rocm-hip-sdk
        rocm-ml-libraries
      ];
    };

    rocm-ml-libraries = symlinkJoin {
      name = "rocm-ml-libraries-meta";

      paths = [
        llvm.clang
        llvm.mlir
        llvm.openmp
        rocm-core
        miopen-hip
        rocm-hip-libraries
      ];
    };

    rocm-hip-sdk = symlinkJoin {
      name = "rocm-hip-sdk-meta";

      paths = [
        rocprim
        rocalution
        hipfft
        rocm-core
        hipcub
        hipblas
        rocrand
        rocfft
        rocsparse
        rccl
        rocthrust
        rocblas
        hipsparse
        hipfort
        rocwmma
        hipsolver
        rocsolver
        rocm-hip-libraries
        rocm-hip-runtime-devel
      ];
    };

    rocm-hip-libraries = symlinkJoin {
      name = "rocm-hip-libraries-meta";

      paths = [
        rocblas
        hipfort
        rocm-core
        rocsolver
        rocalution
        rocrand
        hipblas
        rocfft
        hipfft
        rccl
        rocsparse
        hipsparse
        hipsolver
        rocm-hip-runtime
      ];
    };

    rocm-openmp-sdk = symlinkJoin {
      name = "rocm-openmp-sdk-meta";

      paths = [
        rocm-core
        llvm.clang
        llvm.mlir
        llvm.openmp # openmp-extras-devel (https://github.com/ROCm/aomp)
        rocm-language-runtime
      ];
    };

    rocm-opencl-sdk = symlinkJoin {
      name = "rocm-opencl-sdk-meta";

      paths = [
        rocm-core
        rocm-runtime
        clr
        clr.icd
        rocm-thunk
        rocm-opencl-runtime
      ];
    };

    rocm-opencl-runtime = symlinkJoin {
      name = "rocm-opencl-runtime-meta";

      paths = [
        rocm-core
        clr
        clr.icd
        rocm-language-runtime
      ];
    };

    rocm-hip-runtime-devel = symlinkJoin {
      name = "rocm-hip-runtime-devel-meta";

      paths = [
        clr
        rocm-core
        hipify
        rocm-cmake
        llvm.clang
        llvm.mlir
        llvm.openmp
        rocm-thunk
        rocm-runtime
        rocm-hip-runtime
      ];
    };

    rocm-hip-runtime = symlinkJoin {
      name = "rocm-hip-runtime-meta";

      paths = [
        rocm-core
        rocminfo
        clr
        rocm-language-runtime
      ];
    };

    rocm-language-runtime = symlinkJoin {
      name = "rocm-language-runtime-meta";

      paths = [
        rocm-runtime
        rocm-core
        rocm-comgr
        llvm.openmp # openmp-extras-runtime (https://github.com/ROCm/aomp)
      ];
    };

    rocm-all = symlinkJoin {
      name = "rocm-all-meta";

      paths = [
        rocm-developer-tools
        rocm-ml-sdk
        rocm-ml-libraries
        rocm-hip-sdk
        rocm-hip-libraries
        rocm-openmp-sdk
        rocm-opencl-sdk
        rocm-opencl-runtime
        rocm-hip-runtime-devel
        rocm-hip-runtime
        rocm-language-runtime
      ];
    };
  };
}
