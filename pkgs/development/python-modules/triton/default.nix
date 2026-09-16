{
  lib,
  stdenv,
  pkgsHostHost,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # patches
  replaceVars,
  addDriverRunpath,
  cudaPackages,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,
  ninja,
  lit,
  llvm,
  writableTmpDirAsHomeHook,

  # buildInputs
  gtest,
  libxml2,
  ncurses,
  pybind11,
  zlib,

  # dependencies
  filelock,

  # passthru
  python,
  pytestCheckHook,
  torchWithRocm,
  runCommand,
  triton,
  rocmPackages,

  cudaSupport ? config.cudaSupport,
}:

let
  # The build compiler runs on BUILD; the installed JIT compiles and loads C
  # extensions on HOST. Select that compiler's HOST/HOST role explicitly.
  runtimeCC =
    if stdenv.buildPlatform == stdenv.hostPlatform then
      stdenv.cc
    else
      pkgsHostHost.targetPackages.stdenv.cc;
  runtimeCCExe = lib.getExe' runtimeCC "${runtimeCC.targetPrefix}cc";
in
buildPythonPackage (finalAttrs: {
  pname = "triton";
  version = "3.7.1";
  pyproject = true;
  __structuredAttrs = true;

  # Remember to bump triton-llvm as well!
  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2+NAHZZjFQxj+9UGiNpk4TVAKW6nydw1L1FTTJpNya4=";
  };

  patches = [
    (replaceVars ./0001-_build-allow-extra-cc-flags.patch {
      ccCmdExtraFlags = "-Wl,-rpath,${addDriverRunpath.driverLink}/lib";
    })
    (replaceVars ./0002-nvidia-driver-short-circuit-before-ldconfig.patch {
      libcudaStubsDir =
        if cudaSupport then
          "${lib.getOutput cudaPackages.cuda_cudart.outputStubs cudaPackages.cuda_cudart}/lib/stubs"
        else
          null;
    })
  ]
  ++ lib.optionals cudaSupport [
    (replaceVars ./0003-nvidia-cudart-a-systempath.patch {
      cudaToolkitIncludeDirs = "${lib.getInclude cudaPackages.cuda_cudart}/include";
    })
  ];

  postPatch =
    # Allow CMake 4
    # Upstream issue: https://github.com/triton-lang/triton/issues/8245
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "cmake>=3.20,<4.0" "cmake>=3.20"
    ''
    # Avoid downloading dependencies remove any downloads
    + ''
      substituteInPlace setup.py \
        --replace-fail "[get_json_package_info()]" "[]" \
        --replace-fail "[get_llvm_package_info()]" "[]" \
        --replace-fail 'yield ("triton.profiler", "third_party/proton/proton")' 'pass' \
        --replace-fail "curr_version.group(1) != version" "False"
    ''
    # Don't fetch googletest
    + ''
      substituteInPlace cmake/AddTritonUnitTest.cmake \
        --replace-fail "include(\''${PROJECT_SOURCE_DIR}/unittest/googletest.cmake)" ""\
        --replace-fail "include(GoogleTest)" "find_package(GTest REQUIRED)"
    ''

    # Hardcode the CC path so Triton's runtime JIT compilation doesn't break
    # in environments without a compiler in PATH.
    + ''
      substituteInPlace python/triton/runtime/build.py \
        --replace-fail \
          'cc = os.environ.get("CC")' \
          'cc = os.environ.get("CC", "${runtimeCCExe}")'
    ''

    # MLIRConfig selects its imported mlir-tblgen executable, which runs on HOST.
    # Table generation runs on BUILD, while MLIR's libraries still target HOST.
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'find_package(MLIR REQUIRED CONFIG PATHS ''${MLIR_DIR})' \
          'find_package(MLIR REQUIRED CONFIG PATHS ''${MLIR_DIR})
      set(MLIR_TABLEGEN_EXE "${lib.getExe' (llvm.__spliced.buildHost or llvm) "mlir-tblgen"}")'
    ''

    # triton will try dlopening libcublas.so at runtime
    + lib.optionalString cudaSupport ''
      substituteInPlace third_party/nvidia/include/cublas_instance.h \
        --replace-fail \
          '"libcublas.so"' \
          '"${lib.getLib cudaPackages.libcublas}/lib/libcublas.so"'
    '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja

    lit
    # Native tools, including mlir-tblgen, run during the build.
    llvm

    # Upstream's setup.py tries to write cache somewhere in ~/
    writableTmpDirAsHomeHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_SYSPATH" "${llvm}")

    # `find_package` is called with `NO_DEFAULT_PATH`
    # https://cmake.org/cmake/help/latest/command/find_package.html
    # https://github.com/triton-lang/triton/blob/c3c476f357f1e9768ea4e45aa5c17528449ab9ef/third_party/amd/CMakeLists.txt#L6
    (lib.cmakeFeature "LLD_DIR" "${lib.getLib llvm}/lib/cmake/lld")
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    (lib.cmakeFeature "LLVM_DIR" "${lib.getLib llvm}/lib/cmake/llvm")
    (lib.cmakeFeature "MLIR_DIR" "${lib.getLib llvm}/lib/cmake/mlir")
    (lib.cmakeFeature "Python3_INCLUDE_DIR" "${lib.getInclude python}/include/${python.libPrefix}")
  ];

  buildInputs = [
    gtest
    libxml2.dev
    ncurses
    pybind11
    zlib
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ llvm ];

  dependencies = [
    filelock
    # triton uses setuptools at runtime:
    # https://github.com/NixOS/nixpkgs/pull/286763/#discussion_r1480392652
    setuptools
  ];

  preBuild = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    # setup.py configures CMake after preConfigure hooks have added their flags.
    local tritonCmakeFlags=()
    concatTo tritonCmakeFlags cmakeFlags cmakeFlagsArray
    export TRITON_APPEND_CMAKE_ARGS="$(
      ${python.pythonOnBuildForHost.interpreter} -c \
        'import shlex, sys; print(shlex.join(sys.argv[1:]))' \
        "''${tritonCmakeFlags[@]}"
    )''${TRITON_APPEND_CMAKE_ARGS:+ $TRITON_APPEND_CMAKE_ARGS}"
  '';

  # `examples/plugins` (an MLIR example dialect plugin and a unit-test helper lib) is built
  # unconditionally with the Python module and shipped into `triton/plugins/`.
  # It is unused at runtime and keeps a forbidden RPATH reference to the build directory, which
  # fails the fixup phase.
  postInstall = ''
    rm -rf "$out/${python.sitePackages}/triton/plugins"
  ''
  + lib.optionalString cudaSupport ''
    # Upstream resolves these tools relative to the installed NVIDIA backend.
    local nvidiaBin="$out/${python.sitePackages}/triton/backends/nvidia/bin"
    mkdir -p "$nvidiaBin"
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} "$nvidiaBin/ptxas"
    ln -s ptxas "$nvidiaBin/ptxas-blackwell"
    ln -s ${lib.getExe' cudaPackages.cuda_cuobjdump "cuobjdump"} "$nvidiaBin/cuobjdump"
    ln -s ${lib.getExe' cudaPackages.cuda_nvdisasm "nvdisasm"} "$nvidiaBin/nvdisasm"
  '';

  env = {
    TRITON_BUILD_PROTON = "OFF";
    TRITON_OFFLINE_BUILD = true;
  }
  // lib.optionalAttrs cudaSupport {
    NIX_CFLAGS_COMPILE = toString [
      # Pybind11 started generating strange errors since python 3.12. Observed only in the CUDA branch.
      # https://gist.github.com/SomeoneSerge/7d390b2b1313957c378e99ed57168219#file-gistfile0-txt-L1042
      "-Wno-stringop-overread"
    ];
  };

  pythonRemoveDeps = [
    # Circular dependency, cf. https://github.com/triton-lang/triton/issues/1374
    "torch"

    # CLI tools without dist-info
    "cmake"
    "lit"
  ];

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;

  nativeCheckInputs = [ cmake ];
  preCheck = ''
    # build/temp* refers to build_ext.build_temp (looked up in the build logs)
    (cd ./build/temp* ; ctest)
  '';

  pythonImportsCheck = [
    "triton"
    "triton.language"
  ];

  passthru = {
    inherit cudaPackages;
    gpuCheck = stdenv.mkDerivation {
      pname = "triton-pytest";
      inherit (triton) version src;

      requiredSystemFeatures = [ "cuda" ];

      nativeBuildInputs = [
        (python.withPackages (ps: [
          ps.expecttest
          ps.scipy
          ps.torchWithCuda
          ps.triton-cuda
        ]))
      ];

      dontBuild = true;
      nativeCheckInputs = [
        pytestCheckHook
        writableTmpDirAsHomeHook
      ];

      doCheck = true;

      disabledTests = [
        # triton.runtime.errors.OutOfResources: out of resource: shared memory,
        # Required: 131072, Hardware limit: 101376. Reducing block sizes or `num_stages` may help.
        "test_gather"
        "test_gather_warp_shuffle"
        "test_tensor_descriptor_batched_gemm_2d_tma"
        "test_tensor_descriptor_batched_gemm_3d_tma"

        # AssertionError: assert all(delta == 0 for delta in diff.values())
        # ----------------------------- Captured stdout call -----------------------------
        # Expected line "pid (0, 0, 0) idx ( 0,   0) x: 1" 1 time(s), but saw 0 time(s)
        # ...
        "test_print"

        # This test ensures that the ptxas binary is available under .../site-packages/triton/backends/nvidia/bin/ptxas
        # Usually, this is where the install script downloads and copies ptxas to.
        # However, this is not the case here, as triton is built with TRITON_OFFLINE_BUILD=1
        # and TRITON_PTXAS_PATH=<path_to_nix_store_ptxas>
        "test_nvidia_tool"

        # Assertion `ctaLayout.getNumOutDims() == rank' failed in
        # TritonGPUAccelerateMatmul on Blackwell (compute capability 12.0).
        "test_batched_mxfp"
      ]
      ++ lib.optionals (pythonAtLeast "3.14") [
        # triton.compiler.errors.CompilationError
        # AttributeError("module 'ast' has no attribute 'Num'"
        "test_aggregate_modification_in_for_loop"
        "test_call"
        "test_call_in_loop"
        "test_compile_only_k_loop"
        "test_dot_mulbroadcasted"
        "test_globaltimer"
        "test_host_tensor_descriptor_matmul"
        "test_make_tensor_descriptor_matmul"
        "test_nested_while"
        "test_preshuffle_scale_mxfp_cdna4"
        "test_temp_var_in_loop"
        "test_tensor_descriptor_rank_reducing_matmul"
        "test_tensor_descriptor_reshape_matmul"

        # Python 3.14 adds an internal __annotate__ function which Triton 3.7
        # incorrectly includes in the aggregate dependency hash.
        "test_bound_unused_result"
        "test_aggregate_with_tuple"
      ];

      disabledTestPaths = [
        # torch.AcceleratorError: CUDA error: device-side assert triggered
        "python/test/unit/test_debug.py"

        # ptxas fatal   : Unexpected non-ASCII character encountered on line 1
        # ptxas fatal   : Ptx assembly aborted due to errors
        "python/test/unit/language/test_line_info.py"

        # Triton Error [CUDA]: \n
        "python/test/unit/tools/test_aot.py"

        # ptxas fatal   : Unknown option 'sass'
        "python/test/unit/tools/test_disasm.py"

        # assert 'mma.sync.aligned.m16n8k16.row.col.f32.f16.f16.f32' in ptx
        # AssertionError: assert 'mma.sync.aligned.m16n8k16.row.col.f32.f16.f16.f32' in ...
        "python/test/unit/language/test_core.py::test_dot[1-1-2-32-1-False-False-None-ieee-float8e5-float32-1-None]"

        # AssertionError: Tensor-likes are not close!
        "python/test/unit/language/test_core.py::test_scaled_dot[64-128-128-True-False-True-e4m3-fp16-4-16-1]"
      ];

      enabledTestPaths = [
        "python/test/unit"
      ];

      checkPhase = "pytestCheckPhase";

      installPhase = "touch $out";
    };

    tests = {
      # Ultimately, torch is our test suite:
      inherit torchWithRocm;

      # Test that _get_path_to_hip_runtime_dylib works when ROCm is available at runtime
      rocm-libamdhip64-path =
        runCommand "triton-rocm-libamdhip64-path-test"
          {
            buildInputs = [
              triton
              python
              rocmPackages.clr
            ];
          }
          ''
            python -c "
            import os
            import triton
            path = triton.backends.amd.driver._get_path_to_hip_runtime_dylib()
            print(f'libamdhip64 path: {path}')
            assert os.path.exists(path)
            " && touch $out
          '';

      # Test as `nix run -f "<nixpkgs>" python3Packages.triton.tests.axpy-cuda`
      # or, using `programs.nix-required-mounts`, as `nix build -f "<nixpkgs>" python3Packages.triton.tests.axpy-cuda.gpuCheck`
      axpy-cuda =
        cudaPackages.writeGpuTestPython
          {
            libraries = ps: [
              ps.triton
              ps.torch-no-triton
            ];

            gpuCheckArgs.nativeBuildInputs = [
              # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
              writableTmpDirAsHomeHook
            ];
          }
          ''
            # Adopted from Philippe Tillet https://triton-lang.org/main/getting-started/tutorials/01-vector-add.html

            import triton
            import triton.language as tl
            import torch
            import os

            @triton.jit
            def axpy_kernel(n, a: tl.constexpr, x_ptr, y_ptr, out, BLOCK_SIZE: tl.constexpr):
              pid = tl.program_id(axis=0)
              block_start = pid * BLOCK_SIZE
              offsets = block_start + tl.arange(0, BLOCK_SIZE)
              mask = offsets < n
              x = tl.load(x_ptr + offsets, mask=mask)
              y = tl.load(y_ptr + offsets, mask=mask)
              output = a * x + y
              tl.store(out + offsets, output, mask=mask)

            def axpy(a, x, y):
              output = torch.empty_like(x)
              assert x.is_cuda and y.is_cuda and output.is_cuda
              n_elements = output.numel()

              def grid(meta):
                return (triton.cdiv(n_elements, meta['BLOCK_SIZE']), )

              axpy_kernel[grid](n_elements, a, x, y, output, BLOCK_SIZE=1024)
              return output

            if __name__ == "__main__":
              if os.environ.get("HOME", None) == "/homeless-shelter":
                os.environ["HOME"] = os.environ.get("TMPDIR", "/tmp")
              torch.manual_seed(0)
              size = 12345
              x = torch.rand(size, device='cuda')
              y = torch.rand(size, device='cuda')
              output_torch = 3.14 * x + y
              output_triton = axpy(3.14, x, y)
              assert output_torch.sub(output_triton).abs().max().item() < 1e-6
              print("Triton axpy: OK")
          '';
    };
  };

  meta = {
    description = "Language and compiler for writing highly efficient custom Deep-Learning primitives";
    homepage = "https://github.com/triton-lang/triton";
    changelog = "https://github.com/triton-lang/triton/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      SomeoneSerge
      derdennisop
    ];
  };
})
