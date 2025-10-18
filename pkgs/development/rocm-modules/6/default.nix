{
  lib,
  config,
  callPackage,
  newScope,
  recurseIntoAttrs,
  symlinkJoin,
  fetchFromGitHub,
  boost179,
  opencv,
  python3Packages,
  openmpi,
  stdenv,
  pkgs,
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      inherit (self) llvm;
      origStdenv = stdenv;
      pyPackages = python3Packages;
      openmpi-orig = openmpi;
      rocmClangStdenv = llvm.rocmClangStdenv;
    in
    {
      inherit rocmClangStdenv;
      stdenv = rocmClangStdenv;
      buildTests = false;
      buildBenchmarks = false;

      rocmUpdateScript = self.callPackage ./update.nix { };

      ## ROCm ##
      llvm = recurseIntoAttrs (
        callPackage ./llvm/default.nix {
          # rocm-device-libs is used for .src only
          # otherwise would cause infinite recursion
          inherit (self) rocm-device-libs;
        }
      );
      inherit (self.llvm) rocm-toolchain clang openmp;

      rocm-core = self.callPackage ./rocm-core { stdenv = origStdenv; };

      rocm-cmake = self.callPackage ./rocm-cmake { stdenv = origStdenv; };

      rocm-device-libs = self.callPackage ./rocm-device-libs { };

      rocm-runtime = self.callPackage ./rocm-runtime {
        stdenv = origStdenv;
      };

      rocm-comgr = self.callPackage ./rocm-comgr { };

      rocminfo = self.callPackage ./rocminfo { stdenv = origStdenv; };

      amdsmi = pyPackages.callPackage ./amdsmi {
        inherit (self) rocmUpdateScript;
      };

      rocm-smi = pyPackages.callPackage ./rocm-smi {
        inherit (self) rocmUpdateScript;
      };

      aqlprofile = self.callPackage ./aqlprofile { };

      rdc = self.callPackage ./rdc { };

      rocm-docs-core = python3Packages.callPackage ./rocm-docs-core { };

      hip-common = self.callPackage ./hip-common { };

      hipcc = self.callPackage ./hipcc { stdenv = origStdenv; };

      # Replaces hip, opencl-runtime, and rocclr
      clr = self.callPackage ./clr { };

      aotriton = self.callPackage ./aotriton { stdenv = origStdenv; };

      hipify = self.callPackage ./hipify {
        stdenv = origStdenv;
      };

      # hsakmt was merged into rocm-runtime
      hsakmt = self.rocm-runtime;

      rocprofiler = self.callPackage ./rocprofiler {
        inherit (llvm) clang;
      };
      rocprofiler-register = self.callPackage ./rocprofiler-register {
        inherit (llvm) clang;
      };

      roctracer = self.callPackage ./roctracer { };

      rocgdb = self.callPackage ./rocgdb { };

      rocdbgapi = self.callPackage ./rocdbgapi { };

      rocr-debug-agent = self.callPackage ./rocr-debug-agent { };

      rocprim = self.callPackage ./rocprim { };

      rocsparse = self.callPackage ./rocsparse { };

      rocthrust = self.callPackage ./rocthrust { };

      rocrand = self.callPackage ./rocrand { };

      hiprand = self.callPackage ./hiprand { };

      rocfft = self.callPackage ./rocfft { };

      mscclpp = self.callPackage ./mscclpp { };

      rccl = self.callPackage ./rccl { };

      hipcub = self.callPackage ./hipcub { };

      hipsparse = self.callPackage ./hipsparse { };

      hipfort = self.callPackage ./hipfort { };

      hipfft = self.callPackage ./hipfft { };

      hiprt = self.callPackage ./hiprt { };

      tensile = pyPackages.callPackage ./tensile {
        inherit (self)
          rocmUpdateScript
          clr
          ;
      };

      rocblas = self.callPackage ./rocblas {
        buildTests = true;
        buildBenchmarks = true;
      };

      rocsolver = self.callPackage ./rocsolver { };

      rocwmma = self.callPackage ./rocwmma { };

      rocalution = self.callPackage ./rocalution { };

      rocmlir-rock = self.callPackage ./rocmlir {
        buildRockCompiler = true;
      };
      rocmlir = self.rocmlir-rock;

      hipsolver = self.callPackage ./hipsolver { };

      hipblas-common = self.callPackage ./hipblas-common { };

      hipblas = self.callPackage ./hipblas { };

      hipblaslt = self.callPackage ./hipblaslt { };

      # hipTensor - Only supports GFX9

      composable_kernel_base = self.callPackage ./composable_kernel/base.nix { };
      composable_kernel = self.callPackage ./composable_kernel { };

      ck4inductor = pyPackages.callPackage ./composable_kernel/ck4inductor.nix {
        inherit (self) composable_kernel rocm-toolchain;
      };

      half = self.callPackage ./half { };

      miopen = self.callPackage ./miopen {
        boost = boost179.override { enableStatic = true; };
      };

      miopen-hip = self.miopen;

      migraphx = self.callPackage ./migraphx { stdenv = origStdenv; };

      rpp = self.callPackage ./rpp { };

      rpp-hip = self.rpp.override {
        useOpenCL = false;
        useCPU = false;
      };

      rpp-opencl = self.rpp.override {
        useOpenCL = true;
        useCPU = false;
      };

      rpp-cpu = self.rpp.override {
        useOpenCL = false;
        useCPU = true;
      };

      mivisionx = self.callPackage ./mivisionx {
        stdenv = origStdenv;
        opencv = opencv.override { enablePython = true; };
      };

      mivisionx-hip = self.mivisionx.override {
        rpp = self.rpp-hip;
        useOpenCL = false;
        useCPU = false;
      };

      mivisionx-cpu = self.mivisionx.override {
        rpp = self.rpp-cpu;
        useOpenCL = false;
        useCPU = true;
      };

      # Even if config.rocmSupport is false we need rocmSupport true
      # version of ucc/ucx in openmpi in this package set
      openmpi = openmpi-orig.override (
        prev:
        let
          ucx = prev.ucx.override {
            enableCuda = false;
            enableRocm = true;
          };
        in
        {
          inherit ucx;
          ucc = prev.ucc.override {
            enableCuda = false;
            inherit ucx;
          };
        }
      );
      mpi = self.openmpi;

      ## Meta ##
      # Emulate common ROCm meta layout
      # These are mainly for users. I strongly suggest NOT using these in nixpkgs derivations
      # Don't put these into `propagatedBuildInputs` unless you want PATH/PYTHONPATH issues!
      # See: https://rocm.docs.amd.com/en/docs-5.7.1/_images/image.004.png
      # See: https://rocm.docs.amd.com/en/docs-5.7.1/deploy/linux/os-native/package_manager_integration.html
      meta = with self; rec {
        # eval all pkgsRocm release attrs with
        # nix-eval-jobs --force-recurse pkgs/top-level/release.nix -I . --select "p: p.pkgsRocm" --no-instantiate
        release-attrPaths = (builtins.fromJSON (builtins.readFile ./release-attrPaths.json)).attrPaths;
        release-packagePlatforms =
          let
            platforms = [
              "x86_64-linux"
            ];
          in
          lib.foldl' (
            acc: path:
            if lib.hasAttrByPath (lib.splitString "." path) pkgs then
              lib.recursiveUpdate acc (lib.setAttrByPath (lib.splitString "." path) platforms)
            else
              acc
          ) { } self.meta.release-attrPaths;

        rocm-developer-tools = symlinkJoin {
          name = "rocm-developer-tools-meta";
          paths = [
            aqlprofile
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
            hiprt
            rocm-core
            hipcub
            hipblas
            hipblaslt
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
            hipblaslt
            rocfft
            hipfft
            hiprt
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
            llvm.openmp
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

      rocm-bandwidth-test = self.callPackage ./rocm-bandwidth-test {
        rocmPackages = self;
      };

      rocm-tests = self.callPackage ./rocm-tests {
        rocmPackages = self;
      };
    }
    // lib.optionalAttrs config.allowAliases {
      rocmPath = throw ''
        'rocm-path' has been removed. If a ROCM_PATH value is required in nixpkgs please
        construct one with the minimal set of required deps.
        For convenience use outside of nixpkgs consider one of the entries in
        'rocmPackages.meta'.
      ''; # Added 2025-09-30

      rocm-merged-llvm = throw ''
        'rocm-merged-llvm' has been removed.
        For 'libllvm' or 'libclang' use 'rocmPackages.llvm.libllvm/clang'.
        For a ROCm compiler toolchain use 'rocmPackages.rocm-toolchain'.
        If a package uses '$<TARGET_FILE:clang>' in CMake from 'libclang'
        it may be necessary to convince it to use 'rocm-toolchain' instead.
        'rocm-merged-llvm' avoided this at the cost of significantly bloating closure
        size.
      ''; # Added 2025-09-30

      hsa-amd-aqlprofile-bin = lib.warn ''
        'hsa-amd-aqlprofile-bin' has been replaced by 'aqlprofile'.
      '' self.aqlprofile; # Added 2025-08-27

      triton = throw ''
        'rocmPackages.triton' has been removed. Please use python3Packages.triton
      ''; # Added 2025-08-24

      rocm-thunk = throw ''
        'rocm-thunk' has been removed. It's now part of the ROCm runtime.
      ''; # Added 2025-3-16

      clang-ocl = throw ''
        'clang-ocl' has been deprecated upstream. Use ROCm's clang directly.
      ''; # Added 2025-3-16

      miopengemm = throw ''
        'miopengemm' has been deprecated.
      ''; # Added 2024-3-3

      miopen-opencl = throw ''
        'miopen-opencl' has been deprecated.
      ''; # Added 2024-3-3

      mivisionx-opencl = throw ''
        'mivisionx-opencl' has been deprecated.
        Other versions of mivisionx are still available.
      ''; # Added 2024-3-24
    }
  );
  scopeForArches =
    arches:
    outer.overrideScope (
      _final: prev: {
        clr = prev.clr.override {
          localGpuTargets = arches;
        };
      }
    );
in
outer
// builtins.listToAttrs (
  map (arch: {
    name = arch;
    value = scopeForArches [ arch ];
  }) outer.clr.gpuTargets
)
// {
  gfx9 = scopeForArches [
    "gfx906"
    "gfx908"
    "gfx90a"
    "gfx942"
  ];
  gfx10 = scopeForArches [
    "gfx1010"
    "gfx1030"
  ];
  gfx11 = scopeForArches [
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1151"
  ];
  gfx12 = scopeForArches [
    "gfx1200"
    "gfx1201"
  ];
}
