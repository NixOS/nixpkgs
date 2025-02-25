{
  lib,
  callPackage,
  newScope,
  recurseIntoAttrs,
  symlinkJoin,
  fetchFromGitHub,
  boost179,
  opencv,
  ffmpeg_4,
  libjpeg_turbo,
  python3Packages,
  gcc13Stdenv,
  triton-llvm,
  openmpi,
  rocmGpuArches ? [ ],
}:

let
  outer = lib.makeScope newScope (
    self:
    let
      pyPackages = python3Packages;
      openmpi-orig = openmpi;
      llvm = self.llvm;
    in
    {
      inherit rocmGpuArches;
      buildTests = false;
      buildBenchmarks = false;
      # stdenv = llvm.rocmClangStdenv;

      rocmPath = self.callPackage ./rocm-path { };
      rocmUpdateScript = self.callPackage ./update.nix { };

      ## ROCm ##
      llvm = recurseIntoAttrs (
        callPackage ./llvm/default.nix {
          inherit (self)
            clr
            rocm-thunk
            rocm-device-libs
            rocm-runtime
            rocmUpdateScript;
        }
      );
      inherit (self.llvm) rocm-llvm rocm-clang openmp;

      rocm-core = self.callPackage ./rocm-core { };
      amdsmi = pyPackages.callPackage ./amdsmi {
        inherit (self) rocmUpdateScript;
      };

      rocm-cmake = self.callPackage ./rocm-cmake { };

      rocm-smi = pyPackages.callPackage ./rocm-smi {
        inherit (self) rocmUpdateScript;
      };

      rocm-device-libs = self.callPackage ./rocm-device-libs {
        inherit (self) rocm-llvm;
      };

      rocm-runtime = self.callPackage ./rocm-runtime {
        inherit (self) rocm-llvm;
      };

      rocm-comgr = self.callPackage ./rocm-comgr {
        inherit (self) rocm-llvm;
      };

      rocminfo = self.callPackage ./rocminfo { };

      # Unfree
      hsa-amd-aqlprofile-bin = self.callPackage ./hsa-amd-aqlprofile-bin { };

      rdc = self.callPackage ./rdc { };

      rocm-docs-core = python3Packages.callPackage ./rocm-docs-core { };

      hip-common = self.callPackage ./hip-common { };

      # Eventually will be in the LLVM repo
      hipcc = self.callPackage ./hipcc {
        inherit (self) rocm-llvm;
      };

      # Replaces hip, opencl-runtime, and rocclr
      clr = self.callPackage ./clr {
        inherit (self) rocm-llvm rocm-clang;
      };

      aotriton = self.callPackage ./aotriton { };

      hipify = self.callPackage ./hipify {
        inherit (self) rocm-llvm rocm-clang;
      };

      # hsakmt was merged into rocm-runtime
      hsakmt = self.rocm-runtime;

      rocprofiler = self.callPackage ./rocprofiler {
        inherit (self) rocm-clang;
      };
      rocprofiler-register = self.callPackage ./rocprofiler-register {
        inherit (self) rocm-clang;
      };

      # Needs GCC
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

      # RCCL with sanitizers and tests
      # Can't have with sanitizer build as dep of other packages without
      # runtime crashes due to ASAN not loading first
      rccl-tests = self.callPackage ./rccl {
        buildTests = true;
      };

      hipcub = self.callPackage ./hipcub { };

      hipsparse = self.callPackage ./hipsparse { };

      hipfort = self.callPackage ./hipfort { };

      hipfft = self.callPackage ./hipfft { };

      tensile = pyPackages.callPackage ./tensile {
        inherit (self)
          rocmUpdateScript
          rocminfo
          ;
      };

      rocblas = self.callPackage ./rocblas {
        inherit (self) rocm-llvm;
        buildTests = true;
        buildBenchmarks = true;
      };

      rocsolver = self.callPackage ./rocsolver { };

      rocwmma = self.callPackage ./rocwmma { };

      rocalution = self.callPackage ./rocalution { };

      rocmlir = self.callPackage ./rocmlir {
        buildRockCompiler = true;
      };

      hipsolver = self.callPackage ./hipsolver { };

      hipblas-common = self.callPackage ./hipblas-common { };

      hipblas = self.callPackage ./hipblas { };

      hipblaslt = self.callPackage ./hipblaslt { };

      # hipTensor - Only supports GFX9

      composable_kernel = self.callPackage ./composable_kernel { };
      ck4inductor = pyPackages.callPackage ./composable_kernel/ck4inductor.nix {
        inherit (self) composable_kernel rocm-llvm;
      };

      half = self.callPackage ./half { };

      miopen = self.callPackage ./miopen {
        boost = boost179.override { enableStatic = true; };
      };

      miopen-hip = self.miopen;

      migraphx = self.callPackage ./migraphx { };

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
        inherit (llvm) clang;
        opencv = opencv.override { enablePython = true; };
        ffmpeg = ffmpeg_4;
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
          patches = [ ./0001-Compile-transupp.c-as-part-of-the-library.patch ];
        };
      };

      mivisionx-hip = self.mivisionx.override {
        rpp = self.rpp-hip;
        useOpenCL = false;
        useCPU = false;
      };

      # mivisionx-opencl = throw ''
      #   'mivisionx-opencl' has been deprecated.
      #   Other versions of mivisionx are still available.
      #   It is also still available for some time as part of rocmPackages_5.
      # ''; # Added 2024-3-24

      mivisionx-cpu = self.mivisionx.override {
        rpp = self.rpp-cpu;
        useOpenCL = false;
        useCPU = true;
      };

      openmpi = openmpi-orig.override (prev: {
        ucx = prev.ucx.override {
          enableCuda = false;
          enableRocm = true;
        };
      });
      mpi = self.openmpi;

      triton-llvm =
        (triton-llvm.override {
          # Workaround https://github.com/NixOS/nixpkgs/issues/363965 so we can test
          # not root caused
          buildTests = false;
        }).overrideAttrs
          {
            src = fetchFromGitHub {
              owner = "llvm";
              repo = "llvm-project";
              # make sure this matches triton llvm rel branch hash for now
              # https://github.com/triton-lang/triton/blob/release/3.2.x/cmake/llvm-hash.txt
              rev = "86b69c31642e98f8357df62c09d118ad1da4e16a";
              hash = "sha256-W/mQwaLGx6/rIBjdzUTIbWrvGjdh7m4s15f70fQ1/hE=";
            };
            pname = "triton-llvm-rocm";
            patches = [ ]; # FIXME: https://github.com/llvm/llvm-project//commit/84837e3cc1cf17ed71580e3ea38299ed2bfaa5f6.patch doesn't apply, may need to rebase
          };

      triton =
        (pyPackages.triton-no-cuda.override (_old: {
          rocmPackages = self;
          rocmSupport = true;
          # buildPythonPackage = x: old.buildPythonPackage (x // { stdenv = llvmPackagesRocm.rocmClangStdenv;});
          stdenv = self.llvm.rocmClangStdenv;
          llvm = self.triton-llvm;
        })).overridePythonAttrs
          (old: {
            doCheck = false;
            stdenv = self.llvm.rocmClangStdenv;
            version = "3.2.0";
            src = fetchFromGitHub {
              owner = "triton-lang";
              repo = "triton";
              rev = "64b80f0916b69e3c4d0682a2368fd126e57891ab"; # "release/3.2.x";
              hash = "sha256-xQOgMLHruVrI/9FtY3TvZKALitMOfqZ69uOyrYhXhu8=";
            };
            buildInputs = old.buildInputs ++ [
              self.clr
            ];
            dontStrip = true;
            env = old.env // {
              CXXFLAGS = "-O3 -I${self.clr}/include -I/build/source/third_party/triton/third_party/nvidia/backend/include";
              TRITON_OFFLINE_BUILD = 1;
            };
            patches = [ ];
            postPatch = ''
              # Need an empty cuda.h to happily compile for ROCm
              mkdir -p third_party/nvidia/include/ third_party/nvidia/include/backend/include/
              echo "" > third_party/nvidia/include/cuda.h
              touch third_party/nvidia/include/backend/include/{cuda,driver_types}.h
              rm -rf third_party/nvidia
              substituteInPlace CMakeLists.txt \
                --replace-fail "add_subdirectory(test)" ""
              sed -i '/nvidia\|NVGPU\|registerConvertTritonGPUToLLVMPass\|mlir::test::/Id' bin/RegisterTritonDialects.h
              sed -i '/TritonTestAnalysis/Id' bin/CMakeLists.txt
              substituteInPlace python/setup.py \
                --replace-fail 'backends = [*BackendInstaller.copy(["nvidia", "amd"]), *BackendInstaller.copy_externals()]' \
                'backends = [*BackendInstaller.copy(["amd"]), *BackendInstaller.copy_externals()]'
              #cp ''${cudaPackages.cuda_cudart}/include/*.h third_party/nvidia/backend/include/
              find . -type f -exec sed -i 's|[<]cupti.h[>]|"cupti.h"|g' {} +
              find . -type f -exec sed -i 's|[<]cuda.h[>]|"cuda.h"|g' {} +
              # remove any downloads
              substituteInPlace python/setup.py \
                --replace-fail "[get_json_package_info()]" "[]"\
                --replace-fail "[get_llvm_package_info()]" "[]"\
                --replace-fail "curr_version != version" "False"
              # Don't fetch googletest
              substituteInPlace cmake/AddTritonUnitTest.cmake \
                --replace-fail 'include(''${PROJECT_SOURCE_DIR}/unittest/googletest.cmake)' "" \
                --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
              substituteInPlace third_party/amd/backend/compiler.py \
                --replace-fail '"/opt/rocm/llvm/bin/ld.lld"' "os.environ['ROCM_PATH']"' + "/llvm/bin/ld.lld"'
            '';
          });

      ## Meta ##
      # Emulate common ROCm meta layout
      # These are mainly for users. I strongly suggest NOT using these in nixpkgs derivations
      # Don't put these into `propagatedBuildInputs` unless you want PATH/PYTHONPATH issues!
      # See: https://rocm.docs.amd.com/en/docs-5.7.1/_images/image.004.png
      # See: https://rocm.docs.amd.com/en/docs-5.7.1/deploy/linux/os-native/package_manager_integration.html
      meta = with self; rec {
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
            rocm-clang
            rocm-llvm
            openmp
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
            rocm-clang
            rocm-llvm
            openmp # openmp-extras-devel (https://github.com/ROCm/aomp)
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
            rocm-clang
            rocm-llvm
            openmp
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

      rocm-tests = self.callPackage ./rocm-tests {
        rocmPackages = self;
      };
    }
  );
  scopeForArches =
    arches:
    outer.overrideScope (
      final: prev: {
        clr = prev.clr.override {
          localGpuTargets = arches;
        };
      }
    );
in
outer
// builtins.listToAttrs (
  builtins.map (arch: {
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
  ];
}
